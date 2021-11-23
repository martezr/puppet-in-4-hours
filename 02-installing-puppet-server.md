# Lesson #2: Installing Puppet Server

```bash
wget https://apt.puppet.com/puppet7-release-focal.deb
```

Install the Puppet repository on the system

```bash
sudo dpkg -i puppet7-release-focal.deb
```

```bash
sudo apt-get update -y
```

```bash
sudo apt-get install -y puppetserver
```

Start the puppetserver service

```bash
sudo systemctl start puppetserver
```

Enable the puppetserver service to start on boot

```bash
sudo systemctl enable puppetserver
```

[Next Lesson - Lesson #3: Configuring Puppet Server](./03-configuring-puppet-server.md)
