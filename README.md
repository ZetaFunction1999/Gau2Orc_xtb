# Linking ORCA and XTB through Gaussian external interface
## Introduction
The optimization algorithm of Gaussian is one of the most robust and efficient algorithms among common quantum chemistry software. 
In the calculation using pure functionals, double hybrid functionals, and def2 basis sets, ORCA is much faster than Gaussian.
However, the performance of ORCA's geometric optimizer is less than satisfactory. 
For a detailed evaluation, see http://bbs.keinsci.com/thread-47610-1-1.html.

Fortunately, Gaussian provides external interface through which its optimizer can accept results of energy, gradient, and Hessian matrix calculated by other programs for optimization.
With the help of interface script *G2O.sh* and *G2X.sh*, one can utilize Gaussian as an optimizer, ORCA and XTB as wave function calculators.
*xtb2gout* and *orca2gout* are fortan programe used to extract the results from XTB and ORCA. Their source code files are *xtb2gout.f90* and *orca2gout.f90* respectively.

To combine Gaussian and ORCA or XTB, one should firstly ensure that the executable files of these softwares, as well as file *xtb2gout* and *orca2gout*, are under the paths of the environment variable.
*G2O.sh* and *G2X.sh* should be under the current folder. 
If one wants to run multiple tasks under the same folder at the same time, one should copy the script file and change its line of "prefix=TASK1":
```
sed "s/prefix=TASK1/prefix=TASK2/g" G2O.sh > G2O_2.sh
sed "s/prefix=TASK1/prefix=TASK2/g" G2X.sh > G2X_2.sh
```

## Usage
### ORCA QM task with Gaussian as an optimizer

### ORCA:XTB ONIOM(DFT:xTB) task with Gaussian as an optimizer
