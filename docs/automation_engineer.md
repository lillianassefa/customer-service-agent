# Customer Service Agent - Automation Engineer Profile

## Project Overview

This Customer Service Agent project has been transformed into a comprehensive automation engineering portfolio that demonstrates:

- **AI customer support system** with intelligent question answering
- **Terraform infrastructure automation** for cloud deployment
- **Docker deployment automation** with containerization
- **Kafka event automation** for event-driven architecture
- **Leaseweb cloud automation** with cloud-native deployment
- **Monitoring automation** with health checks and auto-scaling

## 🚀 How to Run the Project

### Prerequisites

1. **Python 3.8+** installed
2. **Docker** installed (for containerized deployment)
3. **Terraform** installed (for infrastructure deployment)
4. **Google Generative AI API Key** (for AI functionality)

### Quick Start (Local Development)

1. **Clone and setup:**
   ```bash
   git clone <repository-url>
   cd customer-service-agent
   chmod +x scripts/setup.sh
   ./scripts/setup.sh
   ```

2. **Configure environment:**
   ```bash
   # Edit .env file with your API keys
   nano .env
   ```

3. **Run the application:**
   ```bash
   # Activate virtual environment
   source venv/bin/activate
   
   # Start the API server
   uvicorn main:app --host 0.0.0.0 --port 8000 --reload
   ```

4. **Test the API:**
   ```bash
   # Health check
   curl http://localhost:8000/health
   
   # Ask a question
   curl -X POST "http://localhost:8000/ask" \
        -H "Content-Type: application/json" \
        -d '{"question": "Do you have Intel Xeon processors?"}'
   ```

### Docker Deployment

1. **Build and run with Docker:**
   ```bash
   # Build image
   docker build -t customer-service-agent:development .
   
   # Run container
   docker run -d \
     --name customer-service-agent-dev \
     -p 8000:8000 \
     -e GOOGLE_API_KEY=your-api-key \
     customer-service-agent:development
   ```

2. **Use deployment script:**
   ```bash
   chmod +x scripts/deploy.sh
   ./scripts/deploy.sh development
   ```

### Infrastructure Deployment (Leaseweb)

1. **Configure Terraform:**
   ```bash
   cd infrastructure
   
   # Create terraform.tfvars
   cat > terraform.tfvars << EOF
   leaseweb_api_key = "your-leaseweb-api-key"
   environment = "development"
   app_name = "customer-service-agent"
   EOF
   ```

2. **Deploy infrastructure:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Access the application:**
   ```bash
   # Get load balancer IP
   terraform output load_balancer_ip
   
   # Test the API
   curl http://<load-balancer-ip>/health
   ```

## 🔧 Automation Features

### 1. Bash Scripts (`scripts/`)

- **`setup.sh`** - Automated environment setup with cost and performance optimization
- **`deploy.sh`** - Automated deployment with Docker and resource limits
- **`health_check.sh`** - Health monitoring and validation
- **`backup.sh`** - Automated backup and recovery
- **`monitor.sh`** - System monitoring and resource tracking
- **`auto_scale.sh`** - Cost-sensitive auto-scaling

### 2. Terraform Infrastructure (`infrastructure/`)

- **`main.tf`** - Complete infrastructure as code
- **`templates/user_data.sh`** - Automated server provisioning
- **Leaseweb integration** - Cloud-native deployment
- **Auto-scaling** - Cost and performance optimization
- **Security groups** - Network security automation
- **Load balancers** - High availability setup

### 3. Kafka Integration (`src/kafka_producer.py`)

- **Event-driven architecture** - Query and response events
- **Error handling** - Automated error reporting
- **Metrics collection** - Performance monitoring
- **Cost optimization** - Efficient message handling

### 4. Docker Containerization

- **`Dockerfile`** - Optimized container build
- **Health checks** - Automated health monitoring
- **Resource limits** - Cost-sensitive resource allocation
- **Security** - Non-root user execution

## 📊 Monitoring and Scaling

### Health Checks
```bash
# Manual health check
./scripts/health_check.sh

# Automated monitoring
./scripts/monitor.sh customer-service-agent-development
```

### Auto-scaling
```bash
# Check current resource usage
./scripts/auto_scale.sh customer-service-agent-development

# Monitor scaling events
docker logs customer-service-agent-development
```

### Cost Monitoring
- Resource usage tracking
- Cost alert thresholds
- Performance optimization
- Automated cleanup

## 🌐 API Endpoints

### Health Check
```bash
GET /health
```

### Ask Question
```bash
POST /ask
Content-Type: application/json

{
  "question": "Do you have Intel Xeon E5-2670 V3 processors?"
}
```

### Swagger Documentation
```
http://localhost:8000/docs
```

## 🔒 Security Features

- **Non-root container execution**
- **Environment variable management**
- **Network security groups**
- **SSL/TLS termination** (production)
- **API key protection**

## 💰 Cost Optimization

### Resource Allocation
- **Development**: 512MB RAM, 0.5 CPU
- **Staging**: 1GB RAM, 1.0 CPU  
- **Production**: 2GB RAM, 2.0 CPU

### Auto-scaling Policies
- **Scale up**: CPU > 80% or Memory > 80%
- **Scale down**: CPU < 30% and Memory < 30%
- **Cooldown periods**: Prevent rapid scaling

### Cost Monitoring
- Resource usage alerts
- Automated cleanup
- Performance optimization
- Efficient caching

## 🚀 Performance Optimization

### Latency Optimization
- **SSD storage** for I/O performance
- **Connection pooling** for database
- **Caching strategies** for responses
- **Load balancer** health checks

### Throughput Optimization
- **Worker processes** configuration
- **Batch processing** for Kafka
- **Compression** for network efficiency
- **Resource limits** to prevent over-allocation

## 📈 Scaling Strategies

### Horizontal Scaling
- **Load balancer** distribution
- **Auto-scaling groups**
- **Stateless application design**
- **Database connection pooling**

### Vertical Scaling
- **Resource limit adjustments**
- **Performance monitoring**
- **Cost-benefit analysis**
- **Gradual scaling policies**

## 🔄 Backup and Recovery

### Automated Backups
```bash
# Manual backup
./scripts/backup.sh

# Automated backup (cron)
0 2 * * * /path/to/scripts/backup.sh
```

### Recovery Procedures
- **Data restoration** from backups
- **Service restart** automation
- **Health validation** post-recovery
- **Rollback procedures**

## 📋 Troubleshooting

### Common Issues

1. **API not responding:**
   ```bash
   # Check container status
   docker ps
   
   # Check logs
   docker logs customer-service-agent-development
   
   # Health check
   ./scripts/health_check.sh
   ```

2. **High resource usage:**
   ```bash
   # Monitor resources
   ./scripts/monitor.sh
   
   # Auto-scale
   ./scripts/auto_scale.sh
   ```

3. **Infrastructure issues:**
   ```bash
   # Check Terraform state
   cd infrastructure
   terraform plan
   terraform refresh
   ```

### Log Locations
- **Application logs**: `logs/customer_service.log`
- **Health check logs**: `logs/health_check.log`
- **Monitoring logs**: `logs/monitoring.log`
- **Docker logs**: `docker logs <container-name>`

## 🎯 Automation Engineer Portfolio Features

This project demonstrates:

✅ **Infrastructure as Code** - Complete Terraform setup
✅ **Container Orchestration** - Docker with health checks
✅ **Event-Driven Architecture** - Kafka integration
✅ **Cloud Native Deployment** - Leaseweb integration
✅ **Automated Monitoring** - Health checks and alerting
✅ **Cost Optimization** - Resource limits and auto-scaling
✅ **Security Automation** - Non-root execution and security groups
✅ **Backup Automation** - Automated backup and recovery
✅ **Performance Optimization** - Latency and throughput tuning
✅ **CI/CD Ready** - Deployment automation scripts

## 📚 Additional Resources

- **Terraform Documentation**: https://www.terraform.io/docs
- **Docker Documentation**: https://docs.docker.com/
- **Kafka Documentation**: https://kafka.apache.org/documentation/
- **Leaseweb API**: https://developers.leaseweb.com/
- **FastAPI Documentation**: https://fastapi.tiangolo.com/

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add automation improvements
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details. 