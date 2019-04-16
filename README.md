-elasticsearch
-elastichq
-couchbase
-consul
-kibana
-logstash
-rabbitmq
-portainer
-mssql
-mountebank
-mongo
-redis

docker network create --driver=overlay --attachable olgac

curl localhost:9200/_cat/health
curl localhost:9200/_cat/nodes?v
curl localhost:9200/_cluster/health?pretty
curl localhost:9200/_nodes/process?pretty