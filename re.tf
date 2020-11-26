provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIA26XNDNUBLPUQXRTC"
  secret_key = "DZ+etH3sB7vOoTM4bTyIpzBAlj51qGpe8zCRicvC"
}


resource "aws_elasticache_replication_group" "example1" {
  automatic_failover_enabled    = true
  availability_zones            = ["ap-south-1a", "ap-south-1b","ap-south-1c"]
  replication_group_id          = "tf-rep-group-1"
  replication_group_description = "test description"
  engine			= "redis"
  node_type                     = "cache.t2.small"
  number_cache_clusters         = 3
  parameter_group_name          = "default.redis6.x"
  port                          = 6379
  
  provisioner "local-exec" {
    environment = {
      REPLICATION_GROUP_ID = aws_elasticache_replication_group.example1.replication_group_id
    }
    command = <<-EOT
      aws elasticache modify-replication-group \
        --replication-group-id $REPLICATION_GROUP_ID \
        --multi-az-enabled \
        --apply-immediately
    EOT
  }

}

