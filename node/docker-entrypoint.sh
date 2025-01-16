#!/bin/bash

echo "[DEBUG] Starting node docker-entrypoint.sh"
echo "[DEBUG] Current directory: $(pwd)"
echo "[DEBUG] Script location: $0"
echo "[DEBUG] Contents of /etc/slurm/dockerhelp:"
ls -la /etc/slurm/dockerhelp/

# Set CPUs etc in slurm.conf
echo "[DEBUG] Running fix_cpu_in_slurmconf.sh"
sudo /etc/slurm/dockerhelp/fix_cpu_in_slurmconf.sh

# Wait for munge key to be available
echo "[DEBUG] Waiting for munge key..."
while [ ! -f ~admin/shared/mungesetup/munge.key ]; do
    sleep 1
done

# Setup munge directories
sudo mkdir -p /var/run/munge /var/lib/munge
sudo chown -R munge:munge /var/run/munge /var/lib/munge
sudo chmod 755 /var/run/munge
sudo chmod 711 /var/lib/munge

# Copy munge key with proper permissions
sudo mkdir -p /etc/munge
sudo cp -a -f ~admin/shared/mungesetup/munge.key /etc/munge/munge.key
sudo chown -R munge:munge /etc/munge
sudo chmod 400 /etc/munge/munge.key

# Start munge with debug output
echo "[DEBUG] Starting munge"
sudo -u munge /usr/sbin/munged -F &
sleep 2

# Verify munge is working
echo "[DEBUG] Testing munge"
munge -n | unmunge || echo "Munge test failed"

sudo service munge start
echo "[DEBUG] Starting services"
sudo service ssh start
sudo service slurmd start

echo "[DEBUG] Launching bash"
/usr/bin/bash
