#!/bin/bash
# set -euf -o pipefail

which ansible-galaxy \
    && ansible-galaxy install -r requirements.yml -p roles
vagrant up --no-provision \
    && vagrant provision