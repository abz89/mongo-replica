#!/bin/sh

# VAGRANT_EXPERIMENTAL="disks" vagrant up --no-provision && vagrant provision | tee "setup_log"
VAGRANT_EXPERIMENTAL="disks" vagrant up --no-provision | tee "setup_log"
