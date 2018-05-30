#!/usr/bin/env bash
# Simple example to show that a non-Spark python program works with the spark framework
# spark.mesos.executor.docker.volumes
dcos spark run --submit-args='--driver-cores 1 --driver-memory 1024M https://raw.githubusercontent.com/markfjohnson/dcos-spark-service-account/master/python-examples/simple-python.py'


