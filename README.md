# Filling-the-Gap

Filling-the-Gap (FG) tool is a tool for continuous performance model parametrization. The FG tool implements a set of statistical estimation algorithms to parameterize performance models from runtime monitoring data. Multiple algorithms are included, allowing for alternative ways to obtain estimates for different metrics, but with an emphasis on resource demand estimation. 

# Versions
* MODAClouds-FG: FG has been initially developed in the [MODAClouds](http://www.modaclouds.eu) project. [[Download](projects/modaclouds)]
* DICE-FG: An improved version is under development within the [DICE](http://www.dice-h2020.eu) project. [[Download](https://github.com/dice-project/DICE-Enhancement-FG)]

# Differences Between Versions

Analysis features:
* MODAClouds-FG: Estimation of execution times, think times, number of jobs. 
* DICE-FG: Estimation of execution times, think times, number of jobs, memory usage. Fitting of data to statistical distributions.

Data input:
* MODAClouds-FG: Fuseki local database based on MODAClouds ontology
* DICE-FG: JSON-based input

Output:
* MODAClouds-FG: Annotated layered queueing network model for use with [LINE](line-solver.sf.net) queueing network solver.
* DICE-FG: Annotated UML model (MARTE & DICE profiles) 

Reporting:
* MODAClouds-FG: A PDF report is generated to summarize the outcomes.
* DICE-FG: The model annotations are visually inspectable within [DICE Eclipse IDE](https://github.com/dice-project/DICE-Platform).
