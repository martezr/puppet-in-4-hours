# Lesson #4: Installing Puppet Agents

This lesson walks through installing and configuring the Puppet agent on the agent node.

[Exercise 4.1: Install Puppet agent](#exercise-41-install-puppet-agent)

[Exercise 4.2: Bootstrap Puppet agent](#exercise-42-bootstrap-puppet-agent)

[Exercise 4.3: Puppet Certificate Autosigning](#exercise-43-puppet-certificate-autosigning)

[Exercise 4.4: Puppet Trusted Facts](#exercise-44-puppet-trusted-facts)


## Exercise 4.1: Install Puppet agent

Download the Puppet repository package

```bash
wget https://apt.puppet.com/puppet7-release-focal.deb
```

Install the Puppet repository on the system

```bash
sudo dpkg -i puppet7-release-focal.deb
```

Trigger an apt update to enable the Puppet repository

```bash
sudo apt-get update -y
```

Install the Puppet agent on the system

```bash
sudo apt-get install puppet-agent
```

Configure the Puppet server that the agent will talk to

```bash
/opt/puppetlabs/bin/puppet config set server puppet --section main
```

# Exercisee 4.2: Bootstrap Puppet Agent

Trigger the Puppet agent bootstrap process

```bash
puppet ssl bootstrap waitforcert 0
```

List certificate requests (**Execute this command on the Puppet Server node**)

```bash
puppetserver ca list
```

Sign the agent certificate request (**Execute this command on the Puppet Server node**)

```bash
puppetserver ca sign --certname agent.localdomain
```

Trigger the Puppet agent bootstrap process

```bash
puppet ssl bootstrap
```

## Exercise 4.3: Puppet Certificate Autosigning

```bash
#!/bin/bash
# define the shared secret we will accept to authenticate identity
SHARED_SECRET="your the best"

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


## Exercise 4.4: Puppet Trusted Facts



[Next Lesson - Lesson #5: Puppet Code Development](./05-puppet-code-development.md)
