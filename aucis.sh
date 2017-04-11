#! /bin/bash
#Script para guardar configuraciones
FECHA=$(date +%F)		
sshpass=/usr/bin/sshpass

grep location aucis.conf | grep -v "#" | awk -F'=' '{print $2}' | awk -F' ' '{print $1}' | tr -d "\n" | tr -d "\r" > /home/tmp4
BDIR=$(cat /home/tmp4)
rm -f /home/tmp4

grep defaultPass aucis.conf | grep -v "#" | awk -F'=' '{print $2}' | awk -F' ' '{print $1}' | tr -d "\n" | tr -d "\r" > /home/tmp4
SSHPASS=$(cat /home/tmp4)
rm -f /home/tmp4

grep defaultUser aucis.conf | grep -v "#" | awk -F'=' '{print $2}' | awk -F' ' '{print $1}' | tr -d "\n" | tr -d "\r" > /home/tmp4
USER=$(cat /home/tmp4)
rm -f /home/tmp4

grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' /home/aucisDevices.conf --no-filename > /home/tmp0

IFS=$'\n'
for line in $(cat /home/tmp0)          
do 
	
    eval '$sshpass -p ${SSHPASS} ssh -o StrictHostKeyChecking=no $USER@${line} "sh run"  >  /home/tmp1'
 	eval '$sshpass -p ${SSHPASS} ssh -o StrictHostKeyChecking=no $USER@${line} "sh vlan brief"  >  /home/tmp2'
	HOSTNAME=$(cat /home/tmp1 | grep hostname | head -n 1 | cut -d ' ' -f2 | tr -d '\r')		
	SALIDA=$HOSTNAME"_"$FECHA
	
	[ ! -d $BDIR ] && mkdir $BDIR
	[ ! -d $BDIR/$HOSTNAME ] && mkdir $BDIR/$HOSTNAME
	[ ! -d $BDIR/$HOSTNAME/$FECHA ] && mkdir $BDIR/$HOSTNAME/$FECHA
	cp --backup=t /home/tmp1 $BDIR/$HOSTNAME/$FECHA/$HOSTNAME"(runningConfig).conf"
	grep -qi Ambiguous /home/tmp2 || cp --backup=t /home/tmp2 $BDIR/$HOSTNAME/$FECHA/$HOSTNAME"(vlanBrief).conf"
	rm -f /home/tmp1
	rm -f /home/tmp2
	echo $FECHA: La configuracion de $HOSTNAME ha sido respaldada
done

rm -f /home/tmp0
