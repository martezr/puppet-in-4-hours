# Lesson #7: Using Puppet Hiera for Data Separation

This lesson walks through using Puppet Hiera for data separation.

[Exercise 7.1: Configure Hiera](#exercise-71-configure-hiera)

[Exercise 7.2: Bootstrap Puppet agent](#exercise-72-bootstrap-puppet-agent)

[Exercise 7.3: Installing and Configure Hiera Eyaml](#exercise-73-installing-and-configuring-hiera-eyaml)

[Exercise 7.4: Encrypting Senstive Data with Hiera Eyaml](#exercise-74-encrypting-senstive-data-with-hiera-eyaml)


# Exercise 7.1: Configure Hiera

# Exercise 7.3: Installing and Configuring Hiera Eyaml

1. Install Hiera Eyaml

```bash
/opt/puppetlabs/server/bin/puppetserver gem install hiera-eyaml
```

2. Create a directory

```bash
mkdir -p /etc/puppetlabs/puppet/eyaml
```

3. Change the working directory to the newly created directory

```bash
cd /etc/puppetlabs/puppet/eyaml
```

4. Generate a new key pair for encryption and decryption

```bash
/opt/puppetlabs/puppet/bin/eyaml createkeys
```

5. Update the file ownership on the generated keys

```bash
chown -R puppet:puppet /etc/puppetlabs/puppet/eyaml/keys
```

6. Update the file permissions on the keys directory

```bash
chmod -R 0500 /etc/puppetlabs/puppet/eyaml/keys
```

7. 

```bash
chmod 0400 /etc/puppetlabs/puppet/eyaml/keys/*.pem
```

# Exercise 7.4: Encrypting Senstive Data with Hiera Eyaml

/opt/puppetlabs/puppet/bin/eyaml encrypt -s 'hello there'
