$script = <<-SCRIPT
logFile=${HOME}/script_`date +%Y%m%d%H%M`.log
echo "#######################SCRIPT BEGINNING EXECUTE##############################"                               2>&1 |tee -a ${logFile}
sudo sed -i "s/#PermitRootLogin yes/PermitRootLogin yes/g" /etc/ssh/sshd_config                                2>&1 |tee -a ${logFile}
sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config                    2>&1 |tee -a ${logFile}
echo vagrant |sudo passwd --stdin root                                                                         2>&1 |tee -a ${logFile}
sudo systemctl restart sshd                                                                                    2>&1 |tee -a ${logFile}
sudo systemctl disable firewalld                                                                               2>&1 |tee -a ${logFile}
sudo systemctl stop firewalld                                                                                  2>&1 |tee -a ${logFile}
sudo echo -e "nameserver 8.8.8.8 \nnameserver 8.8.4.4"  >/etc/resolv.conf                                      2>&1 |tee -a ${logFile}
sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://repo.huaweicloud.com/repository/conf/CentOS-7-reg.repo  2>&1 |tee -a ${logFile}
sudo yum clean all                                                                                             2>&1 |tee -a ${logFile}
sudo yum makecache                                                                                             2>&1 |tee -a ${logFile}
sudo yum -y install tcpdump                                                                                    2>&1 |tee -a ${logFile}
sudo yum -y install bridge-utils                                                                               2>&1 |tee -a ${logFile}
echo "#######################SCRIPT EXECUTE END ##############################"                                2>&1 |tee -a ${logFile}
SCRIPT
Vagrant.configure("2") do |config|

  config.vm.provision "shell", inline: "echo ########### begin creating virtualbox ###########"
  
  config.vm.define "master" do |master|
		# 设置虚拟机的Box
		master.vm.box = "generic/centos7"
		# 设置虚拟机的主机名
		master.vm.hostname="master"
		# 设置虚拟机的IP
		master.vm.network "private_network", ip: "172.10.10.100", netmask: "255.255.255.0",hostname: true
		# VirtaulBox相关配置
		master.vm.provider "virtualbox" do |v|
			# 设置虚拟机的名称
			v.name = "master"
			# 设置虚拟机的内存大小
			v.memory = 2048
			# 设置虚拟机的CPU个数
			v.cpus = 2
		end
		master.vm.provision "shell", inline: $script
		master.vm.provision "shell", path: "all.sh"
		master.vm.provision "shell", path: "master.sh"
  end
  
  
  config.vm.define "worker1" do |worker1|
    		# 设置虚拟机的Box
		worker1.vm.box = "generic/centos7"
		# 设置虚拟机的主机名
		worker1.vm.hostname="woker1"
		# 设置虚拟机的IP
		worker1.vm.network "private_network", ip: "172.10.10.101", netmask: "255.255.255.0",hostname: true
		# VirtaulBox相关配置
		worker1.vm.provider "virtualbox" do |v|
			# 设置虚拟机的名称
			v.name = "woker1"
			# 设置虚拟机的内存大小
			v.memory = 2048
			# 设置虚拟机的CPU个数
			v.cpus = 2
		end
		worker1.vm.provision "shell", inline: $script
		worker1.vm.provision "shell", path: "all.sh"
		worker1.vm.provision "shell", path: "worker.sh"
  
  end
  
  config.vm.define "worker2" do |worker2|
    		# 设置虚拟机的Box
		worker2.vm.box = "generic/centos7"
		# 设置虚拟机的主机名
		worker2.vm.hostname="worker2"
		# 设置虚拟机的IP
		worker2.vm.network "private_network", ip: "172.10.10.102", netmask: "255.255.255.0",hostname: true
		# VirtaulBox相关配置
		worker2.vm.provider "virtualbox" do |v|
			# 设置虚拟机的名称
			v.name = "worker2"
			# 设置虚拟机的内存大小
			v.memory = 2048
			# 设置虚拟机的CPU个数
			v.cpus = 2
		end
		worker2.vm.provision "shell", inline: $script
		worker2.vm.provision "shell", path: "all.sh"
		worker2.vm.provision "shell", path: "worker.sh"
		config.vm.provision "shell", inline: "echo ########### all virtual machines are already been created. ###########"
  end  
end