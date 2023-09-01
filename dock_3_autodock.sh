for i in ../3_step/*.sh
do
	bash $i
done

wait

for i in ../4_step/*.sh
do
	bash $i
done
