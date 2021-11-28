# Lab #6: Using Puppet Forge Modules

## Overview

This lab walks through using modules from the Puppet Forge.

## Exercises

[Lab 6.1: Installing Forge Modules](#lab-61-installing-forge-modules)

[Lab 6.2: Applying Forge Modules](#lab-62-applying-forge-modules)

### Lab 6.1: Installing Forge Modules


1. Add the following to the Puppetfile in the control repository

```bash
mod 'puppetlabs-ntp', '9.1.0'
mod 'puppetlabs-stdlib', '8.1.0'
```

2. Add the changes

```bash
git add --all
```

3. Commit the changes to the git repository

```bash
git commit -m 'Add NTP module'
```

4. Push the changes to the git remote server

```bash
git push origin
```

5. Deploy the modules on the Puppet server

```bash
r10k deployment environment -m
```

6. Verify that the ntp module has been added to the Puppet server

```bash
ls /etc/puppetlabs/puppet/code/environments/production/modules
```

### Lab 6.2: Applying Forge Modules

2. 

```bash
node agent.localdomain {
  include ntp
}
```

3. Commit the changes to the git repository

```bash
git commit -m 'Assign the NTP module'
```

4. Push the changes to the git remote server

```bash
git push origin
```

5. Deploy the modules on the Puppet server

```bash
r10k deployment environment -m
```

6. Verify that the ntp module has been added to the Puppet server

```bash
cat /etc/puppetlabs/puppet/code/environments/production/manifest/site.pp
```

## Review

In this lab, you have:

+ Installed a Puppet Forge module
+ Applied a Puppet Forge module

[Previous Lab - Lab #5](./05-puppet-code-development.md)  |  [Next Lab - Lab #7](./07-using-puppet-hiera.md)
