#!/usr/bin/env bash

cd "$(dirname "$0")"

cp -av ../health-check/static/* static/
cp -av ../health-check/bin/* static/usr/local/bin/
cp -av ../systemd-jupyterlab/bin/* static/usr/local/bin/
cp -av ../prometheus/bin/* static/usr/local/bin/

tar -czvf scripts.tgz -C static/ .
