#!/bin/bash
sudo apt update -y && sudo apt upgrade -y
docker rm doom -f
docker run -d -p 8000:8000 --name doom mowqa/doom
