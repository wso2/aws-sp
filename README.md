# AWS Resources for WSO2 Stream Processor

This repository contains a CloudFormation template to deploy WSO2 Stream Processor in Amazon Web Services(AWS).

The WSO2 SP CloudFormation template uses Puppet to manage the server configurations and use the following AMI's to provision the deployment.

1. Puppetmaster AMI - Contains the Stream Processor GA distribution, WSO2 Update Manager and Puppet modules containing the configurations for SP deployment patterns.

2. SP AMI - Includes the product specific resources to create the Puppet catalog.

First the Puppetmaster AMI would deploy and afterwards the product specific AMI's would deploy and request the necessary configurations from the Puppetmaster AMI to deploy the WSO2 Stream Processor.

![pattern1](/images/scalable-worker.png)
