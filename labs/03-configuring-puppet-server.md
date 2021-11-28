# Lab #3: Configuring Puppet Server

## Overview

This lab walks through configuring the Puppet server.

## Exercises

[Lab 3.1: Creating a Control Repository](#lab-31-creating-a-control-repository)

https://github.com/puppetlabs/control-repo

[Lab 3.2: Installing and Configuring r10k](#lab-32-installing-and-configuring-r10k)

# Lab 3.1: Creating a Control Repository

# Lab 3.2: Installing and Configuring r10k


1. 

```bash
/opt/puppetlabs/puppet/bin/gem install r10k
```

2. 

```bash
mkdir -p /etc/puppetlabs/r10k
```

3. 

```bash
cat << EOF > /etc/puppetlabs/r10k/r10k.yaml
# The location to use for storing cached Git repos
:cachedir: '/var/cache/r10k'

# A list of git repositories to create
:sources:
  # This will clone the git repository and instantiate an environment per
  # branch in /etc/puppetlabs/code/environments
  :production:
    remote: 'https://github.com/martezr/control-repo.git'
    basedir: '/etc/puppetlabs/code/environments'
EOF
```

4. Deploy environments and modules

```bash
sudo /opt/puppetlabs/puppet/bin/r10k deploy environment -m
```

[Previous Lab - Lab #2](./02-installing-puppet-server.md)  |  [Next Lab - Lab #4](./04-installing-puppet-agents.md)
