Autodock=/home/project1/FS/ADrun; #Autodock执行文件目录，根据实际目录进行更改
Data=$PWD; #数据目录，根据实际目录进行更改


################################################### 1  配体——mol2格式转pdbqt ############################################################################
for i in $(ls $Data/mol2/*.mol2)
do
	if [ -f $Data/ligand ]  #判断是否存在该文件夹
	then	 		#存在
		$Autodock/pythonsh $Autodock/prepare_ligand4.py -l $i -o $Data/ligand/$(basename ${i%.mol2}).pdbqt;
	else			#不存在
		mkdir -p $Data/ligand;  #新建文件夹
		$Autodock/pythonsh $Autodock/prepare_ligand4.py -l $i -o $Data/ligand/$(basename ${i%.mol2}).pdbqt;
	fi			#结束
done	

############################################################ 2 受体——pdb格式转pdbqt #####################################################################
for i in $(ls $Data/receptor_pdb/*.pdb)     #根据需要改文件夹
do 
	if [ -f $Data/receptor} ]  #判断文件夹是否存在
	then           #存在
		$Autodock/pythonsh $Autodock/prepare_receptor4.py -r $i -o $Data/receptor/$(basename ${i%.pdb}).pdbqt;
	else          #不存在
		mkdir -p $Data/receptor; #新建文件夹
		$Autodock/pythonsh $Autodock/prepare_receptor4.py -r $i -o $Data/receptor/$(basename ${i%.pdb}).pdbqt;
	fi
done


######################################################### 3 准备autogrid4参数文件 产生gpf文件 ########################################################################
for i in $(ls $Data/ligand/*.pdbqt)  #循环配体
 do
	for j in $(ls $Data/receptor/*.pdbqt)   #循环受体
	  do
		if [ -f $Data/combination/$(basename ${j%.pdbqt})"_"$(basename ${i%.pdbqt}) ] #判断combination文件夹是否存在
		then        #存在则将配体与受体复制到相应文件夹下
			cp $i $Data/combination/$(basename ${j%.pdbqt})"_"$(basename ${i%.pdbqt});
			cp $j $Data/combination/$(basename ${j%.pdbqt})"_"$(basename ${i%.pdbqt});
		else      #不存在则新建文件夹再复制
			mkdir -p $Data/combination/$(basename ${j%.pdbqt})"_"$(basename ${i%.pdbqt});
			cp $i $Data/combination/$(basename ${j%.pdbqt})"_"$(basename ${i%.pdbqt});
			cp $j $Data/combination/$(basename ${j%.pdbqt})"_"$(basename ${i%.pdbqt});
		fi
		$Autodock/pythonsh $Autodock/prepare_gpf4.py -l $i -r $j -p npts="10,10,10" -p gridcenter='-1,-2,-3' -p spacing="1" -o $Data/combination/$(basename ${j%.pdbqt})"_"$(basename ${i%.pdbqt})/$(basename ${j%.pdbqt})"_"$(basename ${i%.pdbqt}).gpf
	  done
 done


############################################################# 4 准备autodock4参数文件 产生dpf文件 ####################################################################
for i in $(ls $Data/receptor/*.pdbqt)
   do
	for j in $(ls $Data/ligand/*.pdbqt)
	  do
	    $Autodock/pythonsh $Autodock/prepare_dpf4.py -l $j -r $i -p ga_num_evals=25000000 -p ga_run=100 -p ga_pop_size=300 -p sw_max_its=3000 -o $Data/combination/$(basename ${i%.pdbqt})"_"$(basename ${j%.pdbqt})/$(basename ${i%.pdbqt})"_"$(basename ${j%.pdbqt}).dpf
#ga_num_evals/ga_num_evaluations 限定程序收敛条件，决定运算费时长短
#ga_run 对接次数，默认10，最好在50以上
#ga_pop_size 默认150 对接空间大小（？）
	  done
   done
