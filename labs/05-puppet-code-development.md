# Lab #5: Puppet Code Development

## Overview

In this lab you will walk through the process of creating a Puppet module using several basic Puppet coding constructs such as classes, resource types and templates.

## Exercises

[Lab 5.1: Generate a Puppet Module](#lab-51-generate-a-puppet-module)

[Lab 5.2: Assign the Puppet Module](#lab-52-assign-the-puppet-module)

### Lab 5.1: Generate a Puppet Module

1. Generate a new module using the `pdk new module` command.

```bash
pdk new module
```

2. Add the following content to the init.pp manifest.

```bash
class nginx (
  String	$version           = '1.1.1',
)
{
  package { 'nginx':
    ensure => 'installed',
  }

  $os_details = $facts['os']['distro']['description']
  $content    = "OS - $os_details\n"

  file {'/var/www/html/index.html':
    ensure  => file,
    path    => '/var/www/html/index.html',
    mode    => '0644',
    content => epp('nginx/index.html.epp', {'os_details' => $os_details}),
  }

  service { 'nginx':
    ensure => 'running',
    name   => 'nginx',
    enable => true,
  }
}
```


``bash
<!DOCTYPE html>
<html>
<body>

<h1>Puppet Nginx</h1>

<p>OS Details: <%= $os_details%>.</p>

</body>
</html>
```

### Lab 5.2: Assign the Puppet Module

1. Create a git repository for the new Puppet module

2. Initialize the git repository.

```bash
git init
```

3. Add the content to the repository

```bash
git add --all
```

4. Create a commit for the code

```bash
git commit -m "initial code commit"
```

5. Set the default branch name

```bash
git branch -M main
```

6. Add the git remote for the repository

```bash
git remote add origin git@github.com:martezr/puppet-nginx.git
```

7. Push the git repository

```bash
git push -u origin main
```

8. Add the git repository to the Puppetfile in the control repository

```bash
mod 'nginx',
  git: 'https://github.com/martezr/puppet-nginx.git',
  ref: 'main'
```

9. Add the following to the manifest/site.pp manifest in the Puppet control repository.

```bash
node agent.localdomain {
  include nginx
}
```

10. Add the code changes to the git repository

```bash
git add --all
```

11. Commit the code changes

```bash
git commit -m 'Add nginx module'
```

12. Push the code changes to the git repository

```bash
git push origin
```

13. Deploy the module to the Puppet server

```bash
sudo /opt/puppetlabs/puppet/bin/r10k deploy environment -m
```

## Review

In this lab, you have:

+ Generate a Puppet module
+ Assign the Puppet module

[Previous Lab - Lab #4](./04-installing-puppet-agents.md)  |  [Next Lab - Lab #6](./06-using-puppet-forge-modules.md)
