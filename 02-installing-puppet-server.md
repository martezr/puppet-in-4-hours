# Lesson #2: Installing Puppet Server

This lesson walks through installing and configuring the Puppet agent on the agent node.

[Exercise 2.1: Install and bootstrap the Puppet agent](#exercise-21-install-puppet-server)

# Exercise 2.1: Install Puppet Server

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

Install the puppetserver package on the system

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


# Exercise 2.2: Install PostgreSQL

```bash
/etc/postgresql/12/main/pg_hba.conf
```

# Exercise 2.3: Configure PuppetDB


```bash
/etc/puppetlabs/puppetdb/conf.d/database.ini
```

```bash
[database]

# The database address, i.e. //HOST:PORT/DATABASE_NAME
subname = //localhost:5432/puppetdb

# Connect as a specific user
username = puppetdb

# Use a specific password
password = password123

# How often (in minutes) to compact the database
# gc-interval = 60
```

```bash
sudo puppet resource service puppetdb ensure=running enable=true
```

# Exercise 2.4: Configure Puppet Server to PuppetDB Connection

Install plugins

```bash
sudo puppet resource package puppetdb-termini ensure=latest
```




[Next Lesson - Lesson #3: Configuring Puppet Server](./03-configuring-puppet-server.md)
