# gitlab-ci-android-fastlane

This is a custom version: Due to the fact that newer gradle versions need to run with JDK 11+ it is necessary 
to settle the container image with this JDK version as default.

This Docker image contains the Android SDK and fastlane and JDK 11.

`.gitlab-ci.yml` example:

```
image: javarmgar/gitlab-ci-android-fastlane

stages:
- build
- deploy

cache:
  key: ${CI_PROJECT_ID}
  paths:
  - .gradle/

before_script:
  - chmod +x ./gradlew

build_job:
  stage: build
  script:
  - ./gradlew assembleDebug
  artifacts:
    paths:
    - app/build/outputs

deploy_internal:
  stage: deploy
  when: manual
  script:
  - fastlane android staging
```
