function [ fileName ] = generateJsonFile( resources,demand,N,Z,category_list,reportDataFolder )

if iscolumn(demand)
    demand = demand';
end

load(strcat(resources,'_ResponseInfo','_data.mat'),'data')

result.nbClasses = size(data,2)-1;
result.nbUsers = sum(N);
result.classes = category_list;
result.nbUsersPerClass = N;
result.demand = demand;
result.think_time = Z;

time_reference = datenum('1970', 'yyyy');

if length(data{1,1}) <= 10
    for j = 1:length(data{1,1})
        time_matlab = time_reference + data{1,1}(j) / 8.64e7;
        time_matlab_string{1,j} = datestr(time_matlab, 'yy/mm/dd HH:MM');
    end
else
    gap = length(data{1,1})/10;

    for j = 1:10
        time_matlab = time_reference + data{1,1}(1+round(gap*j-gap)) / 8.64e7;
        time_matlab_string{1,j} = datestr(time_matlab, 'yy/mm/dd HH:MM');
    end
end
result.time = time_matlab_string;

for j = 1:size(data,2)-1
    data{1,j} = data{1,j}';
    data{5,j} = data{5,j}';
    data{6,j} = data{6,j}';
end

for j = 1:size(data,2)-1
    result.response_time{1,j}.classes = category_list{1,j};
    if length(data{1,1}) <= 10
        for k = 1:length(data{1,1})
            result.response_time{1,j}.value(1,k) = mean(data{5,j}(k));
        end
    else
        for k = 1:9
            result.response_time{1,j}.value(1,k) = mean(data{5,j}(1+round(gap*k-gap):1+round(gap*k)));
        end
        result.response_time{1,j}.value(1,10) = mean(data{5,j}(1+round(gap*k-gap):end));
    end
    result.response_time{1,j}.mean = mean(data{5,j});
    result.response_time{1,j}.min = min(data{5,j});
    result.response_time{1,j}.max = max(data{5,j});
    result.response_time{1,j}.std = std(data{5,j});
end

for j = 1:size(data,2)-1
    result.throughput{1,j}.classes = category_list{1,j};
    if length(data{1,1}) <= 10
        for k = 1:length(data{1,1})
            result.throughput{1,j}.value(1,k) = mean(data{6,j}(k));
        end
    else
        for k = 1:9
            result.throughput{1,j}.value(1,k) = mean(data{6,j}(1+round(gap*k-gap):1+round(gap*k)));
        end
        result.throughput{1,j}.value(1,10) = mean(data{6,j}(1+round(gap*k-gap):end));
    end
    %result.throughput{1,j}.value = data{6,j};
    result.throughput{1,j}.mean = mean(data{6,j});
    result.throughput{1,j}.min = min(data{6,j});
    result.throughput{1,j}.max = max(data{6,j});
    result.throughput{1,j}.std = std(data{6,j});
end

jsonMessage = savejson('',result);
fileID = fopen(strcat(reportDataFolder,'/reportData-',resources,'.json'),'w');
fprintf(fileID,'%s',jsonMessage);
fclose(fileID);
fileName = strcat(reportDataFolder,'/reportData-',resources,'.json');
end



