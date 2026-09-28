# Sparse Approximation of Governing Equations 
## SAGE toolbox

Version: v1.0.0  
Release date: 28th September 2026  
MATLAB version: R2022b  

An introductory example on the toolbox will be added by the authors within the following weeks. 

SAGE is an object oriented MATLAB toolbox for operational system identification based on sparse regression and nonlinear autoregressive model structures.
Its core classes are fully operational and commented: 
* `sage` performs the regression
* `sageoptions` defines the regression parameters
* `sagedata` is a wrapper class for the data

For further information, please refer to the MATLAB help function.

SAGE contains functions to evaluate and vizualise results, such as:
* `fit` assesses the regression fit performance on the states (no propagation)
* `prop` propagates the identified equations for a given input sequence
* `errormetrics` computes typical error metrics 
* `coefs` outputs the identified coefficients 
* `disp` displays the identified equations











