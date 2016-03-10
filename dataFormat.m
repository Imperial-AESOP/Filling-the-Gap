function [data,category_list] = dataFormat(data, period, category_list, cpu, cpu_time)
%% generate required formatted data    
    delete = [];
    
    for i = 1:size(data,2) - 1
        if isempty(data{3,i})
            delete = [delete,i];
        end
    end
    
    data(:,delete) = [];
    
    if exist('cpu','var') == 1 && ~isempty(category_list)
        category_list(:,delete) = [];
    end
    
    delete = [];
    for i = 1:size(data,2) - 1
        if size(data{3,i},1) < 20
            delete = [delete,i];
        end
    end
    
    data(:,delete) = [];
    
    if ~isempty(category_list)
        category_list(:,delete) = [];
    end
    
%     if exist('cpu','var') == 1 && ~isempty(category_list)
%         category_list(:,delete) = [];
%     end

    start = min(data{3,1});
    for i = 2:size(data,2)-1
        if ~isempty(data{3,i}) && start > min(data{3,i})
            start = min(data{3,i});
        end
    end
    
    for i = 1:size(data,2)-1
        end_time = start;
        last_index = 0;

        departure = data{3,i}+data{4,i}*1000;
        [departure,d_index] = sort(departure);
        while true
            index = find(departure>end_time+period);

            if isempty(index)
                if isempty(data{6,i})
                    
                end
                break
            else
                if index(1)-last_index-1 == 0
                    data{6,i} = [data{6,i};0];
                    data{5,i} = [data{5,i};0];
                    data{1,i} = [data{1,i};end_time+period];
                    end_time = end_time + period;
                else    
                    data{6,i} = [data{6,i};(index(1)-last_index-1)/period*1000];
                    data{1,i} = [data{1,i};end_time+period];
                    data{5,i} = [data{5,i};mean(data{4,i}(last_index+1:index(1)-1))];
                    end_time = end_time + period;
                    last_index = index(1)-1;
                end
            end
        end
    end
    
    max_length = 0;
    max_index = 0;
    for i = 1:size(data,2)-1
        if max_length < size(data{3,i},1)
            max_length = size(data{3,i},1);
            max_index = i;
        end
    end

    max_length = 0;
    max_index = 1;
    for i = 2:size(data,2)-1
        if max_length < size(data{1,i},1)
            max_length = size(data{1,i},1);
            max_index = i;
        end
    end
    
    for i = 1:size(data,2)-1
        data{1,i} = data{1,max_index};
        if size(data{5,i},1) < size(data{1,i},1)
            data{5,i}(end+1:size(data{1,i},1)) = 0;
            data{6,i}(end+1:size(data{1,i},1)) = 0;
        end
    end
    
    data{1,end} = data{1,1};
    
    if exist('cpu','var') == 1

        [cpu_time, index] = sort(cpu_time);
        cpu  = cpu(index);
        cpu_time = cpu_time;% - 60*60*1000;

        for i = 1:size(data{1,1},1)
            index_find = cpu_time >= data{1,1}(i,1) & cpu_time <= data{1,1}(i,1)+period;
            data{2,end} = [data{2,end};mean(cpu(index_find))];
        end
    end
    
end