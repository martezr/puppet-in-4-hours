# Lesson #7: Using Puppet Hiera for Data Separation

## Overview

This lesson walks through using Puppet Hiera for data separation.

## Exercises

[Lab 7.1: Configure Hiera](#lab-71-configure-hiera)

[Lab 7.2: Add Hiera Data](#lab-72-add-hiera-data)

[Lab 7.3: Installing and Configure Hiera Eyaml](#lab-73-installing-and-configuring-hiera-eyaml)

[Lab 7.4: Encrypting Senstive Data with Hiera Eyaml](#lab-74-encrypting-senstive-data-with-hiera-eyaml)


### Lab 7.1: Configure Hiera

1. Update the hiera.yaml file in the control repository with the following content.

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

1. Create a data YAML file for the agent node `data/common.yaml` in the control repository.

```bash
---
ntp::servers:
  - 2.pool.ntp.org
  - 3.pool.ntp.org
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
sudo /opt/puppetlabs/puppet/bin/r10k deployment environment -m
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
/opt/puppetlabs/puppet/bin/eyaml createkeys --pkcs7-public-key=public_key.pkcs7.pem --pkcs7-private-key=private_key.pkcs7.pem
```

5. Create a directory for the eyaml configuration

```bash
mkdir /etc/eyaml
```

6. Create the eyaml configuration file at /etc/eyaml/config.yaml
```bash
---
pkcs7_private_key: '/etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem'
pkcs7_public_key: '/etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem'
```

7. Update the file ownership on the generated keys.

```bash
chown -R puppet:puppet /etc/puppetlabs/puppet/eyaml/
```

8. Update the file permissions on the keys directory.

```bash
chmod -R 0500 /etc/puppetlabs/puppet/eyaml/
```

9. Update the file permissions on the eyaml public and private keys.

```bash
chmod 0400 /etc/puppetlabs/puppet/eyaml/*.pem
```

10. Update the hiera configuration by adding the following configuration to the hiera.yaml file in the control repository.

```bash
---
version: 5
defaults:
  datadir: data
hierarchy:
  - name: "Secret data: per-node, per-datacenter, common"
    lookup_key: eyaml_lookup_key # eyaml backend
    paths:
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

1. Encrypt the secret data using eyaml on the Puppet server

```bash
/opt/puppetlabs/puppet/bin/eyaml encrypt -s 'super secret eyaml data'
```

2. Add the encrypted data to data/common.eyaml in the control repository

```bash
---
nginx::secretdata: >
  ENC[PKCS7,MIIBiQYJKoZIhvcNAQcDoIIBejCCAXYCAQAxggEhMIIBHQIBAD
  AFMAACAQEwDQYJKoZIhvcNAQEBBQAEggEAFp3a0tgTvqZPF1mUI/xPrfh5AU
  dOPh/AVgzOGcOnkc76N8Rxdn8h4dgVt42dlf99zNDVJcxWe4rsGRepg8UCqz
  kmdzo54rk868hohZEPIA5uOhlURPGoHw+D22wp6zgCSTlIiXqVRTIzZjxGkB
  FPUj33kFRbMIx34NLKarpK58R1oBlhDbQdvffG7820d08HFda0+9G8EL+obq
  qpgmppRgn6olLnVWDq1HpGAcijgZna+EdzvXF5SR+tZXyH81mkloqj7Jtcum
  IdYKFeLaUVTMgFQ4ZJn+hDxQfcW3KVhZEgxdq3+JxuVtUDiWwzR7xoOI9A1s
  ZQTeTucgztE/uHlzBMBgkqhkiG9w0BBwEwHQYJYIZIAWUDBAEqBBB7Jo3W7m
  SMPRVPWKCuFD4KgCDl3T6hathWsHBZfwr00aXOBVDK9rx4r7zJQc/tId+5oQ
  ==]
```

3. Add the changes to the git repository

```bash
git add --all
```

4. Create a new git commit for the changes.

```bash
git commit -m 'Add eyaml data'
```

5. Push the code changes to the git repository.

```bash
git push origin
```

6. Deploy the code changes to the Puppet server

```bash
sudo /opt/puppetlabs/puppet/bin/r10k deployment environment -m
```

7. Trigger a Puppet agent run on the agent node

```bash
puppet agent -t
```

## Review

In this lab, you have:

+ Configured Hiera
+ Installed and configured Hiera eyaml
+ Encrypted sensitive data with Hiera eyaml

[Previous Lab - Lab #6](./06-using-puppet-forge-modules.md)
