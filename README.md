# Puppet in 4 Hours

This repository hosts the code and examples for the Puppet in 4 hours online workshop.

## Getting Started

Download the Github repository

```bash
git clone git@github.com:martezr/puppet-in-4-hours.git
```

Change the current working directory to the Github repository

```bash
cd puppet-in-4-hours
```

The lab exercises use two Ubuntu 20.04 virtual machines that run locally using HashiCorp Vagrant. Run the `vagrant up` command to provision the virtual machines on the local machine. If you don't have Vagrant installed then it can be installed using the following documentation - https://learn.hashicorp.com/tutorials/vagrant/getting-started-install.

```bash
vagrant up
```

```bash
vagrant ssh server
```

```bash
vagrant ssh agent
```

## Exercises

[Exercise #2: Installing Puppet Server](./02-installing-puppet-server.md)

[Exercise #3: Configuring Puppet Server](./03-configuring-puppet-server.md)

[Exercise #4: Installing Puppet Agents](./04-installing-puppet-agents.md)

[Exercisen #5: Puppet Code Development](./05-puppet-code-development.md)

[Exercise #6: Using Puppet Forge Modules](./06-using-puppet-forge-modules.md)

[Exercise #7: Using Puppet Hiera for Data Separation](./07-using-puppet-hiera.md)

## Solutions

The [solutions](./solutions) section of this repository contains the full examples of the content covered during the workshop.
