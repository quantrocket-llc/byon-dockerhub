FROM python:3.6

ENV DOCKER_MACHINE_RELEASE=v0.14.0 DOCKER_COMPOSE_VERSION=1.22.0

# Install Docker
RUN apt-get update \
   && apt-get install -y \
   apt-transport-https \
   ca-certificates \
   curl \
   gnupg2 \
   software-properties-common \
  && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
  && add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable" \
  && apt-get update \
  && apt-get install -y docker-ce

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
  && chmod +x /usr/local/bin/docker-compose

# Install Docker Machine
RUN curl -L https://github.com/docker/machine/releases/download/${DOCKER_MACHINE_RELEASE}/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine \
  && install /tmp/docker-machine /usr/local/bin/docker-machine

WORKDIR /opt/byon-dockerhub

COPY test* /opt/byon-dockerhub/

ONBUILD CMD ["python", "/opt/byon-dockerhub/testrunner.py"]
