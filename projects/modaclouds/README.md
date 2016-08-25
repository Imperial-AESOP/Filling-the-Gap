# Filling-the-Gap

Filling-the-Gap (FG) tool is a tool for continuous performance model parametrization. The FG tool implements a set of statistical estima-
tion algorithms to parameterize performance models from runtime monitoring data. Multiple algorithms are included, allowing for alternative ways to obtain estimates for different metrics, but with an emphasis on resource demand estimation. FG tool supports advanced algorithms to estimate parameters based on response times and queue length data, which makes the tool useful in particular for applications running in virtualized environments where utilization readings are not always available.

# Wiki
For the installation and the details of the Modaclouds-FG-Analyzer, please refer to the wiki: https://github.com/Imperial-AESOP/Filling-the-Gap/wiki

# Manual
The manual of FG is available at: https://github.com/Imperial-AESOP/Filling-the-Gap/blob/master/manual.pdf

# License

Licensed under the [BSD 3-clause][1]
[1]: http://opensource.org/licenses/BSD-3-Clause

# Tutorial

We have recently presented a tutorial at [ICPE 2016](https://icpe2016.spec.org/). In the tutorial, we present the problem of
estimating parameters of performance models from measurements of real systems and discuss algorithms that can support researchers and practitioners in this task. The focus lies on performance models based on queueing systems, where the estimation of request arrival rates and service demands is a required input to the model. In the tutorial, we review existing estimation methods for service demands, which are supported in FG, and present models to characterize time-varying arrival processes. The tutorial also demonstrates the use of relevant tools that automate demand estimation, such as LibRede, M3A as well as FG.

You can find the tutorial slides [here](https://github.com/Imperial-AESOP/Filling-the-Gap/blob/master/projects/modaclouds/Tutorial-CSW.pdf)
