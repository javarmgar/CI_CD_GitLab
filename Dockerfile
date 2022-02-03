FROM ubuntu:latest
LABEL maintainer="Javier Armenta <javarmgar@gmail.com>"

ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:11 $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"

ENV DEBIAN_FRONTEND noninteractive
ENV HOME "/root"

RUN apt-get --quiet update  --yes
RUN apt-get --quiet install --yes curl 
RUN apt-get --quiet install --yes apt-utils

#node
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash - \
    && apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

#tools
RUN apt-get --quiet install --yes wget \
    tar \
    unzip \
    lib32stdc++6 \
    lib32z1 \
    build-essential \
    patch \
    ruby-dev \
    zlib1g-dev \
    liblzma-dev 

#android
ENV ANDROID_COMPILE_SDK "30"
ENV ANDROID_BUILD_TOOLS "30.0.2"
ENV ANDROID_SDK_TOOLS "7302050"

ENV ANDROID_SDK_ROOT=/android-sdk-linux
ENV ANDROID_HOME=/android-sdk-linux

RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip -O android-commandline-tools.zip \
    && mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && unzip -q android-commandline-tools.zip -d /tmp/ \
    && mv /tmp/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && rm android-commandline-tools.zip

ENV PATH ${PATH}:${ANDROID_SDK_ROOT}:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin

RUN yes | sdkmanager --update
RUN yes | sdkmanager --licenses

RUN yes | sdkmanager "patcher;v4" 
RUN yes | sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" 
RUN yes | sdkmanager "emulator" 
RUN yes | sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" 
RUN yes | sdkmanager "tools" 
RUN yes | sdkmanager "platform-tools"

# fastlane
RUN apt-get --quiet install --yes rubygems
## nokogiri, rake, rubocop (Failed to build gem native extension while installing fastlane fix)
RUN gem install nokogiri
RUN gem install rake
RUN gem install rubocop
RUN gem install bundler
RUN gem install fastlane --version 2.183.2 --no-document

ENV GRADLE_USER_HOME=$PWD/.gradle

# RUN curl -o- -L https://yarnpkg.com/install.sh | bash
# RUN $HOME/.yarn/bin/yarn install

RUN npm install -g yarn
RUN yarn global add firebase-tools

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
