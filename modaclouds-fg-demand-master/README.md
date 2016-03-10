modaclouds-fg-demandEstimation
==============================

Filling The Gap - Demand Estimation methods

This is the readme file of the demand estimation methods. 

QUICK START 
 - Download all the scripts, including the folder named DATA.  
 - Start MATLAB. 
 - Run the SAMPLE_ESTIMATION script. 


USER GUIDE
There are two ways to use the scripts provided. 

1. All the scripts named MAIN_XXX implement the estimations methods, using 
as input a standard data format. 

The format is a 6x(R+1) MATLAB cell, where R is the number of requests classes. 
For the estimation methods provided here, it is enough to specify rows 3 and 4 
of this data format, which are: 
 - row 3: Entry (3,j) of the cell contains a column vector with the ARRIVAL TIMES, 
in milliseconds, observed for samples of class j, for j between 1 and R. 
 - row 4: Entry (4,j) of the cell contains a column vector with the RESPONSE TIMES, 
in seconds, observed for samples of class j, for j between 1 and R. 

Notice that the methods use response times and queue lengths observed at
arrival. The standard format however does not include the queue lengths. 
To overcome this, we assume the data comes from a full trace stored in the
standard format, and use the arrival and response times to derive the
queue lengths at arrival time. To this end the samples are ordered by
arrival time. After this ordering, the samples with index between
INITSAMPLE and INITSAMPLE+SAMPLESIZE+1 are considered for analysis. 


2. Another way of using the estimation scripts is by directly using the 
scripts named DES_XXX. All these scripts require the following parameters
(here R is the number of request classes): 
RT: 	column vector with all response time samples  
CLASS:  column vector with the class of each sample
QL:	matrix with R columns containing the number of jobs 
        of each class observed by each sample, including the arriving job 
	(one row per sample)
V:	number of cores of the server where the application is deployed

In addition, the DES_MLPS, DES_MINPS, and DES_FMLPS methods also require 
the following parameter: 
LAMBDA:	1xR vector with the think time for each class 

The think times can be computed from the request throughput observed, 
as illustrated in the MAIN_XXX scripts, where the LAMBDA parameter is computed
and provided to the associated DES_XXX script. 

Copyright (c) 2012-2014, Imperial College London 
All rights reserved.


