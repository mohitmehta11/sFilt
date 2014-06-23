k=1;

TRAIN_FRACS = .1:.1:.9;

RUNS_PER_FRAC = 10;
NUM_TRAIN_FRACS = length(TRAIN_FRACS);
DIRNAME ='../Data/enron1';

testErrorMat     = zeros(RUNS_PER_FRAC, NUM_TRAIN_FRACS);

testFalsePosMat  = zeros(RUNS_PER_FRAC, NUM_TRAIN_FRACS);

for iTrainFrac = 1:NUM_TRAIN_FRACS
    trainFrac = TRAIN_FRACS(iTrainFrac)
    for run=1:RUNS_PER_FRAC
        display(run);
        fname = sprintf('%s/%s_%g_%g.txt',DIRNAME,'train',trainFrac,run-1);
        train = importdata(fname);
        fname = sprintf('%s/%s_%g_%g.txt',DIRNAME,'test', trainFrac,run-1);
        test  = importdata(fname);
                

        trainVectors = train(:,1:end-1);

        trainLabels = train(:,end);

        trainLabels = 2*trainLabels - 1;
        

        testVectors = test(:,1:end-1);

        testLabels = test(:,end);

        testLabels = 2*testLabels - 1;
        
                

        [testErrorMat(run,iTrainFrac), ...
         testFalsePosMat(run,iTrainFrac)] ...
            = knnClassify(trainVectors, trainLabels, testVectors, testLabels, k, 0.5);
                
    end
end


meanTestErrorMat = mean(testErrorMat, 1);
meanTestFalsePosMat= mean(testFalsePosMat, 1);

save knn_set3.mat meanTestErrorMat meanTestFalsePosMat;

h = figure; 
hold on;

plot(TRAIN_FRACS,meanTestErrorMat, 'r-o');
plot(TRAIN_FRACS,meanTestFalsePosMat, 'g-o');
xlabel('Training Fraction');
ylabel('Error rate');
legend('Test', 'false pos');
txt = sprintf('K=%d, Average of %d runs per training size', k, RUNS_PER_FRAC);
title(txt)
fname = sprintf('results_%s.fig', datestr(now, 'dd.mm.yy_HH.MM.SS'));
saveas(h, fname);
