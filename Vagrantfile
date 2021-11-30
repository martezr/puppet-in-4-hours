Vagrant.configure("2") do |config|
  config.vm.define "server" do |server|
    server.vm.box = "bento/ubuntu-20.04"
    server.vm.host_name = "puppet"
    server.vm.network "private_network", ip: "192.168.50.4"
    server.vm.provision "shell", inline: 'echo "192.168.50.4 puppet" >> /etc/hosts'
    server.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "4096"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
  end

  config.vm.define "agent" do |agent|
    agent.vm.box = "bento/ubuntu-20.04"
    agent.vm.host_name = "agent"
    agent.vm.network "private_network", ip: "192.168.50.5"
    agent.vm.provision "shell", inline: 'echo "192.168.50.4 puppet" >> /etc/hosts'
    agent.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
  end
end
