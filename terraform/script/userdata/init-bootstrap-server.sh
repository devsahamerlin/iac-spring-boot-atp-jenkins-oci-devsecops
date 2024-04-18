#!/bin/bash
sudo hostnamectl set-hostname ${name}
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo echo ubuntu:${password} | /usr/sbin/chpasswd
sudo apt update -y
sudo apt upgrade -y

sudo apt install unzip -y

#### Install Docker
sudo apt-get update
sudo apt-get install docker.io -y
sudo usermod -aG docker $USER
newgrp docker
sudo chown -R $USER:docker /var/run/docker.sock
sudo chmod 777 /var/run/docker.sock
sudo apt install tree -y

#### Install Trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy -y
trivy --version

sudo apt-get install ansible -y
sudo apt-get install git -y
sudo mkdir /etc/ansible/

sudo mkdir /home/ubuntu/wallet_oci_atp_db_cicd_app
sudo chown -R $USER:docker /home/ubuntu/wallet_oci_atp_db_cicd_app
sudo chmod 777 /home/ubuntu/wallet_oci_atp_db_cicd_app

### Install ArgoCD
sudo apt install -y curl wget apt-transport-https
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
sudo install minikube-linux-arm64 /usr/local/bin/minikube
minikube version

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

minikube start --driver=docker
minikube status
minikube addons list

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm version

sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 8088 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 8082 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 8083 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT

