# Lab #3: Configuring Puppet Server

## Overview

This lab walks through configuring the Puppet server.

## Exercises

[Lab 3.1: Creating a Control Repository](#lab-31-creating-a-control-repository)

[Lab 3.2: Installing and Configuring r10k](#lab-32-installing-and-configuring-r10k)

### Lab 3.1: Creating a Control Repository

1. Create a fork of the Puppet control repository template

```
https://github.com/puppetlabs/control-repo
```

### Lab 3.2: Installing and Configuring r10k

1. Install the r10k gem.

```bash
/opt/puppetlabs/puppet/bin/gem install r10k
```

2. Create a directory for the r10k configuration file.

```bash
mkdir -p /etc/puppetlabs/r10k
```

3. Create the r10k configuration file and replace the remote repository with the repository you previously created for your control repository.

```bash
cat << EOF > /etc/puppetlabs/r10k/r10k.yaml
# The location to use for storing cached Git repos
:cachedir: '/var/cache/r10k'

# A list of git repositories to create
:sources:
  # This will clone the git repository and instantiate an environment per
  # branch in /etc/puppetlabs/code/environments
  :production:
    remote: 'https://github.com/martezr/control-repo.git' ## REPLACE WITH YOUR REPOSITORY ##
    basedir: '/etc/puppetlabs/code/environments'
EOF
```

4. Deploy environments and modules.

```bash
sudo /opt/puppetlabs/puppet/bin/r10k deploy environment -m
```

## Review

In this lab, you have:

+ Created a Puppet control repository
+ Installed and configured r10k

[Previous Lab - Lab #2](./02-installing-puppet-server.md)  |  [Next Lab - Lab #4](./04-installing-puppet-agents.md)
