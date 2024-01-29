%%% test and training dataset/datafile setting
clc
clear
close all
disp('[On] Program')
%% path setting
path = 'dataset_source/';
path_MDA = [path,'MDA/'];
path_MCF7A = [path,'MCF7A/'];
path_MCF10A = [path,'MCF10A/'];

%% file selecting
num_testing = 4; 
num_files_MDA = 0; num_files_MCF7A = 0; num_files_MCF10A = 0;
files_MDA = dir(path_MDA);
files_MCF7A = dir(path_MCF7A);
files_MCF10A = dir(path_MCF10A);
useless_file_MDA = 0;
for i = 1:length(files_MDA)
    if isequal(files_MDA(i).name(1),'.')
        useless_file_MDA = useless_file_MDA + 1;
        continue
    end
    num_files_MDA = num_files_MDA + 1;
end
uesless_file_MCF7A = 0;
for i = 1:length(files_MCF7A)
    if isequal(files_MCF7A(i).name(1),'.')
        uesless_file_MCF7A = uesless_file_MCF7A + 1;
        continue
    end
    num_files_MCF7A = num_files_MCF7A + 1;
end
useless_file_MCF10A = 0;
for i = 1:length(files_MCF10A)
    if isequal(files_MCF10A(i).name(1),'.')
        useless_file_MCF10A = useless_file_MCF10A + 1;
        continue
    end
    num_files_MCF10A = num_files_MCF10A + 1;
end
num_MDA_training = num_files_MDA - num_testing;
num_MCF7A_training = num_files_MCF7A - num_testing;
num_MCF10A_training = num_files_MCF10A - num_testing;
indx_set = 1:num_files_MDA;
indx_MDA_test = sort(randsample(indx_set,num_testing));
indx_set = 1:num_files_MCF7A;
indx_MCF7A_test = sort(randsample(indx_set,num_testing));
indx_set = 1:num_files_MCF10A;
indx_MCF10A_test = sort(randsample(indx_set,num_testing));
%% different dataset files setting
disp('[START] Setting files')
path_test = []; path_train = [];
for i = 1:num_testing
    path_test = [path_test; ['dataset/test/test',num2str(i)],'/'];
    mkdir(path_test(i,:));
    mkdir([path_test(i,:),'MDA/']);
    mkdir([path_test(i,:),'MCF7A/']);
    mkdir([path_test(i,:),'MCF10A/']);
end
path_train = 'dataset/train/';
disp('[Done] Setting files')
%% data separation
disp('[start] Data separation')
for i = 1:num_testing
    movefile([path,'MDA/MDA-',num2str(indx_MDA_test(i)),'.txt'], ...
        [path_test(i,:),'MDA/']);
    movefile([path,'MCF7A/MCF7A-',num2str(indx_MCF7A_test(i)),'.txt'], ...
        [path_test(i,:),'MCF7A/']);
    movefile([path,'MCF10A/MCF10A-',num2str(indx_MCF10A_test(i)),'.txt'], ...
        [path_test(i,:),'MCF10A/']);
end
path_v1_5 = 'dataset/train/';
copyfile(path,path_v1_5)
disp('[Done] Data separation')
%% save the index
disp('[Start] Data saving')
save indx_MDA_test.mat indx_MDA_test;
save indx_MCF7A_test.mat indx_MCF7A_test;
save indx_MCF10A_test.mat indx_MCF10A_test;
disp('[Done] Data saving')
disp('[Off] Program')