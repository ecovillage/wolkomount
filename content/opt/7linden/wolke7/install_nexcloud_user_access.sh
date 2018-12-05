#!/bin/bash

# Prepare users environment to mount a nextcloud instance via
# davfs2

# Released under the GPLv3, Copyright 2018 Felix Wolfsetller

set -euo pipefail

main() {
  local nextcloud_hostname=nexcloud.mydomain
  local nextcloud_username=username
  local nextcloud_password=password
  local nextcloud_user_mountpoint="$HOME/server-mount-point"
  
  # Prepare directories needed by user davfs2 mount
  mkdir -p ${nextcloud_user_mountpoint} $HOME/.davfs2/certs

  # Configure credentials for davfs/nextcloud
  echo https://${nextcloud_hostname}/remote.php/webdav ${nextcloud_username} ${nextcloud_password} > $HOME/.davfs2/secrets

  # Restrict access to secrets
  chmod 600 ~/.davfs2/secrets

  # Fetch server certificate
  echo | \
      openssl s_client -servername ${nextcloud_hostname} -connect ${nextcloud_hostname}:443 2>/dev/null | \
      openssl x509 -outform pem > $HOME/.davfs2/certs/cloud.pem

  # Register server certificate
  echo trust_server_cert $HOME/.davfs2/certs/cloud.pem > $HOME/.davfs2/davfs2.conf

  # Add user to davfs2 group
  sudo -S usermod -a -G davfs2 $USER

  # Add fstab entry
  echo "https://${nextcloud_hostname}/remote.php/webdav ${nextcloud_user_mountpoint} davs auto,user,_netdev 0 0" | sudo tee -a /etc/fstab
}

main

# Graceful exit
exit 0
