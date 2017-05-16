
Vagrant.require_version ">= 1.7.0"

$os_image = (ENV['OS_IMAGE'] || "ubuntu16").to_sym

Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox"
  master = 1
  node = 2
  # Set virtualbox func
  def set_vbox(vb, config)
    vb.gui = false
    vb.memory = 1024
    vb.cpus = 1

    case $os_image
    when :centos7
      config.vm.box = "bento/centos-7.2"
    when :ubuntu16
      config.vm.box = "bento/ubuntu-16.04"
    end
  end

  private_count = 10
  (1..(master + node)).each do |mid|
    name = (mid <= node) ? "node" : "master"
    id   = (mid <= node) ? mid : (mid - node)

    config.vm.define "#{name}#{id}" do |n|
      n.vm.hostname = "#{name}#{id}"
      ip_addr = "192.16.35.#{private_count}"
      n.vm.network :private_network, ip: "#{ip_addr}",  auto_config: true

      n.vm.provider :virtualbox do |vb, override|
        vb.name = "kube-#{n.vm.hostname}"
        set_vbox(vb, override)
      end
      private_count += 1
    end
  end

  # Install of dependency packages using script
  config.vm.provision :shell, path: "./scripts/pre-install.sh"
end
