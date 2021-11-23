# Lesson #4: Installing Puppet Agents

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


[Next Lesson - Lesson #5: Puppet Code Development](./05-puppet-code-development.md)
