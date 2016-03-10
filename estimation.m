function [demand, category_list_all, N, Z] = estimation( method,parameters,resources,reportDataFolder)

warmUp = 0;
nCPU = 1;
maxTime = 1000;
sampleSize = 100;
tol = 10^-3;
supportedMethods = {'ci','minps','erps','gql','ubr','ubo'};

for i = 1:size(parameters,1)
    switch parameters{i,1}
        case 'warmUp'
            warmUp = str2double(parameters{i,2});
        case 'nCPU'
            nCPU = str2double(parameters{i,2});
        case 'maxTime'
            maxTime = str2double(parameters{i,2});
        case 'sampleSize'
            sampleSize = str2double(parameters{i,2});
        case 'tol'
            tol = str2double(parameters{i,2});
    end
end

demand = -1;

flag_local = 0;
for i = 0:resources.size-1
    pair = resources.get(i);
    load(strcat(pair,'_ResponseInfo','_data.mat'),'data','category_list')
    
    if strcmp(method,'automatic')
        method = chooseMethod(data);
    end
    
    try
        method = validatestring(method,supportedMethods);
    catch
        method = chooseMethod(data);
        warning('Unexpected method. No demand generated. Will automatically choose one.');
    end
    
    % submit the job to compute demand
    outFile = strcat(pwd,'/',pair,'_ResponseInfo','_demand.mat');
    fielName = strcat(pair,'_ResponseInfo','_data.mat');
    save(fielName,'data','category_list','warmUp','nCPU','maxTime','sampleSize','tol','outFile','method')
    
    tarCommand = sprintf('tar -cvf job%s.tar.gz estimation run_estimation.sh run.sh %s',pair,fielName);
    [status,result] = system(tarCommand);
    
    if status~=0
        disp(result);
        disp(result);
        disp('Failed to submit jobs to condor, will execute locally');
        flag_local = 1;
        break;
    end
    
    runCommand = sprintf('curl -v -F ''job-bundle=@job%s.tar.gz'' -F ''job-name=%s'' -F ''job-arguments=%s'' -F ''job-notification=http://localhost:5000/'' -X POST http://localhost:5000/jobs',pair,pair,fielName)
    [status,result] = system(runCommand);
    
    if status~=0
        disp(result);
        disp('Failed to submit jobs to condor, will execute locally');
        flag_local = 1;
        break;
    end
end

demand = cell(1,resources.size);
if flag_local == 1
    for i = 0:resources.size-1
        switch method
            case 'ci'
                demand{1,i+1} = ci(data,nCPU,warmUp);
            case 'minps'
                demand{1,i+1} = main_MINPS(data, warmUp+1, sampleSize, nCPU);
            case 'erps'
                demand{1,i+1} = main_ERPS(data, warmUp+1, sampleSize, nCPU);
            case 'gql'
                demand{1,i+1} = gibbs(data,nCPU,tol);
            case 'ubr'
                demand{1,i+1} = ubr(data,nCPU);
            case 'ubo'
                demand{1,i+1} = ubo(data,maxTime);
        end
    end
else
    while (1)
        flag = 1;
        for i = 0:resources.size-1
            pair = resources.get(i);
            fileName = strcat(pwd,'/',pair,'_ResponseInfo','_demand.mat');
            if exist(fileName, 'file') == 2
                result = load(fileName,'demand');
                demand{1,i+1} = result.demand;
                system(sprintf('rm %s',fileName))
            else
                flag = 0;
            end
        end
        
        if flag == 0
            disp('waiting for the demand estimation to finish')
            pause(10);
        else
            break;
        end
    end
end

for i = 0:resources.size-1
    pair = resources.get(i);
    load(strcat(pair,'_ResponseInfo','_data.mat'),'data','category_list')
    
    [ N_sub, N0 ] = estimateN( data );
    [Z_sub,R_sub,X_sub] = estimateZ( data, N0 );
    
    fileName = generateJsonFile(resources.get(i),demand{1,i+1},N_sub,Z_sub,category_list,reportDataFolder);
    
    disp('Josn file generated');
    
    [status,result] = system(sprintf('java -jar fg-report-1.0.0.jar %s %s',fileName,reportDataFolder));
    if status == 0
        disp('Report generated');
    else
        command = sprintf('java -jar fg-report-1.0.0.jar %s %s',fileName,reportDataFolder)
        result
        disp('Report generation failed');
    end
    
    if i == 0
        category_list_all = category_list;
        N = N_sub;
        X = X_sub;
        R = R_sub;
    else
        for k = 1:length(category_list)
            flag = 0;
            for h = 1:length(category_list_all)
                if strcmp(category_list{1,k},category_list_all{1,h})
                    flag = 1;
                    N(h) = max(N(h),N_sub(k));
                    X(h) = X(h) + X_sub(k);
                    R(h) = R(h) + R_sub(k);
                    break;
                end
            end
            if flag == 0
                category_list_all{1,end+1} = category_list{1,k};
                N(end+1) = N_sub(k);
                X(end+1) = X_sub(k);
                R(end+1) = R_sub(k);
            end
        end
    end
end

X = X/resources.size;
Z = N./X-R;

end