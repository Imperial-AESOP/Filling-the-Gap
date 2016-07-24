function [ resources, flag ] = dataGeneration(ldbURI,queryString,parameters,CPUMetric,AppMetric)

myRetriever = javaObject('imperial.modaclouds.fg.dbretriever.DataFetch');
allData = myRetriever.DataFetching(ldbURI,queryString);
resources = myRetriever.getResources();

if resources.size == 0
    disp('No data received');
    category_list = -1;
    flag = -1;
    return
end

flag = 0;

for i = 0:resources.size-1
    
    data_format = [];
    category_list = [];
    category_index = 1;
    category_count = 1;
    mapObj = containers.Map;
    
    pair = resources.get(i);
    temp_str = myRetriever.parseData(allData,pair,AppMetric);
    
    if isempty(temp_str)
        demand = -1;
        disp(strcat('No data received for ',pair,' ',AppMetric));
        continue;
    end
    
    values = temp_str.getValues;
    try
        for j = 0:values.size-1
            str = values.get(j);
            str = java.lang.String(str);
            split_str = str.split(',');
%             dateFormat = java.text.SimpleDateFormat('yyyyMMddHHmmssSSS');
%             
%             date_str = '';
%             
%             for k = 1:7
%                 date_str = strcat(date_str,char(split_str(k)));
%             end
%             
%             try
%                 date = dateFormat.parse(date_str);
%             catch e
%                 e.printStackTrace();
%             end
%             
%             date_milli = date.getTime();
%             
%             jobID = char(split_str(8));
%             
%             category_str = char(split_str(9));
            category_str = char(split_str(1));
            
            if isKey(mapObj, category_str) == 0
                mapObj(category_str) = category_index;
                category_list{1,category_count} = category_str;
                category_count = category_count + 1;
                
                category = category_index;
                data_format{6,category}=[];
                category_index = category_index + 1;
            else
                category = mapObj(category_str);
            end
            
%             if strcmp(split_str(10),'Request Begun')
%                 continue;
%             end
            response_time = str2double(char(split_str(3)));
            data_format{3,category} = [data_format{3,category};str2double(char(split_str(2)))];
            data_format{4,category} = [data_format{4,category};response_time];
        end
        
        rawData = data_format;
        rawData{3, category_index} = [];
        
        for j = 1:size(parameters,1)
            switch parameters{j,1}
                case 'window'
                    window = str2double(parameters{j,2})*1000;
                case 'warmUp'
                    warmUp = str2double(parameters{j,2});
                case 'nCPU'
                    nCPU = str2double(parameters{j,2});
                case 'avgWin'
                    avgWin = str2double(parameters{j,2});
                case 'maxTime'
                    maxTime = str2double(parameters{j,2});
            end
        end
                
        %FIX: obtain cpu value
        cpu = myRetriever.parseData(allData,pair,CPUMetric);
        
        if isempty(cpu)
            [data,category_list] = dataFormat(rawData,window,category_list);
        else
            cpu_value = convertArrayList(cpu.getValues);
            cpu_timestamps = convertArrayList(cpu.getTimestamps);
            
            [data,category_list] = dataFormat(rawData,window,category_list,cpu_value,cpu_timestamps);
        end
        data
        
        save(strcat(pair,'_ResponseInfo','_data.mat'),'data','category_list')
    catch err
        err.message
        continue
    end
end

end

