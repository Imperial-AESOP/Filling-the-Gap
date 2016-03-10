function demEst = ubr(data,nCPU)
% UBR Utilization-based regression statistical data analyzer (SDA).  
% This SDA is based on the method proposed in 
% Q. Zhang, L. Cherkasova, and E. Smirni. 
% A Regression-Based Analytic Model for Dynamic Resource Provisioning of Multi-Tier Applications. 
% Proceedings of the Fourth International Conference on Autonomic Computing, 2007. 
%
% D = UBR(data,nCPU) reads the data and configuration 
% parameters from the input parameters, estimates the resource
% demand for each request class and returns it on D. 
%
% Configuration file fields:
% data:         the input data for the SDA
% nCPU:         number of CPUs on which the application is deployed
%
% 
% Copyright (c) 2012-2013, Imperial College London 
% All rights reserved.
% This code is released under the 3-Clause BSD License. 

if exist('data','var') == 0
    disp('No data provided specified. Terminating without running SDA.');
    meanST = [];
    obs = [];
    return;
end

if exist('nCPU','var') ~= 0
    V = nCPU;
else
    disp('Number of CPUs not specified. Using default: 1.');
    V = 1;
end 

% get data necessary for the SDA 
[~, cpuUtil, ~, ~, ~, avgTput] = parseDataFormat(data);

if (size(avgTput, 1) ~= size(cpuUtil, 1))
    disp('Length of throughput and CPU utilization vectors do not match. Terminating without running SDA.');
    demEst = [];
    return;
end

a = isnan(cpuUtil);
if sum(a) > 0 
    disp('NaN values found for CPU Utilization. Removing NaN values.');
    cpuUtil = cpuUtil(a == 0);
    avgTput = avgTput(a == 0,:);
end


cpuUtil = cpuUtil * V;
demEst = lsqnonneg(avgTput, cpuUtil);

%%
%save(output_filename, 'demEst', '-ascii');
    
end
