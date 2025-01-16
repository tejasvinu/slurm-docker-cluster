FROM ubuntu:24.04

RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y \
  && apt-get dist-upgrade -y \
  && apt-get install -y \
  less \
  nano \
  iputils-ping \
  sudo \
  openssh-server \
  python3 \
  munge \
  openssl \
  cmake \
  libhttp-parser-dev \
  libjwt-dev \
  libyaml-dev \
  libjson-c-dev \
  dos2unix \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Create all users/groups needed by SLURM
RUN groupadd -g 995 slurm && \
    useradd -r -u 995 -g slurm slurm && \
    useradd -r -u 996 -g slurm slurmrestd && \
    mkdir -p /etc/slurm/conf.d /etc/slurm/jwt /var/spool/slurmctld /var/log/slurm && \
    chown -R slurm:slurm /etc/slurm/jwt /var/spool/slurmctld /var/log/slurm && \
    chmod 755 /var/spool/slurmctld /var/log/slurm && \
    chmod 700 /etc/slurm/jwt

# Setup munge directories and permissions
RUN mkdir -p /etc/munge /var/run/munge /var/lib/munge \
    && chown -R munge:munge /etc/munge /var/run/munge /var/lib/munge \
    && chmod 0700 /etc/munge /var/run/munge /var/lib/munge

RUN mkdir -p /etc/slurm/dockerhelp
COPY slurm.conf /etc/slurm/
RUN chmod +r /etc/slurm/slurm.conf
COPY cgroup.conf /etc/slurm/

RUN useradd -m admin -s /usr/bin/bash -d /home/admin && \
  echo "admin:admin" | chpasswd && \
  adduser admin sudo && \
  echo "admin     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Make mount point for shared drive/volume where development can happen and automatickly be distributed among nodes
RUN mkdir /home/admin/shared

WORKDIR /home/admin

COPY docker-entrypoint.sh /etc/slurm/dockerhelp/
RUN dos2unix /etc/slurm/dockerhelp/docker-entrypoint.sh && \
    chmod 755 /etc/slurm/dockerhelp/docker-entrypoint.sh

COPY fix_cpu_in_slurmconf.sh /etc/slurm/dockerhelp/
RUN dos2unix /etc/slurm/dockerhelp/fix_cpu_in_slurmconf.sh && \
    chmod 755 /etc/slurm/dockerhelp/fix_cpu_in_slurmconf.sh

# Debug: List contents and verify permissions
RUN ls -la /etc/slurm/dockerhelp/ && \
    cat /etc/slurm/dockerhelp/docker-entrypoint.sh

# Debug: Make absolutely sure script is executable
RUN chmod 755 /etc/slurm/dockerhelp/docker-entrypoint.sh

ENTRYPOINT ["/etc/slurm/dockerhelp/docker-entrypoint.sh"]
