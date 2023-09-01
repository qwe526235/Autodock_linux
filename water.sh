Data=$(dirname $PWD)
echo $Data
cat $Data/bin/sample_list.txt | while read id ;do cat $Data/$id/protein.txt | while read t ; do cd $Data/$id/protein/$t/receptor_pdb/tt ; perl *.pl;done;done 

