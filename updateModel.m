function updateModel( parameters, classes_all, demand, resources, N, Z )

for i = 0:resources.size-1
    processorName(i+1) = java.lang.String(char(resources.get(i)));
end

for i = 1:size(parameters,1)
    switch parameters{i,1}
        case 'LQNFile'
            LQNFileName = parameters{i,2};
        case 'PCMProcessorScaleFile'
            PCMRateFileName = parameters{i,2};
        case 'PCMDemandFile'
            PCMDemandFileName = parameters{i,2};
        case 'ClassMapFile'
            classMapFileName = parameters{i,2};
        case 'ResourceMapFile'
            resourceMapFileName = parameters{i,2};
        case 'PCMUsageModelFile'
            PCMUsageModelFile = parameters{i,2};
    end
end

%[LQNFileName,PCMRateFileName,PCMDemandFileName,classMapFileName,resourceMapFileName,PCMUsageModelFile,flag] = obtainFiles();

if flag == 0
    disp('Unable to update model files.')
    return
end

LQNupdater = javaObject('imperial.modaclouds.fg.modelUpdater.LQNUpdate');

for i = 0:resources.size-1
    pair = resources.get(i);
    load(strcat(pair,'_ResponseInfo','_data.mat'),'category_list')
    
    classes_java = javaArray('java.lang.String',length(category_list));
    demand_java = javaArray('java.lang.String',length(category_list));
    for j = 1:length(category_list)
        classes_java(j) = java.lang.String(category_list{1,j});
        demand_java(j) = java.lang.String(num2str(demand{1,i+1}(j)));
    end
    
    LQNupdater.updateFile(LQNFileName, processorName(i+1), classes_java, demand_java, classMapFileName, resourceMapFileName, num2str(sum(N)), num2str(sum(Z)));
end

PCMupdater = javaObject('imperial.modaclouds.fg.modelUpdater.PCMUpdate');
PCMupdater.updatePCMModels(PCMRateFileName, PCMDemandFileName, PCMUsageModelFile, LQNFileName, processorName, classes_all , num2str(sum(N)), num2str(sum(Z)), classMapFileName, resourceMapFileName);

end