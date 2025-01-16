#!/bin/bash

# Set CPUs etc in slurm.conf - the same for all docker containers.
sed -i "s/REPLACE_IT/CPUs=$(nproc) CoresPerSocket=$(lscpu | grep 'Core(s) per socket:' | cut -d ' ' -f 4- | tr -d ' ') ThreadsPerCore=$(lscpu | grep 'Thread(s) per core:'  | cut -d ' ' -f 4- | tr -d ' ')/g" /etc/slurm/slurm.conf

# Ensure proper permissions on slurm directories
sudo chown -R slurm:slurm /var/log/slurm /var/spool/slurmctld
sudo chmod 755 /var/log/slurm /var/spool/slurmctld

# Remove or comment out the lines that modify /etc/slurm/jwt on the node
# sudo chown -R slurm:slurm /etc/slurm/jwt
# sudo chmod 700 /etc/slurm/jwt
