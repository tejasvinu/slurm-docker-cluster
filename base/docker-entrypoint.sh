#!/bin/bash

echo "[DEBUG] Starting base docker-entrypoint.sh"
echo "[DEBUG] Current directory: $(pwd)"
echo "[DEBUG] Script location: $0"
echo "[DEBUG] Contents of /etc/slurm/dockerhelp:"
ls -la /etc/slurm/dockerhelp/

# Set CPUs etc in slurm.conf
echo "[DEBUG] Running fix_cpu_in_slurmconf.sh"
sudo /etc/slurm/dockerhelp/fix_cpu_in_slurmconf.sh

echo "[DEBUG] Starting SSH service"
sudo service ssh start

echo "[DEBUG] Launching bash"
/usr/bin/bash
