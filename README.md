# Jenkins swarm slave ready for Ruby on Rails

Based of (all the hard work was done here in csanchez repo):
[`csanchez/jenkins-swarm-slave`](https://registry.hub.docker.com/u/csanchez/jenkins-swarm-slave/)

A [Jenkins swarm](https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin) slave.

A basic slave for building Ruby on Rails applications on.

Requires refactoring to reduce size of image and this is using my local repo, need to change to your own repo

## Building

### Building parent images first

From the `buildpack-deps:buster` folder run:

```
docker build -t cust-buildpack-deps:buster .
```

Then from the `ruby:2.7` folder run:

```
docker build -t cust-ruby:2.7 .
```

### Build main image

From root folder run:

```
  docker build -t jenkins-swarm-slave-ror-docker:latest .
```

### Push image to local repo

    docker login -u docker_reg https://registry.sonictexture.co.uk
    docker build -t jenkins-swarm-slave-ror-docker:latest . && \
    docker tag jenkins-swarm-slave-ror-docker:latest registry.sonictexture.co.uk/jenkins-swarm-slave-ror-docker:latest && \
    docker push registry.sonictexture.co.uk/jenkins-swarm-slave-ror-docker:latest

## Running

To run a Docker container passing [any parameters](https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin#SwarmPlugin-AvailableOptions) to the slave

    docker run registry.sonictexture.co.uk/jenkins-swarm-slave-nodejs-yarn-docker:latest -master http://jenkins:8080 -username jenkins -password jenkins -executors 1

Linking to the Jenkins master container there is no need to use `--master`

    docker run -d --name jenkins -p 8080:8080 registry.sonictexture.co.uk/jenkins-swarm-slave-nodejs-yarn-docker:latest
    docker run -d --link jenkins:jenkins registry.sonictexture.co.uk/jenkins-swarm-slave-nodejs-yarn-docker:latest -username jenkins -password jenkins -executors 1

