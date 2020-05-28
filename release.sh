#!/bin/sh
#
#  > release.sh jenkins
#
#  Build and push to registry the jenkins container
#

DOCKER=docker
GCLOUD=gcloud
IMAGE=saml-auth-proxy
BRANCH=$(git rev-parse --abbrev-ref HEAD)
VERSION=$(git describe --tags --always --dirty --match=v* 2> /dev/null || \
			cat $(CURDIR)/.version 2> /dev/null || echo v0)

REPO=gcr.io/citizen-gcr
URL=$REPO/$IMAGE:$VERSION
LATEST=$REPO/$IMAGE:latest

echo "— STATUS ———————————————————————————————————————————————"
echo " IMG    : $IMAGE"
echo " BRANCH : $BRANCH"
echo " VER    : $VERSION"
echo " URL    : $URL"
echo "— BUILDING —————————————————————————————————————————————"

$DOCKER build . -t $URL

echo "— PUSHING ——————————————————————————————————————————————"

$GCLOUD docker -- push $URL
$GCLOUD container images add-tag $URL $LATEST
