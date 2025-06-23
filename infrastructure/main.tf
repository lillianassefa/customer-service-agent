# Customer Service Agent - Infrastructure as Code
# Automation Engineer Profile - Demonstrates:
# - Infrastructure as Code with Terraform
# - Leaseweb cloud provider integration
# - Cost-sensitive resource allocation
# - Latency-optimized infrastructure
# - Auto-scaling and high availability

terraform {
  required_version = ">= 1.0"
  required_providers {
    leaseweb = {
      source  = "leaseweb/leaseweb"
      version = "~> 1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# Variables for cost and environment management
variable "environment" {
  description = "Deployment environment (development, staging, production)"
  type        = string
  default     = "development"
  
  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be one of: development, staging, production."
  }
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "customer-service-agent"
}

variable "leaseweb_api_key" {
  description = "Leaseweb API key for cloud resources"
  type        = string
  sensitive   = true
}

variable "leaseweb_region" {
  description = "Leaseweb region for deployment"
  type        = string
  default     = "ams1"  # Amsterdam 1 - good latency for EU
}

# Cost-sensitive instance sizing based on environment
locals {
  # Instance sizing based on environment and cost optimization
  instance_configs = {
    development = {
      instance_type = "cx21"      # 2 vCPU, 4GB RAM - cost-effective for dev
      disk_size     = 50          # GB
      instances     = 1
      auto_scale    = false
    }
    staging = {
      instance_type = "cx31"      # 2 vCPU, 8GB RAM - balanced for staging
      disk_size     = 100         # GB
      instances     = 2
      auto_scale    = true
    }
    production = {
      instance_type = "cx41"      # 4 vCPU, 16GB RAM - performance for prod
      disk_size     = 200         # GB
      instances     = 3
      auto_scale    = true
    }
  }
  
  config = local.instance_configs[var.environment]
  
  # Cost optimization tags
  cost_center = "automation-engineering"
  project     = "customer-service-agent"
  
  # Latency optimization - use regions close to target users
  latency_optimized_regions = {
    "eu-west" = "ams1"    # Amsterdam for EU users
    "us-east" = "nyc1"    # New York for US East
    "us-west" = "sfo1"    # San Francisco for US West
  }
}

# Leaseweb Provider Configuration
provider "leaseweb" {
  api_key = var.leaseweb_api_key
  region  = var.leaseweb_region
}

# Network Configuration (latency-optimized)
resource "leaseweb_network" "main" {
  name        = "${var.app_name}-${var.environment}-network"
  description = "Network for Customer Service Agent - ${var.environment}"
  
  # Cost-sensitive: Use private networking to reduce bandwidth costs
  private_network = true
  
  tags = {
    Environment  = var.environment
    Project      = local.project
    CostCenter   = local.cost_center
    ManagedBy    = "terraform"
  }
}

# Security Group (cost and security optimized)
resource "leaseweb_security_group" "app" {
  name        = "${var.app_name}-${var.environment}-sg"
  description = "Security group for Customer Service Agent"
  
  # Minimal required rules for cost and security
  rules {
    protocol   = "tcp"
    port_range = "22"
    source     = "0.0.0.0/0"
    description = "SSH access"
  }
  
  rules {
    protocol   = "tcp"
    port_range = "80"
    source     = "0.0.0.0/0"
    description = "HTTP access"
  }
  
  rules {
    protocol   = "tcp"
    port_range = "443"
    source     = "0.0.0.0/0"
    description = "HTTPS access"
  }
  
  rules {
    protocol   = "tcp"
    port_range = "8000"
    source     = "0.0.0.0/0"
    description = "API access"
  }
  
  # Kafka ports for event-driven architecture
  rules {
    protocol   = "tcp"
    port_range = "9092"
    source     = leaseweb_network.main.cidr
    description = "Kafka access (internal only)"
  }
  
  tags = {
    Environment = var.environment
    Project     = local.project
    CostCenter  = local.cost_center
  }
}

# Load Balancer (latency and cost optimized)
resource "leaseweb_load_balancer" "app" {
  name        = "${var.app_name}-${var.environment}-lb"
  description = "Load balancer for Customer Service Agent"
  
  # Latency-sensitive: Use least connections algorithm
  algorithm = "least_connections"
  
  # Health check configuration
  health_check {
    protocol = "http"
    port     = 8000
    path     = "/health"
    interval = 30
    timeout  = 10
    retries  = 3
  }
  
  # Cost-sensitive: Only enable SSL termination in production
  ssl_termination = var.environment == "production" ? true : false
  
  tags = {
    Environment = var.environment
    Project     = local.project
    CostCenter  = local.cost_center
  }
}

# Application Servers (cost and performance optimized)
resource "leaseweb_server" "app" {
  count = local.config.instances
  
  name        = "${var.app_name}-${var.environment}-${count.index + 1}"
  description = "Customer Service Agent server ${count.index + 1}"
  
  # Cost-sensitive instance sizing
  instance_type = local.config.instance_type
  disk_size     = local.config.disk_size
  
  # Latency-optimized: Use SSD for better I/O performance
  disk_type = "ssd"
  
  # Network configuration
  network_id = leaseweb_network.main.id
  
  # Security groups
  security_group_ids = [leaseweb_security_group.app.id]
  
  # User data for automated setup (cost-sensitive: minimize manual work)
  user_data = base64encode(templatefile("${path.module}/templates/user_data.sh", {
    environment = var.environment
    app_name    = var.app_name
    instance_id = count.index + 1
  }))
  
  # Auto-scaling configuration
  dynamic "auto_scaling" {
    for_each = local.config.auto_scale ? [1] : []
    content {
      min_instances = 1
      max_instances = var.environment == "production" ? 10 : 3
      
      # Cost-sensitive scaling policies
      scale_up_policy {
        cpu_threshold    = 70
        memory_threshold = 80
        cooldown         = 300
      }
      
      scale_down_policy {
        cpu_threshold    = 30
        memory_threshold = 40
        cooldown         = 600
      }
    }
  }
  
  tags = {
    Environment = var.environment
    Project     = local.project
    CostCenter  = local.cost_center
    Instance    = count.index + 1
    ManagedBy   = "terraform"
  }
}

# Database (cost and performance optimized)
resource "leaseweb_database" "app" {
  name        = "${var.app_name}-${var.environment}-db"
  description = "Database for Customer Service Agent"
  
  # Cost-sensitive: Use appropriate database size
  instance_type = var.environment == "production" ? "db-cx21" : "db-cx11"
  
  # Latency-optimized: Use SSD storage
  storage_type = "ssd"
  storage_size = var.environment == "production" ? 100 : 50
  
  # Network configuration for low latency
  network_id = leaseweb_network.main.id
  
  # Security groups
  security_group_ids = [leaseweb_security_group.app.id]
  
  # Backup configuration (cost-sensitive: only in production)
  backup_enabled = var.environment == "production"
  backup_retention = var.environment == "production" ? 7 : 1
  
  tags = {
    Environment = var.environment
    Project     = local.project
    CostCenter  = local.cost_center
  }
}

# Kafka Cluster (event-driven architecture)
resource "leaseweb_kafka_cluster" "app" {
  name        = "${var.app_name}-${var.environment}-kafka"
  description = "Kafka cluster for event-driven Customer Service Agent"
  
  # Cost-sensitive: Only deploy Kafka in staging/production
  count = var.environment != "development" ? 1 : 0
  
  # Instance sizing based on environment
  instance_type = var.environment == "production" ? "cx31" : "cx21"
  instances     = var.environment == "production" ? 3 : 2
  
  # Network configuration
  network_id = leaseweb_network.main.id
  
  # Security groups
  security_group_ids = [leaseweb_security_group.app.id]
  
  # Storage configuration
  storage_size = var.environment == "production" ? 200 : 100
  storage_type = "ssd"
  
  tags = {
    Environment = var.environment
    Project     = local.project
    CostCenter  = local.cost_center
  }
}

# Load Balancer Backend Configuration
resource "leaseweb_load_balancer_backend" "app" {
  count = local.config.instances
  
  load_balancer_id = leaseweb_load_balancer.app.id
  server_id        = leaseweb_server.app[count.index].id
  port             = 8000
  
  # Health check configuration
  health_check {
    protocol = "http"
    path     = "/health"
    interval = 30
    timeout  = 10
    retries  = 3
  }
  
  # Cost-sensitive: Enable session persistence only in production
  session_persistence = var.environment == "production" ? true : false
}

# Monitoring and Alerting (cost-sensitive)
resource "leaseweb_monitoring" "app" {
  name        = "${var.app_name}-${var.environment}-monitoring"
  description = "Monitoring for Customer Service Agent"
  
  # Cost-sensitive: Only enable comprehensive monitoring in production
  enabled = var.environment == "production"
  
  # Alert thresholds (cost and performance optimized)
  alerts {
    cpu_usage {
      threshold = 80
      duration  = 300
    }
    
    memory_usage {
      threshold = 85
      duration  = 300
    }
    
    disk_usage {
      threshold = 90
      duration  = 300
    }
    
    # Latency monitoring
    response_time {
      threshold = 2000  # 2 seconds
      duration  = 300
    }
  }
  
  tags = {
    Environment = var.environment
    Project     = local.project
    CostCenter  = local.cost_center
  }
}

# Outputs for automation and monitoring
output "load_balancer_ip" {
  description = "Load balancer public IP"
  value       = leaseweb_load_balancer.app.public_ip
}

output "server_ips" {
  description = "Application server IPs"
  value       = leaseweb_server.app[*].public_ip
}

output "database_endpoint" {
  description = "Database connection endpoint"
  value       = leaseweb_database.app.endpoint
  sensitive   = true
}

output "kafka_endpoints" {
  description = "Kafka cluster endpoints"
  value       = var.environment != "development" ? leaseweb_kafka_cluster.app[0].endpoints : []
  sensitive   = true
}

output "cost_estimate" {
  description = "Estimated monthly cost"
  value = {
    environment = var.environment
    servers     = local.config.instances
    instance_type = local.config.instance_type
    estimated_cost_usd = var.environment == "production" ? "~$200-400" : 
                        var.environment == "staging" ? "~$100-200" : "~$50-100"
  }
}

# Cost optimization recommendations
output "cost_optimization_tips" {
  description = "Cost optimization recommendations"
  value = [
    "Use auto-scaling to scale down during low traffic",
    "Monitor resource usage and adjust instance sizes",
    "Use spot instances for non-critical workloads",
    "Implement proper tagging for cost allocation",
    "Regularly review and clean up unused resources"
  ]
}

# Latency optimization recommendations
output "latency_optimization_tips" {
  description = "Latency optimization recommendations"
  value = [
    "Use CDN for static content delivery",
    "Implement caching strategies",
    "Use connection pooling for database connections",
    "Monitor and optimize database queries",
    "Use load balancer health checks for failover"
  ]
} 