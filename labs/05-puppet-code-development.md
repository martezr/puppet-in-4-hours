# Lab #5: Puppet Code Development

## Overview

In this lab you will walk through the process of creating a Puppet module using several basic Puppet coding constructs such as classes, resource types and templates.

## Exercises

[Lab 5.1: Install Puppet agent](#lab-41-install-puppet-agent)

[Lab 5.2: Bootstrap Puppet agent](#lab-42-bootstrap-puppet-agent)

### Lab 5.1: 

```bash
class nginx (
  String                     $version           = '1.1.1',
)
{


  package { 'nginx':
    ensure => 'present',
  }

  file { 'kuma control plane service':
    ensure  => present,
    path    => '/etc/systemd/system/kuma-cp.service',
    content => epp('kuma/kuma-cp.service.epp'),
    owner   => $kuma::kuma_user,
    group   => $kuma::kuma_group,
  }

  service { 'nginx':
    ensure   => 'running',
    name     => 'nginx',
    enable   => true,
    provider => 'systemd',
  }
}
```

## Review

In this lab, you have:

+ Generate a Puppet module
+ Installed and configured the PostgreSQL database for PuppetDB

[Previous Lab - Lab #4](./04-installing-puppet-agents.md)  |  [Next Lab - Lab #6](./06-using-puppet-forge-modules.md)
