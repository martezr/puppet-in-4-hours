# Lesson #7: Using Puppet Hiera for Data Separation

Install Hiera Eyaml

```bash
/opt/puppetlabs/server/bin/puppetserver gem install hiera-eyaml
```

Create a directory

```bash
mkdir -p /etc/puppetlabs/puppet/eyaml
```

Change the working directory to the newly created directory

```bash
cd /etc/puppetlabs/puppet/eyaml
```

Create a new key pair

```bash
/opt/puppetlabs/puppet/bin/eyaml createkeys
```

```bash
chown -R puppet:puppet /etc/puppetlabs/puppet/eyaml/keys
```

```bash
chmod -R 0500 /etc/puppetlabs/puppet/eyaml/keys
```

```bash
chmod 0400 /etc/puppetlabs/puppet/eyaml/keys/*.pem
```


/opt/puppetlabs/puppet/bin/eyaml encrypt -s 'hello there'
