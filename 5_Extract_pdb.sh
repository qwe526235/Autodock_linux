Autodock=/home/project1/FS/ADrun; #Autodock执行文件目录，根据实际目录进行更改
Data=$PWD; #数据目录，根据实际目录进行更改



################################################## 10 提取复合物 #############################################################################################
#提取对接次数
run=() #记录第几次对接
complex=() #记录哪一个复合物

if [ -f $Data/Result-PDB ]  #[,]前后的空格是必须的;条件判断
then	 		#条件真
	break
	else			#条件假
		mkdir -p $Data/Result-PDB;
		fi			#结束

#提取能量最低的前20复合物坐标
		for i in $(ls $Data/report/*);
			do
				run=(`awk ' { print $4 }' $i `)
				complex=(`awk ' { print $1 }' $i`)
				for((j=0;j<20;j++));do	
					j_run=${run[$j]}
					j_com=${complex[$j]}
					k_run=$(($j_run-1))
					n_run=$(printf "%02d" "$k_run")
#					name=$j_com"_0"$k_run".pdb"
					name=$j_com"_"$n_run".pdb"
					cp $Data/combination/$j_com/docking/complex/$name $Data/Result-PDB;
				done
		done

