Data=$(dirname $PWD)
echo $Data
cat $Data/bin/sample_list.txt | while read id;do cat $Data/$id/protein.txt | while  read po ; do echo $id_$po ;cd $Data/$id/protein/$po  ; bash 2_Run_autogrid.sh; wait ; done ; done
