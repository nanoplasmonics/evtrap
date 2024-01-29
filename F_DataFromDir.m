function [data,length_stand] = data_from_dir(path)
disp(['Loading--',path,'...']);
files = dir(path);
data = [];
temp_data = {};
length_per_channel = [];
count = 1;
for i = 1:length(files)
    if (isequal(files(i).name,'.')||isequal(files(i).name,'..')|| ...
            files(i).isdir||isequal(files(i).name(1),'.'))
        continue;
    end
    temp = load([path,files(i).name]);
    length_per_channel = [length_per_channel,length(temp)];
    temp_data{count} = temp;
    count = count + 1;
end
length_stand = min(length_per_channel);
for i = 1:length(temp_data)
    temp = temp_data{i}(1:length_stand);
    data = [data;temp'];
end
disp(['Loaded--',path]);