#!/bin/bash

# Update system's packages ---------------------------------------------------
if [ ! -e /home/vagrant/.base-system-updated ]; then
  echo "Updating the system's package references. This can take a few minutes..."
  
  sudo apt-get -y update
  sudo apt-get -y upgrade
  
  # Make sure the system uses UTF-8
  sudo locale-gen en_US.UTF-8
  sudo update-locale LANG=en_US.UTF-8

  sudo apt-get install -y python-software-properties make curl gettext g++ software-properties-common python-pip

  touch /home/vagrant/.base-system-updated
fi
