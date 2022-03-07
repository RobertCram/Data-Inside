
# Use intermediate stage to hide secret tokens from Docker history.
FROM mrnonz/alpine-git-curl as builder 

ARG BRANCH=production

ARG GITHUBTOKEN

# Invalidates the cache when the branch is changed
RUN curl -o version.json https://${GITHUBTOKEN}:x-oauth-basic@api.github.com/repos/RobertCram/Data-Inside/git/refs/heads/${BRANCH}

# Clones latest version of the production branch
RUN mkdir /workspaces && cd /workspaces && git clone --branch ${BRANCH} https://RobertCram:${GITHUBTOKEN}@github.com/RobertCram/Data-Inside.git DataInside

FROM ruby:2.6.6

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# This Dockerfile adds a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support for the non-root user
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN apt-get install -y freetds-dev 

RUN gem install solargraph ruby-debug-ide

RUN gem install bundler:2.2.10

RUN mkdir /workspaces

COPY --from=builder /workspaces /workspaces

WORKDIR /workspaces/DataInside

RUN bundle install

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

