# Data Inside Server
## Creating a remote Docker Image for a release
To make it easy to revert to a previous release, docker images are made and stored remotely for every release:

- make sure the branch "production" is up to date.
- reopen locally

```bash
cd .devcontainer
docker build --build-arg GITHUBTOKEN -t <username/repository name>:tag .
docker push <username/repository name>:tag
```

If the image already exists, it can be renamed and then pushed:
```bash
docker tag <image name> <username/repository name>:tag
docker push <username/repository name>:tag
```

## Creating a local Docker Image for a release
Sometimes it is more convenient to have a docker image in a local file:

- make sure the branch "production" is up to date.
- reopen locally

```bash
cd .devcontainer
docker build --build-arg GITHUBTOKEN -t <image name> .
docker save -o <filename> <imagename>
```

## Starting the Image on a Linux machine
Create a docker environment file with only one value: CHAMBER_KEY=&lt;private chamber key&gt; and call it .chamber_env.pem

```bash
 docker run --name datainsideserver --restart on-failure --env-file .chamber_env.pem -p 8080:8080 robertcram/axon-software:dip4 bash -c "RACK_ENV=prodcution rackup -o0.0.0.0 -p8080"
 ```

