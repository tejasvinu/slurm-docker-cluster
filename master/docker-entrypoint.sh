#!/bin/bash
set -ex

# Copy REST config
mkdir -p /etc/slurm/conf.d
cp /etc/slurm/dockerhelp/slurm-rest.conf /etc/slurm/conf.d/

# Setup munge
dd if=/dev/urandom bs=1 count=1024 of=/etc/munge/munge.key
chown -R munge:munge /etc/munge /var/run/munge /var/lib/munge
chmod 400 /etc/munge/munge.key
service munge start

# Setup JWT
dd if=/dev/urandom of=/etc/slurm/jwt/jwt_hs256.key bs=32 count=1
chown slurm:slurm /etc/slurm/jwt/jwt_hs256.key
chmod 600 /etc/slurm/jwt/jwt_hs256.key

# Start services
service slurmctld start
sleep 2

# Start REST daemon
sudo -u slurm /usr/sbin/slurmrestd -vvv ${SLURMRESTD_HOST}:${SLURMRESTD_PORT} &

# Keep container running
exec tail -f /var/log/slurm/slurmctld.log
