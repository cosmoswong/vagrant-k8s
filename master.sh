logFile=${HOME}/master_`date +%Y%m%d%H%M`.log 
echo "#######################SCRIPT master.sh BEGINNING EXECUTE ##############################"   2>&1 |tee -a ${logFile} 
yum -y install kubeadm-1.21.8 kubelet-1.21.8 kubectl-1.21.8 --disableexcludes=kubernetes      2>&1 |tee -a ${logFile}
systemctl enable --now kubelet                                                                2>&1 |tee -a ${logFile}

#172.10.10.100为master的IP
kubeadm init  --apiserver-advertise-address=172.10.10.100 \
  --image-repository registry.aliyuncs.com/google_containers  \
  --service-cidr=10.96.0.0/12  \
  --pod-network-cidr=10.244.0.0/16 \
  2>&1 |tee -a ${logFile}

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#安装flannel
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml 2>&1 |tee -a ${logFile}
echo "######################SCRIPT master.sh EXECUTE END ##############################"   2>&1 |tee -a ${logFile}