# Machine Learning Application: Different types of extracellular vesicles classification by using trapping signal.
## Program Information
<p> This program was written for Matlab. There were four main programs: <strong>documents_separation.m, data_formation.m, training.m and Net_testing.m</strong>. They must be used in order.
And the total dataset needed to be formed and saved in the same path with the main programs. 
The program called <strong>Main.m</strong> was the trigger of the whole program, which ran all the programs automatically. </p>

<code>run Documents_separation.m
run Data_formation.m
run Training.m
run Net_testing.m</code>

<p> Programs with names <strong> F_ChannelCancel.m, F_DataFormation.m, F_DataFrom_dir.m, F_LengthNormalize.m, F_TrainingPartions.m</strong> were all function programs.
They had been used in the three main programs.


## Dataset Information
<p> In this program, the total dataset concluded 3 folders, each of the folder represent one kind of extracellular vesicle(EV). 
  And, each of the EV folder contained 50 documents of trapping data. All the data in the documents represented the features of trapping signals of different EVs.
  The total size of the dataset was 6Gb. It had been save as in the folder named <strong>'data_source'</strong>.
</p>

## Dataset separation
<p> In the training part, in order to enhance the generalization ability of the network, four files of data of each EV had been selected out randomly, 
  which would be used for and extra testing. And all the other documents will be regarded as training dataset.
<strong>Documents_separation.m</strong> is used for this purpose. 

## Data formation
<p> 
  In order to gain a high reliable nerual network, separating a signal from one experiment into several frames can be useful.
  However, data documents of different experiments and different EVs had different length, which might create probelms in the framing part.
  So, a standardized data formation process is necessary. <strong>Data_formation.m</strong> is used for this purpose. 
  THe total data formation process had been divided into 3 steps.
</p>
  
<p>
  <strong>Step 1 Length Formation:</strong> All the siganls extracted from different documents would be transformed into the same length.
  Also the length should be divisible by the length of the frame.
</p>
<p><strong>Step 2 Data Framing:</strong> As for each signal, the data strings would be cut into numbers of specific length of frames.
</p>
<p><strong>Step 3 Down Sampling:</strong> All the data had a high sampling rate (100,000 Hz), which made the feature/characteristics of the signal not significant enough.
Down sampling was a method to solve this problem. As for each frame, a down sampling process from 100,000 Hz to 500 Hz was conducted.
</p>

## Training
<p>
  In this program, all the data would be labeled, a specific model would be constructed, and then the training conducted.
</p>
<p> The model was constructed as a classifier for time-domain signals. Number of the classes is three. The model concludes one 1D convolution layer and one 1D average-pooling layer.
  The structure of the model is shown as below.
</p>
<code>layers = [ ...
    sequenceInputLayer(num_Features)
    convolution1dLayer(filterSize,numFilters,Padding="causal")
    reluLayer
    layerNormalizationLayer
    globalAveragePooling1dLayer
    fullyConnectedLayer(num_Classes)
    softmaxLayer
    classificationLayer];
miniBatchSize = 5;
</code>
<p>
  After multi tests, in order to gain a high accuracy nerual network, max epoches was setting to 200 and learning rate was setting to 0.001.
  The training option setting was shown as below.
</p>
<code>options = trainingOptions("adam", ...
    MaxEpochs=200, ...
    InitialLearnRate=0.001, ...
    SequencePaddingDirection="left", ...
    ValidationData={XValidation,TValidation}, ...
    Plots="training-progress", ...
    Verbose=0);
</code>
<p> 
  After running <strong>Training.m</strong>, a figure of training process, a figure of a brief test accuracy, and the network was obtained.
</p>

## Net testing
<p>
  In the training program, a brief testing was conducted. However, the testing data came from the same documents of the training data. 
  They might have some hidden relationship, which could cause a over-fit and an unreliable neural network.
  In order to avoid this issue, an extra network testing was required.
  All the testing data used for this program was obtained by program <strong>Documents_separation.m</strong>. 
  They were all selected from the total dataset randomly, and were not from the same experiments with the training data.
</p>
<p>
  All the extra testing data should have the same formation with the training data. 
  After running this program, 4 confusion matrix and 4 testing accuracies were obtained.
</p>

