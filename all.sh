logFile=${HOME}/script_`date +%Y%m%d%H%M`.log                                                             2>&1 |tee -a ${logFile}
echo "#######################SCRIPT all.sh BEGINNING EXECUTE ##############################"  2>&1 |tee -a ${logFile}
sudo setenforce 0                                                                         2>&1 |tee -a ${logFile}
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config               2>&1 |tee -a ${logFile}

#关闭swap
swapoff -a                              2>&1 |tee -a ${logFile}
sed -ri 's/.*swap.*/#&/' /etc/fstab     2>&1 |tee -a ${logFile}

#允许 iptables 检查桥接流量
cat <<EOF | sudo tee -a /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee -a /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system    2>&1 |tee -a ${logFile}

#设置时区，并同步时间(非必要)
timedatectl set-timezone Asia/Shanghai
yum -y install chrony
chronyd -q 'server ntp.sjtu.edu.cn iburst'
hwclock -w


sudo yum remove docker*        2>&1 |tee -a ${logFile}
sudo yum install -y yum-utils  2>&1 |tee -a ${logFile}

#配置docker的yum地址
wget -O /etc/yum.repos.d/docker-ce.repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo    2>&1 |tee -a ${logFile}


#安装指定版本
sudo yum install -y docker-ce-20.10.12 docker-ce-cli-20.10.12 containerd.io-1.4.12   2>&1 |tee -a ${logFile}

#	启动&开机启动docker
systemctl enable docker --now  2>&1 |tee -a ${logFile}

# docker加速配置
sudo mkdir -p /etc/docker
sudo tee -a /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://ke9h1pt4.mirror.aliyuncs.com"],
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  }
}
EOF
sudo systemctl daemon-reload   2>&1 |tee -a ${logFile}
sudo systemctl restart docker  2>&1 |tee -a ${logFile}

#配置k8s的yum源地址，这里指定为阿里云的yum源
cat <<EOF | sudo tee -a /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
   http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
echo "#######################SCRIPT all.sh EXECUTE END ##############################"  2>&1 |tee -a ${logFile}