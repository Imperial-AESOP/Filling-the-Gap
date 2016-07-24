function [LQNFileName,PCMRateFileName,PCMDemandFileName,classMapFileName,resourceMapFileName,PCMUsageModelFile,flag] = obtainFiles()

flag = 1;

LQNFileName = '';
PCMRateFileName = '';
PCMDemandFileName = '';
classMapFileName = '';
resourceMapFileName = '';
PCMUsageModelFile = '';

OS_IP = getenv('MOSAIC_OBJECT_STORE_ENDPOINT_IP');
OS_PORT = getenv('MOSAIC_OBJECT_STORE_ENDPOINT_PORT');
OS_FG_PATH = getenv('MODACLOUDS_FG_PATH');
OS_MODEL_JSON = getenv('MODACLOUDS_FG_MODEL_JSON');

command = strcat('curl -X GET http://',OS_IP,':',OS_PORT,OS_FG_PATH,OS_MODEL_JSON,' | tee model.json');
status = system(command);
if status ~= 0
    flag = 0;
    disp('Error getting the model json file.')
    return;
end

data = loadjson('model.json');

try
    LQNFileName = data.LQNFileName;
    command = strcat('curl -X GET http://',OS_IP,':',OS_PORT,OS_FG_PATH,LQNFileName,' | tee ',LQNFileName);
    [status] = system(command);
    if status ~= 0
        error('Unable to obtain file.')
    end
    
    PCMRateFileName = data.PCMRateFileName;
    command = strcat('curl -X GET http://',OS_IP,':',OS_PORT,OS_FG_PATH,PCMRateFileName,' | tee ',PCMRateFileName);
    [status] = system(command);
    if status ~= 0
        error('Unable to obtain file.')
    end
    
    PCMDemandFileName = data.PCMDemandFileName;
    command = strcat('curl -X GET http://',OS_IP,':',OS_PORT,OS_FG_PATH,PCMDemandFileName,' | tee ',PCMDemandFileName);
    [status] = system(command);
    if status ~= 0
        error('Unable to obtain file.')
    end
    
    classMapFileName = data.classMapFileName;
    command = strcat('curl -X GET http://',OS_IP,':',OS_PORT,OS_FG_PATH,classMapFileName,' | tee ',classMapFileName);
    [status] = system(command);
    if status ~= 0
        error('Unable to obtain file.')
    end
    
    resourceMapFileName = data.resourceMapFileName;
    command = strcat('curl -X GET http://',OS_IP,':',OS_PORT,OS_FG_PATH,resourceMapFileName,' | tee ',resourceMapFileName);
    [status] = system(command);
    if status ~= 0
        error('Unable to obtain file.')
    end
    
    PCMUsageModelFile = data.PCMUsageModelFile;
    command = strcat('curl -X GET http://',OS_IP,':',OS_PORT,OS_FG_PATH,PCMUsageModelFile,' | tee ',PCMUsageModelFile);
    [status] = system(command);
    if status ~= 0
        error('Unable to obtain file.')
    end
catch
    disp('error parsing the json file');
    flag = 0;
    return;
end
end