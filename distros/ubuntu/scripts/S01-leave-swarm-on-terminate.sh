#!/bin/bash

DOCKER=/usr/bin/docker
ID=$($DOCKER node inspect self -f '{{.ID}}')
$DOCKER node demote $ID
$DOCKER swarm leave
