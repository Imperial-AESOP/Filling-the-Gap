# Filling-the-Gap

Filling-the-Gap (FG) tool is a tool for continuous performance model parametrization. The FG tool implements a set of statistical estimation algorithms to parameterize performance models from runtime monitoring data. Multiple algorithms are included, allowing for alternative ways to obtain estimates for different metrics, but with an emphasis on resource demand estimation. 

# Versions
* MODAClouds-FG: FG has been initially developed in the [MODAClouds](http://www.modaclouds.eu) project. [[Download](projects/modaclouds)]
* DICE-FG: An improved version is under development within the [DICE](http://www.dice-h2020.eu) project. [[Download](https://github.com/dice-project/DICE-Enhancement-FG)]

## Differences

Feature | MODAClouds-FG | DICE-FG
--- | --- | ---
Analysis | Estimation of execution times, think times, number of jobs. |  Estimation of execution times, think times, number of jobs, memory usage. Fitting of data to statistical distributions.
Data input | Fuseki local database based on MODAClouds ontology |  JSON-based input
Output | Annotated layered queueing network model for use with [LINE](line-solver.sf.net) queueing network solver. | Annotated UML model (MARTE & DICE profiles) 
Reporting | A PDF report is generated to summarize the analysis results | The model annotations are visually inspectable within [DICE Eclipse IDE](https://github.com/dice-project/DICE-Platform).
