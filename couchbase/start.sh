#!/bin/bash

#echo "127.0.0.1		couchbase" | sudo tee -a /etc/hosts

ROOT_PATH=$(dirname "$0")

echo "$(date) Initializing swarm mode"
docker swarm init 2>/dev/null

echo "$(date) Creating overlay network"
docker network create --driver=overlay --attachable local

echo "$(date) Deploying service"
docker stack deploy -c $ROOT_PATH/docker-compose.yml couchbase

printf  "$(date) Checking servive"
while true; do curl -f -u Administrator:password http://127.0.0.1:8091/pools 2>/dev/null; if [ $? -eq 0 ]; then echo -e "\n$(date) Service is READY!"; break; fi; printf  "."; sleep 1; done

echo "$(date) Setting master username & password"
curl -v http://127.0.0.1:8091/settings/web -d port=8091 -d username=Administrator -d password=password 2>/dev/null

echo -e "\n$(date) Setting index and memory quota"
curl -v POST http://127.0.0.1:8091/pools/default -d memoryQuota=300 -d indexMemoryQuota=300 2>/dev/null

echo "$(date) Setting services"
curl -v http://127.0.0.1:8091/node/controller/setupServices -d services=kv%2Cn1ql%2Cindex 2>/dev/null

echo "$(date) Setting credentials"
curl -v http://127.0.0.1:8091/settings/web -d port=8091 -d username=Administrator -d password=password 2>/dev/null

echo "$(date) Setting memory optimized indexes"
curl -i -u Administrator:password POST http://127.0.0.1:8091/settings/indexes -d 'storageMode=memory_optimized' 2>/dev/null

echo -e "\n$(date) Loading buckets"
curl -v -u Administrator:password POST http://127.0.0.1:8091/pools/default/buckets -d name=AEOrders -d authType=sasl -d saslPassword=123qwe -d bucketType=couchbase -d flushEnabled=1 -d ramQuotaMB=100 2>/dev/null
curl -v -u Administrator:password POST http://127.0.0.1:8091/pools/default/buckets -d name=AEProducts -d authType=sasl -d saslPassword=123qwe -d bucketType=couchbase -d flushEnabled=1 -d ramQuotaMB=100 2>/dev/null

echo "$(date) Editing buckets"
curl -v -X PUT -H "Content-Type: application/json" http://Administrator:password@127.0.0.1:8092/AEOrders/_design/design -d '{"views" : { "by_orderId" : { "map" : "function (doc, meta) { emit(doc.orderId,doc);}" } } }' 2>/dev/null
curl -v -X PUT -H "Content-Type: application/json" http://Administrator:password@127.0.0.1:8092/AEProducts/_design/design -d '{"views" : { "by_barcode" : { "map" : "function (doc, meta) { emit(doc.barcode,doc);}" } } }' 2>/dev/null

echo "$(date) Creating new admin"
curl -X PUT --data "name=Admin&roles=admin&password=password" -H "Content-Type: application/x-www-form-urlencoded" http://Administrator:password@127.0.0.1:8091/settings/rbac/users/local/admin 2>/dev/null
echo -e "\n$(date) CouchBase is READY!"