resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "name" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "name2" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
}

# Unified Security Group for both RDS and Redis
resource "aws_security_group" "name" {
  name        = "example-db-sg"
  description = "Security group for RDS and Redis instances"
  vpc_id      = aws_vpc.name.id

  # Ingress rule for MySQL (RDS)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # CRITICAL FIX: Ingress rule for Redis (ElastiCache Serverless)
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For security, restrict this to your application CIDR later
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "name" {
  name       = "rds-db-subnet-group"
  subnet_ids = [aws_subnet.name.id, aws_subnet.name2.id]
}

resource "aws_db_instance" "name" {
  identifier = "ali-db-instance"

  engine         = "mysql"
  engine_version = "8.0"
  
  instance_class = "db.t4g.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_subnet_group_name = aws_db_subnet_group.name.name

  username                    = "admin"
  password                    = "password123"

  vpc_security_group_ids = [aws_security_group.name.id]

  publicly_accessible = false

  backup_retention_period = 7

  maintenance_window = "Mon:00:00-Mon:03:00"

  skip_final_snapshot = true
}

resource "aws_db_instance" "replica" {
  identifier          = "ali-db-replica"
  replicate_source_db = aws_db_instance.name.identifier
  instance_class      = "db.t4g.micro"
  publicly_accessible = false
  skip_final_snapshot = true
  depends_on          = [aws_db_instance.name]
}

# --- SERVERLESS REDIS CLUSTER INTEGRATION ---

resource "aws_elasticache_serverless_cache" "redis_serverless" {
  name                 = "my-serverless-redis-cluster"
  engine               = "redis"
  major_engine_version = "7"

  # Bind Redis to the subnets created above
  subnet_ids = [
    aws_subnet.name.id, 
    aws_subnet.name2.id
  ]

  # Bind Redis to the fixed security group
  security_group_ids = [
    aws_security_group.name.id
  ]
  depends_on = [aws_db_instance.name]
}
