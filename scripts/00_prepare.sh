#!/bin/bash
set -euxo pipefail

# Update package lists
sudo apt-get update

# Install necessary dependencies
sudo apt-get install -y build-essential apt-transport-https ca-certificates curl software-properties-common
