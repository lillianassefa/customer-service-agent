#!/bin/bash

# Customer Service Agent - User Data Script
# Automation Engineer Profile - Automated server setup
# This script runs on Leaseweb instances during provisioning

set -e

# Log all output for debugging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "🚀 Starting Customer Service Agent server setup..."
echo "Environment: ${environment}"
echo "App Name: ${app_name}"
echo "Instance ID: ${instance_id}"

# Update system packages (security and performance)
echo "📦 Updating system packages..."
apt-get update
apt-get upgrade -y

# Install essential packages (cost-sensitive: only install what's needed)
echo "🔧 Installing essential packages..."
apt-get install -y \
    curl \
    wget \
    git \
    htop \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Install Docker (for containerization)
echo "🐳 Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Install Docker Compose (for multi-container deployments)
echo "🐙 Installing Docker Compose..."
curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install Python 3.8+ (cost-sensitive: use latest stable for better performance)
echo "🐍 Installing Python..."
apt-get install -y python3 python3-pip python3-venv

# Install monitoring tools (cost-sensitive: lightweight monitoring)
echo "📊 Installing monitoring tools..."
apt-get install -y \
    prometheus-node-exporter \
    htop \
    iotop \
    nethogs

# Configure system for performance (latency-optimized)
echo "⚡ Configuring system for performance..."

# Optimize kernel parameters for high-performance applications
cat >> /etc/sysctl.conf << EOF
# Network optimization
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.core.netdev_max_backlog = 5000
net.ipv4.tcp_congestion_control = bbr

# File system optimization
fs.file-max = 2097152
fs.inotify.max_user_watches = 524288

# Memory optimization
vm.swappiness = 10
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5
EOF

# Apply sysctl changes
sysctl -p

# Configure system limits
cat >> /etc/security/limits.conf << EOF
# Increase file descriptor limits
* soft nofile 65536
* hard nofile 65536

# Increase process limits
* soft nproc 32768
* hard nproc 32768
EOF

# Create application user (security best practice)
echo "👤 Creating application user..."
useradd -m -s /bin/bash -G docker appuser
echo "appuser:$(openssl rand -base64 32)" | chpasswd

# Create application directory
mkdir -p /opt/${app_name}
chown appuser:appuser /opt/${app_name}

# Setup application environment
echo "🔧 Setting up application environment..."
cat > /opt/${app_name}/.env << EOF
# Customer Service Agent - Server Configuration
# Automation Engineer Profile - Cost and Latency Optimized

# Environment
ENVIRONMENT=${environment}
INSTANCE_ID=${instance_id}

# API Configuration (latency-sensitive)
API_HOST=0.0.0.0
API_PORT=8000
API_WORKERS=4

# Database Configuration (cost-sensitive)
CHROMA_DB_PATH=/opt/${app_name}/chroma_db
CHROMA_COLLECTION_NAME=company_documents_${environment}

# Model Configuration (performance/cost balance)
EMBEDDING_MODEL=models/embedding-001
LLM_MODEL=gemini-1.0-pro-latest

# Kafka Configuration (event-driven automation)
KAFKA_BOOTSTRAP_SERVERS=localhost:9092
KAFKA_TOPIC=customer_queries
KAFKA_GROUP_ID=customer_service_agent_${instance_id}

# Leaseweb Integration (cloud provider)
LEASEWEB_API_KEY=your-leaseweb-api-key
LEASEWEB_REGION=ams1
LEASEWEB_INSTANCE_TYPE=cx21

# Monitoring and Scaling
LOG_LEVEL=INFO
METRICS_ENABLED=true
AUTO_SCALE_ENABLED=true
COST_ALERT_THRESHOLD=100

# Data Paths
DATA_PATH=/opt/${app_name}/data
PROCESSED_DATA_PATH=/opt/${app_name}/data/processed
EOF

# Create application directories
mkdir -p /opt/${app_name}/{data,logs,config,scripts}
chown -R appuser:appuser /opt/${app_name}

# Setup logging configuration
cat > /opt/${app_name}/config/logging.conf << EOF
[loggers]
keys=root,customer_service,kafka,automation

[handlers]
keys=consoleHandler,fileHandler

[formatters]
keys=normalFormatter

[logger_root]
level=INFO
handlers=consoleHandler

[logger_customer_service]
level=INFO
handlers=consoleHandler,fileHandler
qualname=customer_service
propagate=0

[logger_kafka]
level=INFO
handlers=consoleHandler,fileHandler
qualname=kafka
propagate=0

[logger_automation]
level=INFO
handlers=consoleHandler,fileHandler
qualname=automation
propagate=0

[handler_consoleHandler]
class=StreamHandler
level=INFO
formatter=normalFormatter
args=(sys.stdout,)

[handler_fileHandler]
class=handlers.RotatingFileHandler
level=INFO
formatter=normalFormatter
args=('/opt/${app_name}/logs/customer_service.log', 'a', 10485760, 5)

[formatter_normalFormatter]
format=%(asctime)s - %(name)s - %(levelname)s - %(message)s
datefmt=%Y-%m-%d %H:%M:%S
EOF

# Create health check script
cat > /opt/${app_name}/scripts/health_check.sh << 'EOF'
#!/bin/bash

# Health check script for Customer Service Agent
# Demonstrates automation engineering monitoring practices

set -e

echo "🔍 Performing health check..."

# Check if application is running
if pgrep -f "customer-service-agent" > /dev/null; then
    echo "✅ Application process is running"
else
    echo "❌ Application process not found"
    exit 1
fi

# Check if API is responding
if curl -f http://localhost:8000/health >/dev/null 2>&1; then
    echo "✅ API health check passed"
else
    echo "❌ API health check failed"
    exit 1
fi

# Check disk space
FREE_DISK=$(df -BG /opt | awk 'NR==2{print $4}' | sed 's/G//')
if [ $FREE_DISK -lt 5 ]; then
    echo "⚠️  Low disk space: ${FREE_DISK}GB free"
else
    echo "✅ Disk space OK: ${FREE_DISK}GB free"
fi

# Check memory usage
FREE_MEM=$(free -m | awk 'NR==2{printf "%.0f", $7}')
if [ $FREE_MEM -lt 512 ]; then
    echo "⚠️  Low memory: ${FREE_MEM}MB free"
else
    echo "✅ Memory OK: ${FREE_MEM}MB free"
fi

# Check Docker status
if systemctl is-active --quiet docker; then
    echo "✅ Docker service is running"
else
    echo "❌ Docker service not running"
    exit 1
fi

echo "✅ Health check completed successfully"
EOF

chmod +x /opt/${app_name}/scripts/health_check.sh

# Create monitoring script
cat > /opt/${app_name}/scripts/monitor.sh << 'EOF'
#!/bin/bash

# Monitoring script for Customer Service Agent
# Demonstrates automation engineering monitoring practices

echo "📊 System Monitoring Report"
echo "=========================="

# System information
echo "🖥️  System Info:"
echo "  Hostname: $(hostname)"
echo "  Uptime: $(uptime)"
echo "  Load Average: $(cat /proc/loadavg | awk '{print $1, $2, $3}')"

# Memory usage
echo "🧠 Memory Usage:"
free -h | grep -E "Mem|Swap"

# Disk usage
echo "💾 Disk Usage:"
df -h /opt

# Network connections
echo "🌐 Network Connections:"
ss -tuln | grep -E ":8000|:9092|:22"

# Docker containers
echo "🐳 Docker Containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Application logs (last 10 lines)
echo "📋 Recent Application Logs:"
if [ -f "/opt/customer-service-agent/logs/customer_service.log" ]; then
    tail -10 /opt/customer-service-agent/logs/customer_service.log
else
    echo "  No application logs found"
fi

# Cost monitoring (resource usage)
echo "💰 Cost Monitoring:"
echo "  CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)%"
echo "  Memory Usage: $(free | grep Mem | awk '{printf "%.1f%%", $3/$2 * 100.0}')"
echo "  Disk Usage: $(df /opt | tail -1 | awk '{print $5}')"

echo "=========================="
EOF

chmod +x /opt/${app_name}/scripts/monitor.sh

# Setup systemd service for automatic startup
cat > /etc/systemd/system/${app_name}.service << EOF
[Unit]
Description=Customer Service Agent
After=docker.service
Requires=docker.service

[Service]
Type=simple
User=appuser
WorkingDirectory=/opt/${app_name}
Environment=ENVIRONMENT=${environment}
Environment=INSTANCE_ID=${instance_id}
ExecStart=/opt/${app_name}/scripts/start.sh
ExecReload=/bin/kill -HUP \$MAINPID
Restart=always
RestartSec=10

# Resource limits (cost-sensitive)
LimitNOFILE=65536
LimitNPROC=32768

# Security settings
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ReadWritePaths=/opt/${app_name}

[Install]
WantedBy=multi-user.target
EOF

# Create startup script
cat > /opt/${app_name}/scripts/start.sh << 'EOF'
#!/bin/bash

# Startup script for Customer Service Agent
# Demonstrates automation engineering startup practices

set -e

cd /opt/customer-service-agent

echo "🚀 Starting Customer Service Agent..."

# Load environment variables
if [ -f ".env" ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Check if Docker is running
if ! systemctl is-active --quiet docker; then
    echo "❌ Docker is not running"
    exit 1
fi

# Pull latest application image (cost-sensitive: only if needed)
if [ "$ENVIRONMENT" = "production" ]; then
    echo "📥 Pulling latest application image..."
    docker pull customer-service-agent:${ENVIRONMENT} || echo "⚠️  Could not pull latest image, using local"
fi

# Start application container
echo "🐳 Starting application container..."
docker run -d \
    --name customer-service-agent-${ENVIRONMENT} \
    --restart unless-stopped \
    --memory="2g" \
    --cpus="2.0" \
    --health-cmd="curl -f http://localhost:8000/health || exit 1" \
    --health-interval=30s \
    --health-timeout=10s \
    --health-retries=3 \
    -p 8000:8000 \
    -v /opt/customer-service-agent/data:/app/data \
    -v /opt/customer-service-agent/logs:/app/logs \
    -e ENVIRONMENT=${ENVIRONMENT} \
    -e INSTANCE_ID=${INSTANCE_ID} \
    customer-service-agent:${ENVIRONMENT}

echo "✅ Customer Service Agent started successfully"

# Wait for health check
echo "⏳ Waiting for application to be healthy..."
for i in {1..30}; do
    if docker inspect --format='{{.State.Health.Status}}' customer-service-agent-${ENVIRONMENT} | grep -q "healthy"; then
        echo "✅ Application is healthy"
        break
    elif [ $i -eq 30 ]; then
        echo "❌ Application failed to become healthy"
        docker logs customer-service-agent-${ENVIRONMENT}
        exit 1
    else
        echo "  Waiting for health check... ($i/30)"
        sleep 2
    fi
done

echo "🎉 Customer Service Agent startup completed"
EOF

chmod +x /opt/${app_name}/scripts/start.sh

# Enable and start the service
systemctl daemon-reload
systemctl enable ${app_name}.service
systemctl start ${app_name}.service

# Setup log rotation (cost-sensitive: prevent disk space issues)
cat > /etc/logrotate.d/${app_name} << EOF
/opt/${app_name}/logs/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 644 appuser appuser
    postrotate
        systemctl reload ${app_name}.service
    endscript
}
EOF

# Setup monitoring cron job (cost-sensitive: periodic monitoring)
cat > /etc/cron.d/${app_name}-monitoring << EOF
# Customer Service Agent Monitoring
# Run health check every 5 minutes
*/5 * * * * appuser /opt/${app_name}/scripts/health_check.sh >> /opt/${app_name}/logs/health_check.log 2>&1

# Run system monitoring every hour
0 * * * * appuser /opt/${app_name}/scripts/monitor.sh >> /opt/${app_name}/logs/monitoring.log 2>&1

# Clean up old logs weekly (cost optimization)
0 2 * * 0 root find /opt/${app_name}/logs -name "*.log.*" -mtime +7 -delete
EOF

# Set proper permissions
chown appuser:appuser /opt/${app_name}/scripts/*
chmod +x /opt/${app_name}/scripts/*

# Create initial backup
echo "📦 Creating initial backup..."
mkdir -p /opt/${app_name}/backups
tar -czf /opt/${app_name}/backups/initial_setup_$(date +%Y%m%d_%H%M%S).tar.gz -C /opt/${app_name} . --exclude=backups
chown appuser:appuser /opt/${app_name}/backups/*

# Final setup message
echo ""
echo "🎉 Customer Service Agent server setup completed!"
echo "================================================"
echo ""
echo "📋 Server Information:"
echo "  Environment: ${environment}"
echo "  Instance ID: ${instance_id}"
echo "  Application Path: /opt/${app_name}"
echo "  Service Name: ${app_name}"
echo ""
echo "🔧 Automation Engineer Features:"
echo "✅ Automated server provisioning"
echo "✅ Performance-optimized configuration"
echo "✅ Cost-sensitive resource allocation"
echo "✅ Health monitoring and alerting"
echo "✅ Log rotation and cleanup"
echo "✅ Docker containerization"
echo "✅ Systemd service management"
echo "✅ Leaseweb cloud integration"
echo "✅ Kafka event-driven architecture ready"
echo ""
echo "📊 Monitoring:"
echo "  Health Check: /opt/${app_name}/scripts/health_check.sh"
echo "  System Monitor: /opt/${app_name}/scripts/monitor.sh"
echo "  Service Status: systemctl status ${app_name}"
echo "  Logs: journalctl -u ${app_name} -f"
echo ""
echo "🚀 Application should be running on port 8000"