FROM --platform=linux/arm64 ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential procps curl file git zsh sudo ca-certificates \
    libssl-dev libyaml-dev zlib1g-dev libreadline-dev libffi-dev locales \
    && locale-gen en_US.UTF-8

RUN userdel -r ubuntu && useradd -m -u 1000 -s /bin/zsh greg \
    && echo 'greg ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/greg

USER greg
WORKDIR /home/greg

RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && sudo ln -s /home/linuxbrew/.linuxbrew /opt/homebrew

COPY --chmod=755 e2e/shims/ /usr/local/macos-shims/

ENV PATH=/usr/local/macos-shims:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV OSTYPE=darwin24.0
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
ENV HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_ENV_HINTS=1
ENV HOMEBREW_BUNDLE_CASK_SKIP="beamer font-sauce-code-pro-nerd-font gcloud-cli google-chrome inkscape kaleidoscope ngrok postman sip-app vlc vscodium"
ENV HOMEBREW_BUNDLE_BREW_SKIP="ical-buddy keith/formulae/reminders-cli"
ENV GIT_AUTHOR_NAME="E2E Tester" GIT_AUTHOR_EMAIL="e2e@example.com"
