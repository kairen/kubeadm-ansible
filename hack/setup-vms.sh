#!/bin/bash
#
# Program: Initial vagrant.
# History: 2017/1/16 Kyle.b Release


function set_hosts() {
cat <<EOF > ~/hosts
127.0.0.1   localhost
::1         localhost

192.16.35.10 k8s-n1
192.16.35.11 k8s-n2
192.16.35.12 k8s-m1

EOF
}

set -e
HOST_NAME=$(hostname)
OS_NAME=$(awk -F= '/^NAME/{print $2}' /etc/os-release | grep -o "\w*"| head -n 1)

if [ ${HOST_NAME} == "k8s-m1" ]; then
  case "${OS_NAME}" in
    "CentOS")
      sudo yum install -y epel-release
      sudo yum install -y git ansible sshpass python-netaddr openssl-devel
    ;;
    "Ubuntu")
      sudo sed -i 's/us.archive.ubuntu.com/tw.archive.ubuntu.com/g' /etc/apt/sources.list
      sudo apt-add-repository -y ppa:ansible/ansible
      sudo apt-get update && sudo apt-get install -y ansible git sshpass python-netaddr libssl-dev
    ;;
    *)
      echo "${OS_NAME} is not support ..."; exit 1
  esac

  yes "/root/.ssh/id_rsa" | sudo ssh-keygen -t rsa -N ""
  HOSTS="192.16.35.10 192.16.35.11 192.16.35.12"
  for host in ${HOSTS}; do
    sudo sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@${host} "sudo mkdir -p /root/.ssh"
    sudo cat /root/.ssh/id_rsa.pub | \
         sudo sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@${host} "sudo tee /root/.ssh/authorized_keys"
  done

  cd /vagrant
  set_hosts
  sudo cp ~/hosts /etc/
  sudo ansible-playbook -e network_interface=eth1 site.yaml
else
  set_hosts
  sudo cp ~/hosts /etc/
fi
