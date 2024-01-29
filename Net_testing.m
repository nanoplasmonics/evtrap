clc
clear
disp('[On] Porgram')
acc_set = [];
for i = 1:4
    disp(['[Start] Data loading and formation NO.',num2str(i)])
    %% path of different types of proteins
    path_MDA = ['dataset/test/test',num2str(i),'/MDA/'];
    path_MCF7A = ['dataset/test/test',num2str(i),'/MCF7A/'];
    path_MCF10A = ['dataset/test/test',num2str(i),'/MCF10A/'];
    
    %% get the data from different protein files
    length_stand = zeros(1,3);
    [data_MDA,length_stand(1)] = F_DataFromDir(path_MDA);
    [data_MCF7A,length_stand(2)] = F_DataFromDir(path_MCF7A);
    [data_MCF10A,length_stand(3)] = F_DataFromDir(path_MCF10A);
    %% data length standardlization and decrease sampling rate
    % down sampling parameters setting
    % ********************************
    % ********************************
    target_sampling_rate = 500;
    original_sampling_rate = 1e5;
    shrink_rate = original_sampling_rate/target_sampling_rate;
    length_sample_original = target_sampling_rate*shrink_rate;
    % ********************************
    % ********************************
    
    % data length standardlization processing
    % **************************************
    % **************************************
    num_frames_perchannel_MDA = floor(size(data_MDA,2)/length_sample_original);
    num_frames_perchannel_MCF7A = floor(size(data_MCF7A,2)/length_sample_original);
    num_frames_perchannel_MCF10A = floor(size(data_MCF10A,2)/length_sample_original);
    
    length_stand_MDA = num_frames_perchannel_MDA * length_sample_original;
    length_stand_MCF7A = num_frames_perchannel_MCF7A * length_sample_original;
    length_stand_MCF10A = num_frames_perchannel_MCF10A * length_sample_original;
    data_MDA = data_MDA(:,1:length_stand_MDA);
    data_MCF7A = data_MCF7A(:,1:length_stand_MCF7A);
    data_MCF10A = data_MCF10A(:,1:length_stand_MCF10A);
    disp('data length standardlization done')
    % **************************************
    % **************************************
    
    % channel cancelling and framing the data
    % ***************************************
    % ***************************************
    data_MDA = F_ChannelCancel(data_MDA);
    data_MCF7A = F_ChannelCancel(data_MCF7A);
    data_MCF10A = F_ChannelCancel(data_MCF10A);

    data = {10*(data_MDA-mean(data_MDA))+2.*mean(data_MDA),...
        10*(data_MCF7A-mean(data_MCF7A))+2*mean(data_MCF7A),...
        10*(data_MCF10A-mean(data_MCF10A))+2*mean(data_MCF10A)};
    
    data{1} = [data{1};ones(1,size(data{1},2)).*1];
    data{2} = [data{2};ones(1,size(data{2},2)).*2];
    data{3} = [data{3};ones(1,size(data{3},2)).*3];
    data_new = {};
    for k = 1:length(data)
        num_frames = size(data{k},2)/length_sample_original;
        for j = 1:num_frames
            data_new{end+1} = data{k}(:,(j-1)*length_sample_original+1: ...
                j*length_sample_original);
        end
    end
    
    % decrease sample rating
    % **********************
    % **********************
    for j = 1:length(data_new)
        temp_data = data_new{j};
        temp_data_trans = zeros(2,target_sampling_rate);
        for k = 1:target_sampling_rate
            temp_data_trans(1,k) = mean(temp_data(1,(k-1)*shrink_rate+1:k*shrink_rate));
            temp_data_trans(2,:) = temp_data(2,1);
            data_new{j} = temp_data_trans;
        end
    end
    % **********************
    % **********************
    num_samples_per_fram = target_sampling_rate;
    disp(['[Done] Data loading and formation NO.',num2str(i)])
    
    % test the net
    disp(['[Start] Net testing NO.',num2str(i)])
    load net.mat
    numObservations = numel(data_new);
    [idxTest,idxValidation] = F_TrainingPartitions(numObservations,[0.5 0.5]);
    for j = 1:numObservations
        Data{j} = data_new{j}(1,:);
        Labels{j} = data_new{j}(2,1);
    end
    XTest = Data(idxTest);
    TTest = cell2mat(Labels(idxTest));
    TTest = TTest - 1;
    TTest = categorical(TTest);

    YTest = classify(net,XTest, ...
    SequencePaddingDirection="left");
    acc = mean(YTest == TTest');
    disp(['Acc--',num2str(acc)])
    figure
    confusionchart(TTest,YTest)
    acc_set = [acc_set,acc];
    disp(['[Done] Net testing NO.',num2str(i)])
end
disp('[Start] Result saving')
save acc_set.mat acc_set
disp('[Done] Result saving')
disp('[Off] Program')