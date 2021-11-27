# Lesson #3: Configuring Puppet Server

This lesson walks through configuring the Puppet server.

[Exercise 3.1: Creating a Control Repository](#exercise-31-creating-a-control-repository)

https://github.com/puppetlabs/control-repo

[Exercise 3.2: Installing and Configuring r10k](#exercise-32-installing-and-configuring-r10k)

# Exercise 3.1: Creating a Control Repository

# Exercise 3.2: Installing and Configuring r10k

```bash
/opt/puppetlabs/puppet/bin/gem install r10k
```

```bash
mkdir -p /etc/puppetlabs/r10k
```

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

Deploy environments and modules

```bash
sudo /opt/puppetlabs/puppet/bin/r10k deploy environment -m
```

[Next Lesson - Lesson #4: Installing Puppet Agents](./04-installing-puppet-agents.md)
