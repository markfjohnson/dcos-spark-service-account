#!/usr/bin/env bash
dcos spark run --submit-args='--driver-cores 1 --driver-memory 1024M https://raw.githubusercontent.com/markfjohnson/dcos-spark-service-account/master/python-examples/simple-python.py'

