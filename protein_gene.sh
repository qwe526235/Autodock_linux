cat new_list.txt | while read id; do for i in `ls ../${id}/PDB/*.pdb`; do t=`basename $i .pdb` ; n=${t%.pdb};echo $n  >> ../${id}/protein.txt; done; done
