# Lesson #2: Installing Puppet Server

This lesson walks through installing Puppet Server and PuppetDB.

[Exercise 2.1: Install Puppet Server](#exercise-21-install-puppet-server)
[Exercise 2.2: Install PostgreSQL](#exercise-22-install-postgresql)
[Exercise 2.3: Install and Configure PuppetDB](#exercise-23-install-and-configure-puppetdb)
[Exercise 2.4: Configure Puppet Server to PuppetDB connection](#exercise-24-configure-puppet-server-to-puppetdb-connection)

# Exercise 2.1: Install Puppet Server

This exercise walks through installing the Puppet Server package on the server node.

Download the Puppet repository package

```bash
wget https://apt.puppet.com/puppet7-release-focal.deb
```

Install the Puppet repository on the system

```bash
sudo dpkg -i puppet7-release-focal.deb
```

Trigger an apt update to enable the Puppet repository

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

This exercise walks through install and configuring the PostgreSQL database used by PuppetDB.

Install PostgreSQL

```bash
sudo apt install -y postgresql postgresql-contrib
```


```bash
sudo su postgres <<EOF
createdb -E UTF8 -O postgres puppetdb;
psql -c "CREATE USER puppetdb WITH PASSWORD 'password123';"
psql -c "CREATE USER puppetdb_read WITH PASSWORD 'password123';"
psql puppetdb -c 'revoke create on schema public from public'
psql puppetdb -c 'grant create on schema public to puppetdb'
psql puppetdb -c 'alter default privileges for user puppetdb in schema public grant select on tables to puppetdb_read'
psql puppetdb -c 'alter default privileges for user puppetdb in schema public grant usage on sequences to puppetdb_read'
psql puppetdb -c 'alter default privileges for user puppetdb in schema public grant execute on functions to puppetdb_read'
psql puppetdb -c 'create extension pg_trgm'
EOF
```

```bash
/etc/postgresql/12/main/pg_hba.conf
```

# Exercise 2.3: Install and Configure PuppetDB

This exercise walks through installing PuppetDB and connecting it to the PostgreSQL database.

Install PuppetDB

```bash
sudo /opt/puppetlabs/bin/puppet resource package puppetdb ensure=latest
```

```bash
cat << EOF > /etc/puppetlabs/puppetdb/conf.d/database.ini
[database]

# The database address, i.e. //HOST:PORT/DATABASE_NAME
subname = //localhost:5432/puppetdb

# Connect as a specific user
username = puppetdb

# Use a specific password
password = password123

# How often (in minutes) to compact the database
# gc-interval = 60
EOF
```

```bash
sudo /opt/puppetlabs/bin/puppet resource service puppetdb ensure=running enable=true
```

# Exercise 2.4: Configure Puppet Server to PuppetDB Connection

Install plugins

```bash
sudo /opt/puppetlabs/bin/puppet resource package puppetdb-termini ensure=latest
```

```bash
cat << EOF > /etc/puppetlabs/puppet/puppetdb.conf
[main]
server_urls = https://puppet:8081
EOF
```

```bash
cat << EOF >> /etc/puppetlabs/puppet/puppet.conf
reports = puppetdb
storeconfigs_backend = puppetdb
storeconfigs = true
EOF
```

```bash
cat << EOF > /etc/puppetlabs/puppet/routes.yaml
---
primary server:
  facts:
    terminus: puppetdb
    cache: yaml
EOF
```

```bash
sudo chown -R puppet:puppet /etc/puppetlabs/puppet
```

```bash
sudo systemctl restart puppetserver
```

[Next Lesson - Lesson #3: Configuring Puppet Server](./03-configuring-puppet-server.md)
