%% main function, requires the configuration file as input
function main(file)

%% put a java.opts file in  mcr_root/<ver>/bin/<arch> with
%%  -Xmx2096m

% the required jar files
javaaddpath(fullfile(pwd,'lib/db-retriever-0.0.1-SNAPSHOT.jar'));
javaaddpath(fullfile(pwd,'lib/lqnUpdater-0.0.1-SNAPSHOT.jar'));

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.SimpleTimeZone;
%addpath(fullfile(libpath,'modaclouds-fg-demand-master'));
% if matlabpool('size') == 0
%     matlabpool open
%     setmcruserdata('ParallelProfile','clusterProfile.settings');
%     parallel.importProfile('clusterProfile.settings')
% end

while 1
    
    %file = 'configuration_FG.xml';
    xDoc = xmlread(file);
    rootNode = xDoc.getDocumentElement.getChildNodes;
    node = rootNode.getFirstChild;
    
    nbMetric = 0;
    nbParameter = 0;
    
    while ~isempty(node)
        if strcmp(node.getNodeName, 'metric')
            subNode = node.getFirstChild;
            while ~isempty(subNode)
                
                if strcmpi(subNode.getNodeName, 'algorithm')
                    algorithm{nbMetric+1} = char(subNode.getTextContent);
                    nbMetric = nbMetric + 1;
                end
                if strcmpi(subNode.getNodeName, 'timeStep')
                    period(nbMetric) = str2double(subNode.getTextContent)*1000
                end
                if strcmpi(subNode.getNodeName, 'reportDataFolder')
                    reportDataFolder = char(subNode.getTextContent);
                end
                if strcmpi(subNode.getNodeName, 'CPUMetric')
                    CPUMetric = char(subNode.getTextContent);
                end
                if strcmpi(subNode.getNodeName, 'AppMetric')
                    AppMetric = char(subNode.getTextContent);
                end
                if strcmpi(subNode.getNodeName, 'dataHorizon')
                    dataHorizon = char(subNode.getTextContent);
                    dataHorizon = java.lang.String(dataHorizon);
                    
                    horizonValue = str2double(dataHorizon);
                    if isnan(horizonValue)
                        try
                            horizons = dataHorizon.split('-');
                            sdf = SimpleDateFormat('mm.HH.dd.MM.yyyy');
                            sdf.setTimeZone(SimpleTimeZone(SimpleTimeZone.UTC_TIME, 'UTC'));
                            date = sdf.parse(horizons(1));
                            startTime = num2str(date.getTime());
                            
                            date = sdf.parse(horizons(2));
                            endTime = num2str(date.getTime());
                        catch err
                            err.message
                            disp('Please input correct horizons');
                            exit
                        end
                    else
                        endTime = java.lang.System.currentTimeMillis();
                        startTime = endTime - horizonValue*1000;
                        
                        endTime = num2str(endTime);
                        startTime = num2str(startTime);
                    end
                end
                if strcmpi(subNode.getNodeName, 'localDBIP')
                    IP = char(subNode.getTextContent);
                end
                if strcmpi(subNode.getNodeName, 'parameter')
                    nbParameter = nbParameter + 1;
                    parameters{nbMetric}{nbParameter,1} = char(subNode.getAttribute('name'));
                    parameters{nbMetric}{nbParameter,2} = char(subNode.getAttribute('value'));
                end
                subNode = subNode.getNextSibling;
            end
        end
        node = node.getNextSibling;
    end
    
    [pauseTime, index] = min(period);
    nextPauseTime = period - pauseTime;
    pause(pauseTime/1000)
    
    ldbURI = strcat('http://',IP,':3030/ds/query');
    %queryString = 'SELECT * {?s ?p ?o}';
    queryString = strcat(['SELECT ?g ?s ?p ?o WHERE { GRAPH ?g { ?s ?p ?o} GRAPH ?g {' ...
        '?s <http://www.modaclouds.eu/rdfs/1.0/monitoringdata#timestamp> ?t FILTER (?t >= '],startTime,' && ?t <= ',endTime,') } }')
    
    tic;
    [resources,flag] = dataGeneration(ldbURI,queryString,parameters{index},CPUMetric,AppMetric);
    
    if flag ~= -1
        tic
        [demand, category_list_all, N, Z] = estimation(lower(algorithm{index}),parameters{index},resources,reportDataFolder);
        estimation_time = toc
        
        if iscell(demand)
            updateModel( parameters{index}, category_list_all, demand, resources, N, Z )
        end
    end
    
    nextPauseTime = nextPauseTime - toc*1000;
    for i = 1:length(nextPauseTime)
        if nextPauseTime(i) < 0
            nextPauseTime(i) = 0;
        end
    end
    nextPauseTime(index) = max(period(index)-toc*1000,0);
end