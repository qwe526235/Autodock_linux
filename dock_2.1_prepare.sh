cat sample_list.txt | while read id
do
cat ../$id/protein.txt | while read t
do
for i in ../$id/protein/$t/combination/*/*.gpf
do
di=`basename $i .gpf`
#cp $i $di/backup.gpf.txt
sed -i '1i\parameter_file /home/project1/FS/mgltools/MGLToolsPckgs/AutoDockTools/AD4_parameters.dat' $i
done
for q in ../$id/protein/$t/combination/*/*.dpf
do
at=`basename $q .dpf`
#cp $q  $dt/backup.dpf.txt
sed -i '1i\parameter_file /home/project1/FS/mgltools/MGLToolsPckgs/AutoDockTools/AD4_parameters.dat' $q
done
done
done
