# Lab #5: Puppet Code Development

## Overview


## Exercises

# Lab 5.1: 

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

+ Installed and configured Puppet Server
+ Installed and configured the PostgreSQL database for PuppetDB
+ Installed and configured PuppetDB
+ Configured the PuppetDB integration for Puppet Server


[Previous Lab - Lab #4](./04-installing-puppet-agents.md)  |  [Next Lab - Lab #6](./06-using-puppet-forge-modules.md)
