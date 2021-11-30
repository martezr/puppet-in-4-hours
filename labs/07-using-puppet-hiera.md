# Lesson #7: Using Puppet Hiera for Data Separation

## Overview

This lesson walks through using Puppet Hiera for data separation.

## Exercises

[Lab 7.1: Configure Hiera](#exercise-71-configure-hiera)

[Lab 7.2: Add Hiera Data](#exercise-72-bootstrap-puppet-agent)

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

### Lab 7.2: Add Hiera Data

1. Create a data YAML file for the agent node `data/common.yaml`.

```bash
---
ntp::servers:
  - 0.pool.ntp.org
  - 1.pool.ntp.org
```

2. Add the changes to the git repository.

```bash
git add --all
```

3. Commit the changes to the git repository.

```bash
git commit -m 'Update NTP servers'
```

4. Push the changes to the git remote server.

```bash
git push origin
```

5. Deploy the hiera data on the Puppet server.

```bash
r10k deployment environment -m
```

6. Verify that the hiera data file has been added to the Puppet server.

```bash
cat /etc/puppetlabs/puppet/code/environments/production/data/common.yaml
```

7. Trigger a Puppet run on the agent node

```bash
puppet agent -t
```

### Lab 7.3: Installing and Configuring Hiera Eyaml

1. Install Hiera eyaml.

```bash
/opt/puppetlabs/server/bin/puppetserver gem install hiera-eyaml
```

2. Create a directory for the hiera eyaml keys.

```bash
mkdir -p /etc/puppetlabs/puppet/eyaml
```

3. Change the working directory to the newly created directory.

```bash
cd /etc/puppetlabs/puppet/eyaml
```

4. Generate a new key pair for encryption and decryption.

```bash
/opt/puppetlabs/puppet/bin/eyaml createkeys
```

5. Update the file ownership on the generated keys.

```bash
chown -R puppet:puppet /etc/puppetlabs/puppet/eyaml/keys
```

6. Update the file permissions on the keys directory.

```bash
chmod -R 0500 /etc/puppetlabs/puppet/eyaml/keys
```

7. Update the file permissions on the eyaml public and private keys.

```bash
chmod 0400 /etc/puppetlabs/puppet/eyaml/keys/*.pem
```

8. Update the hiera configuration by adding the following configuration to the hiera.yaml file in the control repository.

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
