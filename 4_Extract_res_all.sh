Data=$PWD
if [ -f $Data/dock_report ]  #[,]前后的空格是必须的;条件判断
then                    #条件真
        break
else                    #条件假
        mkdir -p $Data/dock_report;
fi                      #结束



#提取最低能量
#每个小分子对应的所有最低能量
for i in $(ls $Data/mol2/*.mol2);
do
        for j in $(ls $Data/combination/*_$(basename ${i%.mol2})/*.dlg);
        do
                #echo -n "$(basename ${j%.dlg})"  >> $Data/dock_report/$(basename ${i%.mol2})_result.txt
                #-n :输出后不换行;-e \t 可输出制表符
                grep -E "RANKING" $j >> $Data/dock_report/$(basename ${i%.mol2})_result.txt
        done
done

for i in $(ls $Data/dock_report/*_result.txt)
do
id=`basename $i _result.txt`
sed -i 's/^/'$id' /g' $i
done

for i in $(ls $Data/dock_report/*_result.txt)
do
id=`basename $i _result.txt`
cat $i | sort -n -r  -k 5 | awk 'NR==1'> $Data/dock_report/${id}_max.txt
cat $i | awk '{sum+=$5} END {print sum/NR}' > $Data/dock_report/${id}_mean.txt
done

for i in $(ls $Data/dock_report/*_result.txt)
do
id=`basename $i _result.txt`
sed -i 's/^/'$id' /g' $Data/dock_report/${id}_mean.txt
done
