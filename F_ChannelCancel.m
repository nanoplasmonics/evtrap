function data_new = channel_cancel(data)
data_new = [];
for i = 1:size(data,1)
    data_new = [data_new, data(i,:)];
end
end

