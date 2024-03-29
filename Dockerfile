FROM ruby:3.0.2

RUN apt-get update && apt-get install -y wget \
 git \
 apt-transport-https ca-certificates \
 curl \
 openjdk-11-jdk \
 gnupg-agent \
 software-properties-common \
 docker-compose docker

# # Install docker compose
# RUN curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# RUN chmod +x /usr/local/bin/docker-compose

# # Install Docker
# RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
# RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
# RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

#Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt install -y nodejs yarn

# Install Rails
RUN gem install rails -v 6.1.4

# Install Jenkins slave in swarm mode
ENV JENKINS_SWARM_VERSION 3.26
ENV HOME /home/jenkins-slave

# # install netstat to allow connection health check with
# # netstat -tan | grep ESTABLISHED
RUN apt-get update && apt-get install -y net-tools && rm -rf /var/lib/apt/lists/*

RUN useradd -c "Jenkins Slave user" -d $HOME -m jenkins-slave
RUN usermod -a -G docker jenkins-slave
RUN curl --create-dirs -sSLo /usr/share/jenkins/swarm-client-$JENKINS_SWARM_VERSION.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION.jar && chmod 755 /usr/share/jenkins

COPY jenkins-slave.sh /usr/local/bin/jenkins-slave.sh

USER jenkins-slave
VOLUME /home/jenkins-slave

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/jenkins-slave.sh"]
