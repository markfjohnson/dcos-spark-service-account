#!/usr/bin/env bash
dcos package install --yes dcos-enterprise-cli
dcos package install --yes spark

# define the service accounts
# This example assumes that the cluster is in 'permissive' mode.
#
#### Dept-a service account creation
dcos security org service-accounts keypair spark-a-secret.pem spark-a-secret-pub.pem
dcos security org service-accounts create -p spark-a-secret-pub.pem -d "Spark service account for Dept-a" spark-a
dcos security secrets create-sa-secret spark-a-secret.pem spark-a dept-a/spark-a-secret
dcos package install --yes spark --options=spark-a.json

#
#### Dept-b service account creation
dcos security org service-accounts keypair spark-b-secret.pem spark-b-secret-pub.pem
dcos security org service-accounts create -p spark-b-secret-pub.pem -d "Spark service account for Dept-b" spark-b
dcos security secrets create-sa-secret spark-b-secret.pem spark-a dept-b/spark-b-secret
dcos package install --yes spark --options=spark-b

dcos security org service-accounts show spark-a
dcos security org service-accounts show spark-b
dcos security secrets list /


# define the users, groups and their permissions
echo "Setup security rules"
dcos security org groups create dept-a
dcos security org groups create dept-b
dcos security org users create -p password meatloaf
dcos security org users create -p password jsmith
dcos security org users create -p password jdoe
dcos security org groups add_user dept-a jsmith
dcos security org groups add_user dept-b jdoe
dcos security org groups grant dept-a dcos:adminrouter:service:marathon full
dcos security org groups grant dept-a dcos:service:marathon:marathon:services:/dept-a full
dcos security org groups grant dept-a dcos:adminrouter:ops:slave full
dcos security org groups grant dept-a dcos:mesos:master:framework:role:slave_public read
dcos security org groups grant dept-a dcos:mesos:master:executor:app_id:/dept-a full
dcos security org groups grant dept-a dcos:mesos:master:task:app_id:/dept-a full
dcos security org groups grant dept-a dcos:mesos:agent:framework:role:slave_public read
dcos security org groups grant dept-a dcos:mesos:agent:executor:app_id:/dept-a read
dcos security org groups grant dept-a dcos:mesos:agent:task:app_id:/dept-a read
dcos security org groups grant dept-a dcos:mesos:agent:sandbox:app_id:/dept-a read

dcos security org groups grant dept-b dcos:adminrouter:service:marathon full
dcos security org groups grant dept-b dcos:service:marathon:marathon:services:/dept-b full
dcos security org groups grant dept-b dcos:adminrouter:package full

# Cover the Spark service account permissions
dcos security org users grant spark-a dcos:mesos:master:task:user:nobody
dcos security org users grant spark-a dcos:mesos:master:framework:role:*
dcos security org users grant spark-a dcos:mesos:master:task:app_id:/spark-a
dcos security org users grant spark-a dcos:mesos:master:framework:role:*/users/spark-a/create
dcos security org users grant spark-a dcos:mesos:master:task:app_id:/spark-a/users/spark-a/create
dcos security org users grant spark-a dcos:mesos:master:task:user:nobody/users/spark-a/create

# Cover the Spark service account permissions
dcos security org users grant spark-b dcos:mesos:master:task:user:nobody
dcos security org users grant spark-b dcos:mesos:master:framework:role:*
dcos security org users grant spark-b dcos:mesos:master:task:app_id:/spark-b
dcos security org users grant spark-b dcos:mesos:master:framework:role:*/users/spark-b/create
dcos security org users grant spark-b dcos:mesos:master:task:app_id:/spark-b/users/spark-b/create
dcos security org users grant spark-b dcos:mesos:master:task:user:nobody/users/spark-b/create