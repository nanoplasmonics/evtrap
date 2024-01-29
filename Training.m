clc
clear
%% input data and set the partitions
disp('[On] Program')
disp('[Start] Loading data')
load("data.mat");
numObservations = numel(data_new);
[idxTrain,idxValidation,idxTest] = F_TrainingPartitions(numObservations,[0.5 0.3 0.2]);
for i = 1:size(data_new,2)
    Data{i} = data_new{i}(1,:);
    Labels{i} = data_new{i}(2,1);
end
disp('[Done] Loading data')
%% set up the train, validation and test dataset
disp('[Start] Training dataset setting')
XTrain = Data(idxTrain)';
TTrain = cell2mat(Labels(idxTrain));
TTrain = TTrain - 1;
TTrain = categorical(TTrain)';

XValidation = Data(idxValidation);
TValidation = cell2mat(Labels(idxValidation));
TValidation = TValidation - 1;
TValidation = categorical(TValidation)';

XTest = Data(idxTest);
TTest = cell2mat(Labels(idxTest));
TTest = TTest - 1;
TTest = categorical(TTest);
disp('[Done] Training dataset setting')
%% Training parameters setting
disp('[Start] Training parameters setting')
filterSize = 5;
numFilters = 32;
num_Features = 1;
num_Classes = 3;
layers = [ ...
    sequenceInputLayer(num_Features)
    convolution1dLayer(filterSize,numFilters,Padding="causal")
    reluLayer
    layerNormalizationLayer
    globalAveragePooling1dLayer
    fullyConnectedLayer(num_Classes)
    softmaxLayer
    classificationLayer];
miniBatchSize = 5;

options = trainingOptions("adam", ...
    MaxEpochs=200, ...
    InitialLearnRate=0.001, ...
    SequencePaddingDirection="left", ...
    ValidationData={XValidation,TValidation}, ...
    Plots="training-progress", ...
    Verbose=0);
disp('[Done] Training parameters setting')
disp('[Start] Training');
net = trainNetwork(XTrain,TTrain,layers,options);
disp('[Done] Training');
%% test the accuracy
disp('[Start] Testing')
YTest = classify(net,XTest, ...
    SequencePaddingDirection="left");
acc = mean(YTest == TTest');
figure
confusionchart(TTest,YTest)
disp('[Done] Testing')
disp('[Start] Net saving')
save net.mat net
disp('[Done] Net saving')
disp('[Off] Program')