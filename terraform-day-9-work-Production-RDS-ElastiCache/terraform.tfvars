aws_region   = "us-east-1"
project_name = "myapp"
environment  = "production"

vpc_cidr = "10.0.0.0/16"
private_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

db_name                    = "appdb"
db_username                = "adminuser"
db_instance_class          = "db.t3.micro"
db_replica_instance_class  = "db.t3.micro"
db_allocated_storage_gb    = 20
db_max_allocated_storage_gb = 500
db_password = "Root1234"

redis_node_type               = "cache.t4g.micro"
redis_replicas_per_node_group = 1



