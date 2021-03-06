#! /bin/bash
#Aucis Backup script
DATE=$(date +%F)		
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

grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' /home/aucisDevices.list --no-filename > /home/tmp0

IFS=$'\n'
for line in $(cat /home/tmp0)          
do 
	
    eval '$sshpass -p ${SSHPASS} ssh -o StrictHostKeyChecking=no $USER@${line} "sh run"  >  /home/tmp1'
 	eval '$sshpass -p ${SSHPASS} ssh -o StrictHostKeyChecking=no $USER@${line} "sh vlan brief"  >  /home/tmp2'
	HOSTNAME=$(cat /home/tmp1 | grep hostname | head -n 1 | cut -d ' ' -f2 | tr -d '\r')		
	SALIDA=$HOSTNAME"_"$DATE
	
	[ ! -d $BDIR ] && mkdir $BDIR
	[ ! -d $BDIR/$HOSTNAME ] && mkdir $BDIR/$HOSTNAME
	[ ! -d $BDIR/$HOSTNAME/$DATE ] && mkdir $BDIR/$HOSTNAME/$DATE
	cp --backup=t /home/tmp1 $BDIR/$HOSTNAME/$DATE/$HOSTNAME"(runningConfig).conf"
	grep -qi Ambiguous /home/tmp2 || cp --backup=t /home/tmp2 $BDIR/$HOSTNAME/$DATE/$HOSTNAME"(vlanBrief).conf"
	rm -f /home/tmp1
	rm -f /home/tmp2
	echo $DATE: Config file of $HOSTNAME has been saved
done

rm -f /home/tmp0
