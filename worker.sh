logFile=${HOME}/worker_`date +%Y%m%d%H%M`.log 
echo "#######################SCRIPT worker.sh BEGINNING EXECUTE ##############################"   2>&1 |tee -a ${logFile}
yum -y install kubeadm-1.21.8 kubelet-1.21.8 --disableexcludes=kubernetes                     2>&1 |tee -a ${logFile}
systemctl start kubelet                                                                       2>&1 |tee -a ${logFile}
systemctl enable kubelet                                                                      2>&1 |tee -a ${logFile}
echo "#######################SCRIPT worker.sh EXECUTE END ##############################"     2>&1 |tee -a ${logFile}