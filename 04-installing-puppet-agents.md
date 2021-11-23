# Lesson #4: Installing Puppet Agents


## Exercise 4.1: Installing and Configuring Hiera Eyaml

```bash
puppet ssl bootstrap waitforcert 0
```

List certificate requests

```bash
puppetserver ca list
```


Sign the agent certificate request

```bash
puppetserver ca sign --certname agent.localdomain
```


```bash
puppet ssl bootstrap
```

## Exercise 4.2: Puppet Certificate Autosigning

```bash

```


## Exercise 4.3: Puppet Trusted Facts



[Next Lesson - Lesson #5: Puppet Code Development](./05-puppet-code-development.md)
