Data=$(dirname $PWD)
cat $Data/bin/sample_list.txt | while read id;do cat $Data/$id/protein.txt | while  read po ; do echo ${id}_${po}; cd $Data//$id/protein/$po ; bash 1_Prepare_Lig-Rec_new.sh; wait ; done ; done
