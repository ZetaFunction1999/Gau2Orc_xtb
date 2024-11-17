# Linking ORCA and XTB through Gaussian external interface
## Introduction
The optimization algorithm of Gaussian is one of the most robust and efficient algorithms among common quantum chemistry software. 
In the calculation using pure functionals, double hybrid functionals, and def2 basis sets, ORCA is much faster than Gaussian.
However, the performance of ORCA's geometric optimizer is less than satisfactory. 
For a detailed evaluation, see http://bbs.keinsci.com/thread-47610-1-1.html.
Fortunately, Gaussian provides external interface through which its optimizer can accept results of energy, gradient, and Hessian matrix calculated by other programs for optimization.
