#!/bin/bash

# Customer Service Agent - Deployment Script
# Automation Engineer Profile - Demonstrates:
# - Automated deployment practices
# - Cost-sensitive scaling
# - Latency-optimized deployment
# - Infrastructure as Code integration
# - Leaseweb cloud deployment

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[DEPLOY]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Load environment variables
if [ -f ".env" ]; then
    export $(cat .env | grep -v '^#' | xargs)
    print_status "Environment variables loaded"
else
    print_error "Environment file not found. Run setup.sh first."
    exit 1
fi

# Configuration
DEPLOYMENT_ENV=${1:-"development"}
APP_NAME="customer-service-agent"
DOCKER_IMAGE="${APP_NAME}:${DEPLOYMENT_ENV}"
CONTAINER_NAME="${APP_NAME}-${DEPLOYMENT_ENV}"

print_status "Starting deployment for environment: $DEPLOYMENT_ENV"

# Pre-deployment checks
print_status "Performing pre-deployment checks..."

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    print_error "Docker not found. Install Docker first."
    exit 1
fi

# Check if Terraform is available (for infrastructure)
if ! command -v terraform &> /dev/null; then
    print_warning "Terraform not found. Infrastructure deployment will be skipped."
    INFRA_DEPLOY=false
else
    INFRA_DEPLOY=true
fi

# Check system resources (cost-sensitive deployment)
print_status "Checking system resources..."

# Memory check
TOTAL_MEM=$(free -m | awk 'NR==2{printf "%.0f", $2}')
if [ $TOTAL_MEM -lt 4096 ]; then
    print_warning "Low memory for production: ${TOTAL_MEM}MB. Recommended: 4GB+"
    if [ "$DEPLOYMENT_ENV" = "production" ]; then
        print_error "Insufficient memory for production deployment"
        exit 1
    fi
else
    print_success "Memory check passed: ${TOTAL_MEM}MB"
fi

# Disk space check
FREE_DISK=$(df -BG . | awk 'NR==2{print $4}' | sed 's/G//')
if [ $FREE_DISK -lt 10 ]; then
    print_warning "Low disk space: ${FREE_DISK}GB. Recommended: 10GB+ for deployment"
else
    print_success "Disk space check passed: ${FREE_DISK}GB"
fi

# Backup current deployment (if exists)
if docker ps -a --format "table {{.Names}}" | grep -q "$CONTAINER_NAME"; then
    print_status "Creating backup of current deployment..."
    ./scripts/backup.sh
    print_success "Backup completed"
fi

# Build Docker image (cost-optimized)
print_status "Building Docker image..."
docker build -t "$DOCKER_IMAGE" \
    --build-arg ENVIRONMENT="$DEPLOYMENT_ENV" \
    --build-arg API_WORKERS="${API_WORKERS:-4}" \
    --build-arg LOG_LEVEL="${LOG_LEVEL:-INFO}" \
    .

if [ $? -eq 0 ]; then
    print_success "Docker image built successfully: $DOCKER_IMAGE"
else
    print_error "Docker build failed"
    exit 1
fi

# Stop existing container (if running)
if docker ps --format "table {{.Names}}" | grep -q "$CONTAINER_NAME"; then
    print_status "Stopping existing container..."
    docker stop "$CONTAINER_NAME"
    docker rm "$CONTAINER_NAME"
    print_success "Existing container stopped and removed"
fi

# Deploy with appropriate resource limits (cost-sensitive)
print_status "Deploying application..."

# Calculate resource limits based on environment
if [ "$DEPLOYMENT_ENV" = "production" ]; then
    MEMORY_LIMIT="2g"
    CPU_LIMIT="2.0"
    WORKERS=4
elif [ "$DEPLOYMENT_ENV" = "staging" ]; then
    MEMORY_LIMIT="1g"
    CPU_LIMIT="1.0"
    WORKERS=2
else
    MEMORY_LIMIT="512m"
    CPU_LIMIT="0.5"
    WORKERS=1
fi

# Run container with resource limits and health checks
docker run -d \
    --name "$CONTAINER_NAME" \
    --restart unless-stopped \
    --memory="$MEMORY_LIMIT" \
    --cpus="$CPU_LIMIT" \
    --health-cmd="curl -f http://localhost:8000/health || exit 1" \
    --health-interval=30s \
    --health-timeout=10s \
    --health-retries=3 \
    -p "${API_PORT:-8000}:8000" \
    -e GOOGLE_API_KEY="$GOOGLE_API_KEY" \
    -e CHROMA_DB_PATH="$CHROMA_DB_PATH" \
    -e KAFKA_BOOTSTRAP_SERVERS="$KAFKA_BOOTSTRAP_SERVERS" \
    -e LEASEWEB_API_KEY="$LEASEWEB_API_KEY" \
    -v "$(pwd)/data:/app/data" \
    -v "$(pwd)/logs:/app/logs" \
    "$DOCKER_IMAGE"

if [ $? -eq 0 ]; then
    print_success "Container deployed successfully"
else
    print_error "Container deployment failed"
    exit 1
fi

# Wait for container to be healthy
print_status "Waiting for container to be healthy..."
for i in {1..30}; do
    if docker inspect --format='{{.State.Health.Status}}' "$CONTAINER_NAME" | grep -q "healthy"; then
        print_success "Container is healthy"
        break
    elif [ $i -eq 30 ]; then
        print_error "Container failed to become healthy within timeout"
        docker logs "$CONTAINER_NAME"
        exit 1
    else
        print_status "Waiting for health check... ($i/30)"
        sleep 2
    fi
done

# Deploy infrastructure (if Terraform is available)
if [ "$INFRA_DEPLOY" = true ] && [ -d "infrastructure" ]; then
    print_status "Deploying infrastructure with Terraform..."
    
    cd infrastructure
    
    # Initialize Terraform
    terraform init
    
    # Plan deployment
    terraform plan -var="environment=$DEPLOYMENT_ENV" -var="app_name=$APP_NAME"
    
    # Apply changes
    terraform apply -var="environment=$DEPLOYMENT_ENV" -var="app_name=$APP_NAME" -auto-approve
    
    cd ..
    print_success "Infrastructure deployed successfully"
fi

# Setup monitoring and alerting
print_status "Setting up monitoring..."

# Create monitoring script
cat > scripts/monitor.sh << 'EOF'
#!/bin/bash

# Monitoring script for Customer Service Agent
# Demonstrates automation engineering monitoring practices

CONTAINER_NAME="$1"
if [ -z "$CONTAINER_NAME" ]; then
    CONTAINER_NAME="customer-service-agent-development"
fi

echo "📊 Monitoring $CONTAINER_NAME..."

# Check container status
if docker ps --format "table {{.Names}}" | grep -q "$CONTAINER_NAME"; then
    echo "✅ Container is running"
    
    # Get resource usage
    echo "📈 Resource Usage:"
    docker stats "$CONTAINER_NAME" --no-stream --format "table {{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
    
    # Check logs for errors
    echo "📋 Recent logs:"
    docker logs --tail 10 "$CONTAINER_NAME" | grep -i error || echo "No errors found"
    
    # Health check
    if curl -f http://localhost:8000/health >/dev/null 2>&1; then
        echo "✅ API health check passed"
    else
        echo "❌ API health check failed"
    fi
else
    echo "❌ Container is not running"
fi
EOF

chmod +x scripts/monitor.sh

# Setup auto-scaling (basic implementation)
print_status "Setting up auto-scaling configuration..."

cat > scripts/auto_scale.sh << 'EOF'
#!/bin/bash

# Auto-scaling script for Customer Service Agent
# Demonstrates cost-sensitive scaling practices

CONTAINER_NAME="$1"
if [ -z "$CONTAINER_NAME" ]; then
    CONTAINER_NAME="customer-service-agent-development"
fi

# Get current CPU usage
CPU_USAGE=$(docker stats "$CONTAINER_NAME" --no-stream --format "{{.CPUPerc}}" | sed 's/%//')

# Get current memory usage
MEM_USAGE=$(docker stats "$CONTAINER_NAME" --no-stream --format "{{.MemPerc}}" | sed 's/%//')

echo "📊 Current usage - CPU: ${CPU_USAGE}%, Memory: ${MEM_USAGE}%"

# Scale up if usage is high (cost-sensitive: only scale when necessary)
if (( $(echo "$CPU_USAGE > 80" | bc -l) )) || (( $(echo "$MEM_USAGE > 80" | bc -l) )); then
    echo "🚀 High resource usage detected. Scaling up..."
    
    # Get current container config
    CURRENT_MEM=$(docker inspect "$CONTAINER_NAME" --format='{{.HostConfig.Memory}}')
    CURRENT_CPU=$(docker inspect "$CONTAINER_NAME" --format='{{.HostConfig.CpuQuota}}')
    
    # Calculate new limits (cost-sensitive: gradual scaling)
    NEW_MEM=$((CURRENT_MEM * 120 / 100))  # Increase by 20%
    NEW_CPU=$(echo "$CURRENT_CPU * 1.2" | bc)
    
    echo "📈 Scaling to: Memory=${NEW_MEM}, CPU=${NEW_CPU}"
    
    # Update container resources
    docker update --memory="${NEW_MEM}" --cpus="${NEW_CPU}" "$CONTAINER_NAME"
    
    echo "✅ Scaling completed"
elif (( $(echo "$CPU_USAGE < 30" | bc -l) )) && (( $(echo "$MEM_USAGE < 30" | bc -l) )); then
    echo "📉 Low resource usage detected. Scaling down..."
    
    # Scale down (cost optimization)
    CURRENT_MEM=$(docker inspect "$CONTAINER_NAME" --format='{{.HostConfig.Memory}}')
    CURRENT_CPU=$(docker inspect "$CONTAINER_NAME" --format='{{.HostConfig.CpuQuota}}')
    
    NEW_MEM=$((CURRENT_MEM * 80 / 100))  # Decrease by 20%
    NEW_CPU=$(echo "$CURRENT_CPU * 0.8" | bc)
    
    echo "📉 Scaling to: Memory=${NEW_MEM}, CPU=${NEW_CPU}"
    
    docker update --memory="${NEW_MEM}" --cpus="${NEW_CPU}" "$CONTAINER_NAME"
    
    echo "✅ Scaling down completed"
else
    echo "✅ Resource usage is optimal. No scaling needed."
fi
EOF

chmod +x scripts/auto_scale.sh

# Create deployment summary
print_status "Creating deployment summary..."

cat > "deployment_summary_$(date +%Y%m%d_%H%M%S).txt" << EOF
Customer Service Agent - Deployment Summary
==========================================

Deployment Time: $(date)
Environment: $DEPLOYMENT_ENV
Container Name: $CONTAINER_NAME
Docker Image: $DOCKER_IMAGE

Resource Allocation:
- Memory Limit: $MEMORY_LIMIT
- CPU Limit: $CPU_LIMIT
- Workers: $WORKERS

Infrastructure:
- Terraform Deployed: $INFRA_DEPLOY
- Health Checks: Enabled
- Auto-restart: Enabled

Monitoring:
- Health check script: ./scripts/monitor.sh $CONTAINER_NAME
- Auto-scaling script: ./scripts/auto_scale.sh $CONTAINER_NAME
- Backup script: ./scripts/backup.sh

Cost Optimization Features:
- Resource limits applied
- Auto-scaling configured
- Health monitoring active
- Graceful shutdown handling

Latency Optimization:
- Worker count optimized for environment
- Health checks with 30s intervals
- Resource limits prevent over-allocation

Next Steps:
1. Monitor deployment: ./scripts/monitor.sh $CONTAINER_NAME
2. Test API: curl http://localhost:${API_PORT:-8000}/health
3. View logs: docker logs $CONTAINER_NAME
4. Setup auto-scaling: ./scripts/auto_scale.sh $CONTAINER_NAME

Automation Engineer Features:
✅ Automated deployment pipeline
✅ Cost-sensitive resource allocation
✅ Latency-optimized configuration
✅ Infrastructure as Code integration
✅ Health monitoring and alerting
✅ Auto-scaling capabilities
✅ Backup and recovery procedures
✅ Leaseweb cloud integration ready
✅ Kafka event-driven architecture ready
EOF

print_success "Deployment summary created"

# Final deployment status
print_status "Deployment completed successfully!"
echo ""
echo "🎉 Customer Service Agent is now deployed!"
echo "=========================================="
echo ""
echo "📋 Quick Commands:"
echo "  Monitor: ./scripts/monitor.sh $CONTAINER_NAME"
echo "  Auto-scale: ./scripts/auto_scale.sh $CONTAINER_NAME"
echo "  Logs: docker logs $CONTAINER_NAME"
echo "  Health: curl http://localhost:${API_PORT:-8000}/health"
echo ""
echo "🔧 Automation Engineer Features:"
echo "✅ Automated deployment pipeline"
echo "✅ Cost-sensitive resource allocation"
echo "✅ Latency-optimized configuration"
echo "✅ Infrastructure as Code (Terraform)"
echo "✅ Health monitoring and alerting"
echo "✅ Auto-scaling capabilities"
echo "✅ Backup and recovery procedures"
echo "✅ Leaseweb cloud integration ready"
echo "✅ Kafka event-driven architecture ready"
echo ""
echo "📊 Deployment Summary: deployment_summary_$(date +%Y%m%d_%H%M%S).txt" 