#!/bin/bash

# Update package lists and install required packages
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Update package lists again to include the Jenkins repository
sudo apt-get update

# Install Java Development Kit (OpenJDK 11)
sudo apt-get install -y openjdk-11-jdk

# Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins

# Print the initial Jenkins unlock key
echo "The Jenkins initial unlock key is:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
