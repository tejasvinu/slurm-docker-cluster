FROM slurm-base:latest

RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y \
  && apt-get dist-upgrade -y \
  && apt-get install -y \
  slurmctld \
  slurmrestd \
  munge \
  slurm-auth-jwt \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 995 slurm || true && \
    useradd -r -u 995 -g slurm slurm || true && \
    useradd -r -u 996 -g slurm slurmrestd || true && \
    mkdir -p /var/spool/slurmctld /etc/slurm/jwt /var/log/slurm && \
    chown slurm:slurm /var/spool/slurmctld /var/log/slurm /etc/slurm/jwt && \
    chmod 755 /var/spool/slurmctld /var/log/slurm && \
    chmod 700 /etc/slurm/jwt

COPY ./docker-entrypoint.sh /etc/slurm/dockerhelp/
COPY slurm-rest.conf /etc/slurm/dockerhelp/slurm-rest.conf
RUN chmod +rx /etc/slurm/dockerhelp/docker-entrypoint.sh

EXPOSE 6820

ENV SLURMRESTD_HOST=0.0.0.0
ENV SLURMRESTD_PORT=6820
ENV SLURM_JWT=daemon
ENTRYPOINT ["/etc/slurm/dockerhelp/docker-entrypoint.sh"]