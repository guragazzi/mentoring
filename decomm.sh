#!/bin/bash

# VARIABLES
lastDay=$(LANG=C TZ=24 date "+%Y-%m-%d")
baseDir="/home/adsm/decom"
binDir="/usr/bin"
tsmAdm=$(cat $baseDir/.credent|cut -d, -f1)
tsmPass=$(cat $baseDir/.credent|cut -d, -f2)
cmdTab="$binDir/dsmadmc -id=$tsmAdm -pa=$tsmPass -dataonly=yes -tab"
cmdCom="$binDir/dsmadmc -id=$tsmAdm -pa=$tsmPass -dataonly=yes -comma"

# Log Function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# USER QUESTIONS
read -p "VM to be DECOMM? " vm
read -p "CHANGE NUMBER? " CHANGE
read -p "CTASK NUMBER? " TASK

log "Begining process for VM: $vm"

#Check for backups to evidence:
#run the script /home/adsm/check-bkp-cr.sh

# Loop
# Searching for TSM - Where VM is
TSM=$(grep -iw $vm /reports/history/output/baseline.out | grep VMFULL | cut -d, -f1)

log "Processando TSM: $TSM"

# Search schedules with VM
SchedVm=$($cmdTab -se="$TSM" "SELECT schedule_name,options FROM CLIENT_SCHEDULES WHERE LOWER(options) LIKE LOWER('%$vm%') or UPPER(options) LIKE UPPER('%$vm%')" | egrep -v '_RST' | grep -E "${vm}(,|\")")
if [  ! -z "$SchedVm" ]
then
  echo "$SchedVm" | while IFS=" " read -r SCHED MODE OPT
  do
    # Search Schedule option and check if it exist
    if [ -n "$OPT" ]
    then
      #Look if VM is in the middle
      if [[ "$OPT" == *,$vm,* ]]
      then
      NEWOPT=$(echo $OPT| sed 's/'$vm',//')
      NEWSCHED_NAME=$(echo $SCHED | awk '{print $1}')
      NEWSCHED_ASNODE=$(echo $SCHED | awk '{print $2}')
      echo "LOG ON THE TSM $TSM"
      echo "upd sched VMW $NEWSCHED_NAME -opt='$NEWSCHED_ASNODE $MODE $NEWOPT""'"
      #Look if VM is in the end
      elif [[ "$OPT" == *,$vm'"'* ]]; then
      NEWOPT=$(echo $OPT| sed 's/,'$vm'//')
      NEWSCHED_NAME=$(echo $SCHED | awk '{print $1}')
      NEWSCHED_ASNODE=$(echo $SCHED | awk '{print $2}')
      echo "LOG ON THE TSM $TSM"
      echo "upd sched VMW $NEWSCHED_NAME -opt='$NEWSCHED_ASNODE $MODE $NEWOPT""'"
      #Look if VM is in the begin
      elif [[ "$OPT" == *'"'$vm,* ]]; then
      NEWOPT=$(echo $OPT| sed 's/'$vm',//'
      NEWSCHED_NAME=$(echo $SCHED | awk '{print $1}')
      NEWSCHED_ASNODE=$(echo $SCHED | awk '{print $2}'))
      echo "LOG ON THE TSM $TSM"
      echo "upd sched VMW $NEWSCHED_NAME -opt='$NEWSCHED_ASNODE $MODE $NEWOPT""'"
      
      fi
    fi
  done
      echo "DEF SCRATCHPAD DECOMM VM $vm line=1 data=\"$CHANGE - $TASK\""
else
    log "Nenhuma opção encontrada para $vm no schedule $SCHED"
fi

#DECOM DE NODE BACLI
TSM=$(grep -iw $vm /reports/history/output/baseline.out | egrep -v VMFULL | cut -d, -f1)
echo "$TSM" | while read TSMNODE_LINE
do
  $cmdTab -se="$TSM" "q sched * * n=$vm" | while read SCHED_NODE
  do
    DOMAIN=$(echo "$TSMNODE_LINE" | awk '{print $1}')
    SCHED_NAME=$(echo "$TSMNODE_LINE" | awk '{print $2}')
    echo "upd..."
    CONTACT=$($cmdTab -se="$TSM" "select contact from nodes where node_name='$vm'")
    echo "upd node $vm contact=" "'" "$CONTACT - DECOMM $CHANGE - $TASK" "'"
    echo "upd node $vm D_$vm""
    echo "lock node D_$vm"
  done
done


log "End of the Program"
