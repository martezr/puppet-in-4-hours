# Lab #4: Installing Puppet Agents

## Overview

This lab walks through installing and configuring the Puppet agent on the agent node.

## Exercises

[Lab 4.1: Install Puppet agent](#lab-41-install-puppet-agent)

[Lab 4.2: Bootstrap Puppet agent](#lab-42-bootstrap-puppet-agent)

[Lab 4.3: Puppet Certificate Autosigning](#lab-43-puppet-certificate-autosigning)

### Lab 4.1: Install Puppet agent

1. Download the Puppet repository package.

```bash
wget https://apt.puppet.com/puppet7-release-focal.deb
```

2. Install the Puppet repository on the system.

```bash
sudo dpkg -i puppet7-release-focal.deb
```

3. Trigger an apt update to enable the Puppet repository.

```bash
sudo apt-get update -y
```

4. Install the Puppet agent on the system.

```bash
sudo apt-get install puppet-agent
```

5. Configure the Puppet server that the agent will connect to.

```bash
/opt/puppetlabs/bin/puppet config set server puppet --section main
```

### Lab 4.2: Bootstrap Puppet Agent

1. Trigger the Puppet agent bootstrap process.

```bash
puppet ssl bootstrap waitforcert 0
```

2. List certificate requests (**Execute this command on the Puppet Server node**).

```bash
puppetserver ca list
```

3. Sign the agent certificate request (**Execute this command on the Puppet Server node**).

```bash
puppetserver ca sign --certname agent.localdomain
```

4. Trigger the Puppet agent bootstrap process.

```bash
puppet ssl bootstrap
```

### Lab 4.3: Puppet Certificate Autosigning

1. Create an autosigning script on the Puppet server node at /etc/puppetlabs/puppet/autosigning.sh.

```bash
#!/bin/bash
# define the shared secret we will accept to authenticate identity
SHARED_SECRET="mySuperAwesomePassword"

# capture the certname (hostname) used for the request
CERT_NAME=$1

# feed STDIN (file descriptor 0) to the openssl command and pipe
# the output to grep to get the sharedSecret supplied by the agent
# capturing the value in a variable called AGENT_SECRET
AGENT_SECRET=$(openssl req -noout -text <&0 | awk -F ":" '/challengePassword/ { gsub(/\n$/, "", $2) ; print $2 }')

if [ "$AGENT_SECRET" == "$SHARED_SECRET" ] ; then
    STATUS=0
    echo "authorised agent: ${CERT_NAME}"
else
    STATUS=1
    echo "***!ALERT!*** incorrect or missing shared secret from ${CERT_NAME}"
fi
exit $STATUS
```

2. Create a CSR Attributes YAML file with the challenge password and trusted facts.

```bash
cat > /etc/puppetlabs/puppet/csr_attributes.yaml << YAML
custom_attributes:
    challengePassword: mySuperAwesomePassword
extension_requests:
    pp_role: web
    pp_hostname: agent
YAML
```

3. Trigger an agent bootstrap.

```bash
sudo /opt/puppetlabs/bin/puppet ssl bootstrap waitforcert 0
```

## Review

In this lab, you have:

+ Installed and configured a Puppet agent
+ Bootstrapped a Puppet agent
+ Configured Puppet policy based certificate autosigning

[Previous Lab - Lab #3](./03-configuring-puppet-server.md)  |  [Next Lab - Lab #5](./05-puppet-code-development.md)
