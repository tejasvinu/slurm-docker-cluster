#!/bin/bash
set -ex

# Create /run/munge with correct permissions
mkdir -p /run/munge
chown munge:munge /run/munge
chmod 0711 /run/munge

# Setup directories and permissions as root
mkdir -p /etc/slurm/conf.d /var/spool/slurmctld /var/log/slurm /etc/slurm/jwt
chown -R slurm:slurm /var/spool/slurmctld /var/log/slurm /etc/slurm/jwt
chmod 755 /var/spool/slurmctld /var/log/slurm
chmod 700 /etc/slurm/jwt

# Copy REST config
cp /etc/slurm/dockerhelp/slurm-rest.conf /etc/slurm/conf.d/

# Setup munge with proper permissions
mkdir -p /var/run/munge /var/lib/munge /etc/munge
dd if=/dev/urandom bs=1 count=1024 of=/etc/munge/munge.key
chown -R munge:munge /etc/munge /var/run/munge /var/lib/munge
chmod 400 /etc/munge/munge.key
service munge start

# Setup JWT key with correct permissions
dd if=/dev/urandom of=/etc/slurm/jwt/jwt_hs256.key bs=32 count=1
chown slurm:slurm /etc/slurm/jwt/jwt_hs256.key
chmod 600 /etc/slurm/jwt/jwt_hs256.key

# Fix CPU configuration
/etc/slurm/dockerhelp/fix_cpu_in_slurmconf.sh

# Start slurmctld as slurm user
su slurm -c "slurmctld -D -vv" &
sleep 5

# Start REST daemon as slurm user
su slurm -c "/usr/sbin/slurmrestd -vv 0.0.0.0:6820" &

# Keep container running and monitor logs
tail -f /var/log/slurm/slurmctld.log
