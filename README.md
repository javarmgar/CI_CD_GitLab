# gitlab-ci-android-fastlane

This Docker image contains the Android SDK and fastlane.

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
