Autodock=/home/project1/FS/ADrun; #Autodock执行文件目录，根据实际目录进行更改
Data=$PWD; #数据目录，根据实际目录进行更改

##################################################################### 5 运行autogird4 产生格点文件 ############################################################
for i in $(ls $Data/combination/*/*.gpf)
do
	cd $(dirname $i);	#进入该文件，生成的文件也将保存在该文件目录下
	echo "cd $(dirname $i)" > $(basename ${i%.gpf})_grid.sh 
	echo "$Autodock/autogrid4 -p $i" >> $(basename ${i%.gpf})_grid.sh
	bash $(basename ${i%.gpf})_grid.sh &
	echo "autogrid $(basename ${i%.gpf})"
	t=$(($t+1))
    	if [[ $t -gt 0 ]]
    	then
        	echo $t wait a moment       
        	wait
        	t=0
    	fi
done




