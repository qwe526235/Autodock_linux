Data=$(dirname $PWD)
[ ! -d $Data/3_step ] && mkdir $Data/3_step

cat $Data/bin/sample_list.txt | while read id
do
cat $Data/$id/protein.txt | while read t
do
cat > $Data/3_step/temp_${id}_${t}.sh <<EOF
cd $Data/${id}/protein/${t}
bash 3_Run_autodock.sh
EOF
echo temp_${id}_${t}.sh >> step3_list.txt
done
done


[ ! -d $Data/4_step ] && mkdir $Data/4_step

cat $Data/bin/sample_list.txt | while read id
do
cat $Data/$id/protein.txt | while read t
do
cat > $Data/4_step/temp_${id}_${t}.sh <<EOF
cd $Data/${id}/protein/${t}
bash 4_Extract_res.sh
EOF
echo temp_${id}_${t}.sh >> step4_list.txt
done
done


