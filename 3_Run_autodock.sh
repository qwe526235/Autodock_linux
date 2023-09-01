Autodock=/home/project1/FS/ADrun; #Autodock执行文件目录，根据实际目录进行更改
Data=$PWD; #数据目录，根据实际目录进行更改

##################################################################### 6 运行autodock4 生成dlg文件 ############################################################
for i in $(ls $Data/combination/*/*.dpf)
do 
	cd $(dirname $i);	
	echo "cd $(dirname $i)" > $(basename ${i%.dpf})_dock.sh 
	#echo "$Autodock/autodock4 -p $i -l $(basename ${i%.dpf}).dlg" >> $(basename ${i%.dpf})_dock.sh
	echo "/home/project1/FS/AutoDock-GPU-develop/bin/autodock_gpu_128wi --import_dpf $i" >> $(basename ${i%.dpf})_dock.sh
	bash $(basename ${i%.dpf})_dock.sh &
	echo "autodock $(basename ${i%.dpf})"
	t=$(($t+1))
        if [[ $t -gt 0 ]]
        then
                echo $t wait a moment       
                wait
                t=0
        fi
done

