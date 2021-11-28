# Lesson #2: Installing Puppet Server

This lesson walks through installing Puppet Server and PuppetDB.

[Exercise 2.1: Install Puppet Server](#exercise-21-install-puppet-server)

[Exercise 2.2: Install PostgreSQL](#exercise-22-install-postgresql)

[Exercise 2.3: Install and Configure PuppetDB](#exercise-23-install-and-configure-puppetdb)

[Exercise 2.4: Configure Puppet Server to PuppetDB connection](#exercise-24-configure-puppet-server-to-puppetdb-connection)

# Exercise 2.1: Install Puppet Server

This exercise walks through installing the Puppet Server package on the server node.

1. Download the Puppet repository package

```bash
wget https://apt.puppet.com/puppet7-release-focal.deb
```

2. Install the Puppet repository on the system

```bash
sudo dpkg -i puppet7-release-focal.deb
```

3. Trigger an apt update to enable the Puppet repository

```bash
sudo apt-get update -y
```

4. Install the puppetserver package on the system

```bash
sudo apt-get install -y puppetserver
```

5. Start the puppetserver service

```bash
sudo systemctl start puppetserver
```

6. Enable the puppetserver service to start on boot

```bash
sudo systemctl enable puppetserver
```

# Exercise 2.2: Install PostgreSQL

This exercise walks through install and configuring the PostgreSQL database used by PuppetDB.

1. Install PostgreSQL

```bash
sudo apt install -y postgresql postgresql-contrib
```

2. 

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

3. 

```bash
/etc/postgresql/12/main/pg_hba.conf
```

# Exercise 2.3: Install and Configure PuppetDB

This exercise walks through installing PuppetDB and connecting it to the PostgreSQL database.

1. Install PuppetDB

```bash
sudo /opt/puppetlabs/bin/puppet resource package puppetdb ensure=latest
```

2. Configure the PuppetDB database connection details

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

3. Start the PuppetDB service and enable it to start on boot

```bash
sudo /opt/puppetlabs/bin/puppet resource service puppetdb ensure=running enable=true
```

# Exercise 2.4: Configure Puppet Server to PuppetDB Connection

1. Install plugins

```bash
sudo /opt/puppetlabs/bin/puppet resource package puppetdb-termini ensure=latest
```

2. 

```bash
cat << EOF > /etc/puppetlabs/puppet/puppetdb.conf
[main]
server_urls = https://puppet:8081
EOF
```

3. 

```bash
cat << EOF >> /etc/puppetlabs/puppet/puppet.conf
reports = puppetdb
storeconfigs_backend = puppetdb
storeconfigs = true
EOF
```

4. 

```bash
cat << EOF > /etc/puppetlabs/puppet/routes.yaml
---
primary server:
  facts:
    terminus: puppetdb
    cache: yaml
EOF
```

5. Update the file permissions on all files in the Puppet configuration directory

```bash
sudo chown -R puppet:puppet /etc/puppetlabs/puppet
```

6. Restart the Puppet Server service

```bash
sudo systemctl restart puppetserver
```

[Next Lesson - Lesson #3: Configuring Puppet Server](./03-configuring-puppet-server.md)
