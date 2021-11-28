# Lesson #7: Using Puppet Hiera for Data Separation

## Overview

This lesson walks through using Puppet Hiera for data separation.

## Exercises

[Lab 7.1: Configure Hiera](#exercise-71-configure-hiera)

[Lab 7.2: Bootstrap Puppet agent](#exercise-72-bootstrap-puppet-agent)

[Lab 7.3: Installing and Configure Hiera Eyaml](#exercise-73-installing-and-configuring-hiera-eyaml)

[Lab 7.4: Encrypting Senstive Data with Hiera Eyaml](#exercise-74-encrypting-senstive-data-with-hiera-eyaml)


### Lab 7.1: Configure Hiera


```bash
---
version: 5
defaults:
  datadir: data
hierarchy:
  - name: "Normal data"
    data_hash: yaml_data # Standard yaml backend
    paths:
      - "nodes/%{trusted.certname}.yaml"
      - "roles/%{trusted.extensions.pp_role}.yaml"
      - "os/%{facts.os.family}.yaml"
      - "common.yaml"
```


### Lab 7.3: Installing and Configuring Hiera Eyaml

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

```bash
---
version: 5
defaults:
  datadir: data
hierarchy:
  - name: "Secret data: per-node, per-datacenter, common"
    lookup_key: eyaml_lookup_key # eyaml backend
    paths:
      - "secrets/nodes/%{trusted.certname}.eyaml"  # Include explicit file extension
      - "common.eyaml"
    options:
      pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
      pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem
  - name: "Normal data"
    data_hash: yaml_data # Standard yaml backend
    paths:
      - "nodes/%{trusted.certname}.yaml"
      - "roles/%{trusted.extensions.pp_role}.yaml"
      - "os/%{facts.os.family}.yaml"
      - "common.yaml"
```

### Lab 7.4: Encrypting Senstive Data with Hiera Eyaml

/opt/puppetlabs/puppet/bin/eyaml encrypt -s 'hello there'


## Review

In this lab, you have:

+ Configured Hiera
+ Installed and configured Hiera eyaml
+ Encrypted sensitive data with Hiera eyaml

[Previous Lab - Lab #6](./06-using-puppet-forge-modules.md)
