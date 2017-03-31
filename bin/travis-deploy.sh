#!/usr/bin/env bash

BRANCH_TO_DEPLOY=$1
NODE_VERSION_TO_DEPLOY=$2

if [[ $CI != "true" && $TRAVIS != "true" ]]; then
  echo 'You may not be in travis CI.'
  exit 1
fi

if [[ $BRANCH_TO_DEPLOY == "master" ]]; then
    echo 'Dangerous operation.'
    echo 'Deploying to `master` branch is aborted.'
    exit 1
fi

if [[ "master" != "$TRAVIS_BRANCH" ]]; then
  echo "Not on the 'master' branch."
  exit 0
fi

if [[ $NODE_VERSION_TO_DEPLOY != "$TRAVIS_NODE_VERSION" ]]; then
  echo "Not suitable to deploy. $TRAVIS_NODE_VERSION expected to be $NODE_VERSION_TO_DEPLOY."
  exit 0
fi

if [[ $TRAVIS_PULL_REQUEST != "false" ]]; then
  echo 'Not deploying from Pull Request.'
  exit 0
fi

if [[ $1 != '' ]]; then
  echo "Deploying to $BRANCH_TO_DEPLOY brnch.."

  rm -rf ./.git
  cd ./_book || echo 'something wrong.' && exit 1

  git init
  git config user.name $GIT_USER
  git config user.email $GIT_EMAIL

  git add .
  git commit --quiet -m "Deploy from Travis CI [ci skip]"
  git push --force --quiet "https://${GH_TOKEN}@${GIT_REF}" master:$BRANCH_TO_DEPLOY > /dev/null 2>&1
fi
