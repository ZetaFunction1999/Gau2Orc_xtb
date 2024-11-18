#!/bin/bash

prefix=TASK1
prefix=$prefix-$1 
echo "XTB input file: $2"

read atoms derivs charge spin < $2 
uhf=$(echo "$spin-1" | bc) 

export OMP_NUM_THREADS=10 
export MKL_NUM_THREADS=10 

if [ $derivs == "2" ] 
then 
        echo "Running: xtb mol.xyz --namespace $prefix.xtb --chrg $charge --uhf $uhf --grad --hess > $prefix.xtb.xtbout"
        xtb $2 --namespace $prefix.xtb --chrg $charge --uhf $uhf --acc 0.5 --hess --grad > $prefix.xtb.xtbout
elif [ $derivs == "1" ] 
then 
        echo "Running: xtb mol.xyz --namespace $prefix.xtb --chrg $charge --uhf $uhf --grad > $prefix.xtb.xtbout"
        xtb $2 --namespace $prefix.xtb --chrg $charge --uhf $uhf --acc 0.5 --grad > $prefix.xtb.xtbout
else
        echo "Running: xtb mol.xyz --namespace $prefix.xtb --chrg $charge --uhf $uhf --grad > $prefix.xtb.xtbout"
        xtb $2 --namespace $prefix.xtb --chrg $charge --uhf $uhf --acc 0.5 --grad > $prefix.xtb.xtbout
fi
echo "xtb running finished!"

echo "Extracting data from xtb outputs via xtb2gout"
xtb2gout $3 $atoms $derivs $prefix.xtb.xtbout $prefix.xtb.gradient $prefix.xtb.hessian

mv $prefix.xtb.xtbout     last.$prefix.xtb.xtbout
mv $prefix.xtb.gradient   last.$prefix.xtb.gradient
mv $prefix.xtb.hessian    last.$prefix.xtb.hessian
mv $prefix.xtb.xtbrestart last.$prefix.xtb.xtbrestart
rm -f $prefix.xtb* 

mv last.$prefix.xtb.$1.xtbrestart $prefix.xtb.xtbrestart 
