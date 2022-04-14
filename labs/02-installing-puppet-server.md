# Lab #2: Installing Puppet Server

## Overview
In this lab you will walk through the process of setting up the Puppet primary server component in the Puppet architecture. You will install the Puppet server, PuppetDB and PostgreSQL components on the same virtual machine that acts as the server node.

## Exercises

[Lab 2.1: Install Puppet Server](#lab-21-install-puppet-server)

[Lab 2.2: Install PostgreSQL](#lab-22-install-postgresql)

[Lab 2.3: Install and Configure PuppetDB](#lab-23-install-and-configure-puppetdb)

[Lab 2.4: Configure Puppet Server to PuppetDB connection](#lab-24-configure-puppet-server-to-puppetdb-connection)

[Lab 2.5: Validat the Puppet Server installation](#lab-25-validate-the-puppet-server-installation)

### Lab 2.1: Install Puppet Server

This lab walks through installing the Puppet Server package on the server node.

1. Download the Puppet repository package.

```bash
wget https://apt.puppet.com/puppet7-release-focal.deb
```

2. Install the Puppet repository on the system.

```bash
sudo dpkg -i puppet7-release-focal.deb
```

3. Trigger an apt update to enable the Puppet repository.

```bash
sudo apt-get update -y
```

4. Install the puppetserver package on the system.

```bash
sudo apt-get install -y puppetserver
```

5. Start the puppetserver service.

```bash
sudo systemctl start puppetserver
```

6. Enable the puppetserver service to start on boot.

```bash
sudo systemctl enable puppetserver
```

### Lab 2.2: Install PostgreSQL

This lab walks through installing and configuring the PostgreSQL database used by PuppetDB.

1. Install the PostgreSQL package.

```bash
sudo apt install -y postgresql postgresql-contrib
```

2. Create the PuppetDB database, users and privileges.

> :warning: The passwords for the puppetdb and puppetdb_read user accounts should be set to a more secure password for production deployments

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

### Lab 2.3: Install and Configure PuppetDB

This lab walks through installing PuppetDB and connecting it to the PostgreSQL database.

1. Install PuppetDB using the `puppet resource` command.

```bash
sudo /opt/puppetlabs/bin/puppet resource package puppetdb ensure=latest
```

2. Configure the PuppetDB database connection details.

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

3. Start the PuppetDB service and enable it to start on boot using the `puppet resource` command.

```bash
sudo /opt/puppetlabs/bin/puppet resource service puppetdb ensure=running enable=true
```

# Lab 2.4: Configure Puppet Server to PuppetDB Connection

This lab walks through configuring the Puppet server integration with PuppetDB.

1. Install additional ruby plugins

```bash
sudo /opt/puppetlabs/bin/puppet resource package puppetdb-termini ensure=latest
```

2. Edit the puppetdb.conf configuration file

```bash
cat << EOF > /etc/puppetlabs/puppet/puppetdb.conf
[main]
server_urls = https://puppet:8081
EOF
```

3. Update the puppet.conf configuration file

```bash
cat << EOF >> /etc/puppetlabs/puppet/puppet.conf
reports = puppetdb
storeconfigs_backend = puppetdb
storeconfigs = true
EOF
```

4. Update the routes.yaml configuration file

```bash
cat << EOF > /etc/puppetlabs/puppet/routes.yaml
---
primary server:
  facts:
    terminus: puppetdb
    cache: yaml
EOF
```

5. Update the file permissions on all files in the Puppet configuration directory.

```bash
sudo chown -R puppet:puppet /etc/puppetlabs/puppet
```

6. Restart the Puppet Server service.

```bash
sudo systemctl restart puppetserver
```

### Lab 2.5: Validate the Puppet Server installation

This lab walks through validating the installation of the Puppet Server.

1. Verify the status of the puppetserver service.

```bash
systemctl status puppetserver
```

The service should have a state of loaded and active similar to the output displayed below.

```bash
● puppetserver.service - puppetserver Service
     Loaded: loaded (/lib/systemd/system/puppetserver.service; enabled; vendor preset: enable>
     Active: active (running) since Sat 2022-04-09 14:01:04 UTC; 1min 12s ago
    Process: 19544 ExecStart=/opt/puppetlabs/server/apps/puppetserver/bin/puppetserver start >
   Main PID: 19589 (java)
      Tasks: 46 (limit: 4915)
     Memory: 995.6M
     CGroup: /system.slice/puppetserver.service
             └─19589 /usr/bin/java -Xms2g -Xmx2g -Djruby.logger.class=com.puppetlabs.jruby_ut>

Apr 09 14:00:51 puppet systemd[1]: Starting puppetserver Service...
Apr 09 14:01:04 puppet systemd[1]: Started puppetserver Service.
```

2. Verify the status of the puppetdb service.

```bash
systemctl status puppetdb
```

The service should have a state of loaded and active similar to the output displayed below.

```bash
● puppetdb.service - puppetdb Service
     Loaded: loaded (/lib/systemd/system/puppetdb.service; enabled; vendor preset: enabled)
     Active: active (running) since Sat 2022-04-09 14:00:03 UTC; 4min 57s ago
   Main PID: 19154 (java)
      Tasks: 51 (limit: 4915)
     Memory: 308.6M
     CGroup: /system.slice/puppetdb.service
             └─19154 /usr/bin/java -Xmx192m -Djdk.tls.ephemeralDHKeySize=2048 -XX:OnOutOfMemo>

Apr 09 13:59:56 puppet systemd[1]: Starting puppetdb Service...
Apr 09 14:00:03 puppet systemd[1]: Started puppetdb Service.
```

3. Verify the status of the postgres database service.

```bash
systemctl status postgresql@12-main
```

The service should have a state of loaded and active similar to the output displayed below.

```bash
● postgresql@12-main.service - PostgreSQL Cluster 12-main
     Loaded: loaded (/lib/systemd/system/postgresql@.service; enabled-runtime; vendor preset: enabled)
     Active: active (running) since Sat 2022-04-09 13:57:50 UTC; 12min ago
   Main PID: 17267 (postgres)
      Tasks: 57 (limit: 4617)
     Memory: 151.5M
     CGroup: /system.slice/system-postgresql.slice/postgresql@12-main.service
             ├─17267 /usr/lib/postgresql/12/bin/postgres -D /var/lib/postgresql/12/main -c config_file=/e>
             ├─17269 postgres: 12/main: checkpointer
             ├─17270 postgres: 12/main: background writer
             ├─17271 postgres: 12/main: walwriter
             ├─17272 postgres: 12/main: autovacuum launcher
             ├─17273 postgres: 12/main: stats collector
```

4. Verify that the services are listening for network connections

```bash
ss -tupln
```

The Puppet services should be listening on the appropriate ports similar to the output displayed below.

```bash
Netid   State    Recv-Q    Send-Q            Local Address:Port       Peer Address:Port   Process
udp     UNCONN   0         0                 127.0.0.53%lo:53              0.0.0.0:*       users:(("systemd-resolve",pid=593,fd=12))
udp     UNCONN   0         0                10.0.2.15%eth0:68              0.0.0.0:*       users:(("systemd-network",pid=1312,fd=21))
udp     UNCONN   0         0                       0.0.0.0:111             0.0.0.0:*       users:(("rpcbind",pid=592,fd=5),("systemd",pid=1,fd=70))
udp     UNCONN   0         0                          [::]:111                [::]:*       users:(("rpcbind",pid=592,fd=7),("systemd",pid=1,fd=72))
tcp     LISTEN   0         4096                    0.0.0.0:111             0.0.0.0:*       users:(("rpcbind",pid=592,fd=4),("systemd",pid=1,fd=68))
tcp     LISTEN   0         4096              127.0.0.53%lo:53              0.0.0.0:*       users:(("systemd-resolve",pid=593,fd=13))
tcp     LISTEN   0         128                     0.0.0.0:22              0.0.0.0:*       users:(("sshd",pid=885,fd=3))
tcp     LISTEN   0         244                   127.0.0.1:5432            0.0.0.0:*       users:(("postgres",pid=17267,fd=4))
tcp     LISTEN   0         4096                       [::]:111                [::]:*       users:(("rpcbind",pid=592,fd=6),("systemd",pid=1,fd=71))
tcp     LISTEN   0         50           [::ffff:127.0.0.1]:8080                  *:*       users:(("java",pid=19154,fd=28))
tcp     LISTEN   0         50                            *:8081                  *:*       users:(("java",pid=19154,fd=34))
tcp     LISTEN   0         128                        [::]:22                 [::]:*       users:(("sshd",pid=885,fd=4))
tcp     LISTEN   0         244                       [::1]:5432               [::]:*       users:(("postgres",pid=17267,fd=3))
tcp     LISTEN   0         50                            *:8140                  *:*       users:(("java",pid=19589,fd=39))
```

5. Verify that things are working by triggering a Puppet agent run on the primary puppet server.

```bash
/opt/puppetlabs/bin/puppet agent -t
```

## Review

In this lab, you have:

+ Installed and configured Puppet Server
+ Installed and configured the PostgreSQL database for PuppetDB
+ Installed and configured PuppetDB
+ Configured the PuppetDB integration for Puppet Server
+ Validate the Puppet Server installation

[Next Lab - Lab #3](./03-configuring-puppet-server.md)
