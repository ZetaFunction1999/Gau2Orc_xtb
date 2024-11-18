#!/bin/bash

prefix=TASK1
prefix=$prefix-$1 
echo "ORCA input file: $2"

template=ORCA.tpl 
orcapath="/lustre/home/acct-clsst/clsst/Software/orca_6_0_0/orca" 

read atoms derivs charge spin < $2 

if [ $derivs == "2" ] 
then
        task="engrad freq"
elif [ $derivs == "1" ]
then
        task="engrad"
elif [ $derivs == "0" ] 
then
        task=""
fi

echo "Generating $prefix.orca.inp"
cat > $prefix.orca.xyz.tmp <<EOF 
$(sed -n 2,$(($atoms+1))p < $2 | cut -c 1-72)
EOF

#Different base sets for different atoms
#sed -i "3       s/$/ newgto \"$nbs\" end/g" $prefix.xyz.tmp
#sed -i "11      s/$/ newgto \"$nbs\" end/g" $prefix.xyz.tmp
#sed -i "89      s/$/ newgto \"$nbs\" end/g" $prefix.xyz.tmp
#sed -i "97      s/$/ newgto \"$nbs\" end/g" $prefix.xyz.tmp
#sed -i "103,110 s/$/ newgto \"$nbs\" end/g" $prefix.xyz.tmp

sed "s/TASK/$task/1" $template | \ #设置任务类型
sed "s/CHARGE/$charge/g" | \ #设置电荷数
sed "s/SPIN/$spin/g" | \ #设置自旋多重度
sed "/COORDINATE/ r $prefix.orca.xyz.tmp" | \ #从.orca.xyz.tmp文件复制原子坐标
grep -v "COORDINATE" > $prefix.orca.inp #通过模板文件生成ORCA输入文件

echo "Running orca $prefix.orca.inp > $prefix.orca.log"
/lustre/home/acct-clsst/clsst/Software/orca_6_0_0/orca $prefix.orca.inp > $prefix.orca.log

if [ `grep -c "error termination" $prefix.orca.log` -ne '0' ] #如果运行ORCA报错，删除波函数文件再次尝试
then
        echo "ERROR occurs in ORCA, retrying..."
        rm $prefix.orca.gbw
        /lustre/home/acct-clsst/clsst/Software/orca_6_0_0/orca $prefix.orca.inp > $prefix.orca.log
fi
if [ `grep -c "error termination" $prefix.orca.log` -ne '0' ] #如果依然报错，推出程序
then
        echo "ERROR remains!"
        exit 1
fi

echo "ORCA running finished!"

mv $prefix.orca.inp last.$prefix.orca.inp
mv $prefix.orca.log last.$prefix.orca.log
mv $prefix.orca.gbw last.$prefix.orca.gbw
mv $prefix.orca.xyz last.$prefix.orca.xyz

echo "Extracting data from ORCA outputs via orca2gout" #通过orca2gout程序提取输出信息并产生.Eou文件
orca2gout $3 $atoms $derivs $prefix.orca.engrad $prefix.orca.hess

rm $prefix.orca.* $prefix.orca_* -f #清空多余文件
cp last.$prefix.orca.gbw $prefix.orca.gbw #保留.gbw波函数文件，下一次运行时读取用作初猜
