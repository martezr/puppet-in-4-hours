# Lesson #6: Using Puppet Forge Modules

This lesson walks through using modules from the Puppet Forge.

[Exercise 6.1: Installing Forge Modules](#exercise-61-installing-forge-modules)

[Exercise 6.2: Applying Forge Modules](#exercise-62-applying-forge-modules)

# Exercise 6.1: Installing Forge Modules


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

# Exercise 6.2: Applying Forge Modules

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

[Next Lesson - Lesson #7: Using Puppet Hiera for Data Separation](./07-using-puppet-hiera.md)
