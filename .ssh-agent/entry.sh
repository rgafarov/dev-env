#!/bin/bash

# Print a debug message if debug mode is on ($DEBUG is not empty)
# @param message
debug_msg ()
{
  if [ -n "$DEBUG" ]; then
    echo "$@"
  fi
}

case "$1" in
  # Start ssh-agent
  ssh-agent)

  # Create proxy-socket for ssh-agent (to give everyone acceess to the ssh-agent socket)
  echo "Creating a proxy socket..."
  rm ${SSH_AUTH_SOCK} ${SSH_AUTH_PROXY_SOCK} > /dev/null 2>&1
  socat UNIX-LISTEN:${SSH_AUTH_PROXY_SOCK},perm=0666,fork UNIX-CONNECT:${SSH_AUTH_SOCK} &

  echo "Launching ssh-agent..."
  exec /usr/bin/ssh-agent -a ${SSH_AUTH_SOCK} -d
  ;;

  # Manage SSH identities
  ssh-add)
  shift # remove argument from array

  host_ssh_key=$1
  shift # remove argument from array
  # .ssh folder from host is expected to be mounted on /.ssh
  # We copy key from there into dev's home and fix permissions (necessary on Windows hosts)
  host_ssh_path="/.ssh"
  if [ -d $host_ssh_path ]; then
    debug_msg "Copying host SSH key and setting proper permissions..."
    mkdir -p /home/dev/.ssh/
    cp $host_ssh_path/$host_ssh_key /home/dev/.ssh/
    chmod 700 /home/dev/.ssh
    chmod 600 /home/dev/.ssh/*
  fi

  # Make sure the key exists if provided.
  # When $ssh_key_path is empty, ssh-agent will be looking for both id_rsa and id_dsa in the home directory.
  ssh_key_path=""
  if [ -n "$host_ssh_key" ] && [ -f "/home/dev/.ssh/$host_ssh_key" ]; then
    ssh_key_path="/home/dev/.ssh/$host_ssh_key"
  fi

  # Calling ssh-add. This should handle all cases.
  _command="ssh-add $ssh_key_path $@"
  debug_msg "Executing: $_command"

  # When $key_path is empty, ssh-agent will be looking for both id_rsa and id_dsa in the home directory.
  # echo "Press ENTER or CTRL+C to skip entering passphrase (if any)."
  $_command 2>&1 0>&1

  # Return first command exit code
  exit ${PIPESTATUS[0]}
  ;;
	*)
  exec $@
  ;;
esac
