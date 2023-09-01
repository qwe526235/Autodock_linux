Autodock=/home/project1/FS/ADrun; #Autodock执行文件目录，根据实际目录进行更改
Data=$PWD; #数据目录，根据实际目录进行更改



###################### 7 提取结果中配体构象至my_docking.pdb################################

for i in $(ls $Data/combination/*/*.dlg);do

	if [ -f $(dirname $i)/docking ]  #[,]前后的空格是必须的;条件判断
	then	 		#条件真
		break
	else			#条件假
		mkdir -p $(dirname $i)/docking
	fi			#结束	


	#1.提取配体pdbqt坐标
        grep '^DOCKED' $i | cut -c 9- > $(dirname $i)/docking/docking.pdbqt

	#2.将pdbqt转化为pdb，也就是删去电荷和atomtyoe的两列数据
	cut -c -66 $(dirname $i)/docking/docking.pdbqt > $(dirname $i)/docking/Docking.pdb

	#3.将多模型的pdb文件到单独的pdb文件
	cd $(dirname $i)/docking
	csplit Docking.pdb /ENDMDL/ -k -z -n2 -s {*} -f $(basename ${i%.dlg})_ -b "%02d.pdb"
#	rm $(basename ${i%.dlg})_10.pdb

done


################################## 8 产生配体和受体结合的pdb文件，利用cat命令将受体和配体的坐标写在一个文件中 ###############################
for i in $(ls $Data/receptor/*.pdbqt)
do	
	i_receptor=$(basename ${i%.pdbqt})
	for j in $(ls $Data/combination/*/docking/$i_receptor*);do
		
		j_dir=$(dirname $j)
		if [ -f $j_dir/complex ]  #[,]前后的空格是必须的;条件判断
		then	 		#条件真
			break
		else			#条件假
			mkdir -p $j_dir/complex
		fi			#结束	

		
		j_complex=`echo $j_dir | cut -d'/' -f6`

#		if echo $j_complex | grep -q "$i_receptor"

#	then
			cat $i $j | grep ^ATOM > $j_dir/complex/$(basename $j)
			echo End >> $j_dir/complex/$(basename $j)
#		fi
	done
done

################################################################### 9 提取最低能量 ###########################################################
#创建结果文件
if [ -f $Data/report ]  #[,]前后的空格是必须的;条件判断
then	 		#条件真
	break
else			#条件假
	mkdir -p $Data/report;
fi			#结束



#提取最低能量
#每个小分子对应的所有最低能量
for i in $(ls $Data/mol2/*.mol2);
do
	for j in $(ls $Data/combination/*_$(basename ${i%.mol2})/*.dlg);
	do
		echo -n "$(basename ${j%.dlg})"  >> $Data/report/$(basename ${i%.mol2})_lowest_result.txt
		#-n :输出后不换行;-e \t 可输出制表符
		grep -E "^\s+1\s+1\s+.*RANKING$" $j >> $Data/report/$(basename ${i%.mol2})_lowest_result.txt
	done
done

#提取每个小分子的前20个最低能量
for i in $(ls $Data/report/*);
do
	sort -n -k 5  $i -o $i
done


