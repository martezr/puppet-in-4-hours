# Exercise #5: Puppet Code Development


# Exercise 

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

[Previous Exercise - Exercise #4](./04-installing-puppet-agents.md)  |  [Next Exercise - Exercise #6](./06-using-puppet-forge-modules.md)
