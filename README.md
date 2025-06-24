# AI Customer Service Agent - Enterprise Automation Portfolio

[![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-green.svg)](https://fastapi.tiangolo.com/)
[![Docker](https://img.shields.io/badge/Docker-20.10+-blue.svg)](https://www.docker.com/)
[![Terraform](https://img.shields.io/badge/Terraform-1.0+-purple.svg)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/Ansible-2.9+-red.svg)](https://www.ansible.com/)
[![Kafka](https://img.shields.io/badge/Kafka-3.0+-orange.svg)](https://kafka.apache.org/)
[![Leaseweb](https://img.shields.io/badge/Leaseweb-Cloud-orange.svg)](https://www.leaseweb.com/)

## 🎯 Project Overview

This **AI Customer Service Agent** demonstrates enterprise-level automation engineering practices through a fully functional customer support system. The project showcases **infrastructure automation, container orchestration, event-driven architecture, cloud deployment, and monitoring automation** while providing intelligent AI-powered customer assistance.

### 🚀 **5-Word Summary**
**AI customer support** with **enterprise automation engineering portfolio**.

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Client Apps   │    │   Load Balancer │    │   Auto Scaling  │
│                 │───▶│   (Leaseweb)    │───▶│   Group         │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Ansible       │    │   Customer      │◀───│   Application   │
│   Automation    │───▶│   Service Agent │    │   Containers    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Kafka Events  │◀───│   Terraform     │    │   ChromaDB      │
│   (Monitoring)  │    │   Infrastructure│    │   (Vector DB)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Monitoring    │    │   Google AI     │    │   Configuration │
│   & Alerting    │    │   (LLM/Embed)   │    │   Management    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```
### 🧪 **Want to Test the Customer Service Agent?**

If you want to **try out the AI customer service agent** and see how it answers questions about products, services, and company information, please go to:

**👉 [Testing & Running - Complete Guide](#-testing--running---complete-guide)**

There you'll find:
- **Quick 5-minute test** to get started immediately
- **Detailed testing scenarios** for different deployment methods
- **Example conversations** showing how the AI responds
- **Step-by-step instructions** for using the service
- **Troubleshooting guide** if you encounter any issues

### 🎯 **For End Users**
If you want to **use the customer service agent** (ask questions, get product information, etc.), please go to:

**👉 [How to Use the Customer Service Agent](#-how-to-use-the-customer-service-agent)**

There you'll find:
- **Web interface instructions** (easiest way to test)
- **API usage examples** with curl, Python, JavaScript
- **Example conversations** and what you can ask about
- **Integration examples** for web and mobile apps
## 🔧 Automation Engineering Features

### ✅ **Configuration Management (Ansible)**
- **Multi-environment deployment** (development, staging, production)
- **Zero-downtime rolling updates** with automatic rollback
- **Infrastructure as Code** with comprehensive playbooks
- **Automated monitoring and alerting** setup
- **Cost-sensitive resource allocation** and optimization
- **Security hardening** and compliance automation
- **Performance tuning** and system optimization

### ✅ **Infrastructure as Code (Terraform)**
- Complete cloud infrastructure automation with Leaseweb integration
- Cost-sensitive resource allocation and auto-scaling
- Security groups and load balancer automation
- Multi-environment deployment (dev/staging/prod)

### ✅ **Container Orchestration (Docker)**
- Optimized container builds with health checks
- Resource limits and cost optimization
- Non-root execution for security
- Automated deployment pipelines

### ✅ **Event-Driven Architecture (Kafka)**
- Real-time event processing for customer queries
- Automated error handling and monitoring
- Performance metrics collection
- Cost-efficient message handling

### ✅ **Cloud Native Deployment (Leaseweb)**
- Automated server provisioning
- Load balancing and high availability
- Auto-scaling based on demand
- Cost optimization strategies

### ✅ **Monitoring & Observability**
- Automated health checks and alerting
- Resource usage monitoring
- Performance optimization
- Cost tracking and optimization


## 🚀 Quick Start Guide

### Prerequisites

- **Python 3.8+**
- **Docker** (for containerized deployment)
- **Terraform** (for infrastructure deployment)
- **Ansible** (for configuration management)
- **Google Generative AI API Key**

### Option 1: Local Development (Recommended for Testing)

```bash
# 1. Clone and setup
git clone <repository-url>
cd customer-service-agent
chmod +x scripts/setup.sh
./scripts/setup.sh

# 2. Configure environment
nano .env  # Add your GOOGLE_API_KEY

# 3. Run the application
source venv/bin/activate
uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# 4. Test the API
curl http://localhost:8000/health
curl -X POST "http://localhost:8000/ask" \
     -H "Content-Type: application/json" \
     -d '{"question": "Do you have Intel Xeon processors?"}'
```

### Option 2: Docker Deployment

```bash
# Build and run with Docker
docker build -t customer-service-agent:development .
docker run -d \
  --name customer-service-agent-dev \
  -p 8000:8000 \
  -e GOOGLE_API_KEY=your-api-key \
  customer-service-agent:development

# Or use the automated deployment script
./scripts/deploy.sh development
```

### Option 3: Ansible Deployment (Recommended for Production)

```bash
# 1. Configure Ansible inventory
nano ansible/inventory/hosts.yml  # Update server IPs and credentials

# 2. Set environment variables
export GOOGLE_API_KEY_DEV="your-dev-api-key"
export GOOGLE_API_KEY_STAGING="your-staging-api-key"
export GOOGLE_API_KEY_PROD="your-prod-api-key"

# 3. Deploy using Ansible
./scripts/ansible-deploy.sh deploy -e development
./scripts/ansible-deploy.sh deploy -e staging
./scripts/ansible-deploy.sh deploy -e production

# 4. Perform rolling update
./scripts/ansible-deploy.sh update -e production -v v1.2.0

# 5. Setup monitoring
./scripts/ansible-deploy.sh monitor -e production
```

### Option 4: Full Infrastructure (Leaseweb Cloud)

```bash
# Configure Terraform
cd infrastructure
cat > terraform.tfvars << EOF
leaseweb_api_key = "your-leaseweb-api-key"
environment = "development"
app_name = "customer-service-agent"
EOF

# Deploy infrastructure
terraform init
terraform plan
terraform apply

# Access the application
terraform output load_balancer_ip
curl http://<load-balancer-ip>/health
```

## 📁 Project Structure

```
customer-service-agent/
├── 📁 ansible/                     # Configuration Management
│   ├── 📁 inventory/               # Server inventory
│   │   └── hosts.yml               # Multi-environment hosts
│   ├── 📁 playbooks/               # Ansible playbooks
│   │   ├── main.yml                # Main deployment playbook
│   │   ├── rolling-update.yml      # Zero-downtime updates
│   │   ├── monitoring.yml          # Monitoring setup
│   │   └── health-check.yml        # Health validation
│   ├── 📁 templates/               # Configuration templates
│   └── ansible.cfg                 # Ansible configuration
├── 📁 scripts/                     # Automation Scripts
│   ├── setup.sh                    # Environment setup automation
│   ├── deploy.sh                   # Deployment automation
│   ├── ansible-deploy.sh           # Ansible deployment script
│   ├── health_check.sh             # Health monitoring
│   ├── backup.sh                   # Backup automation
│   ├── monitor.sh                  # System monitoring
│   └── auto_scale.sh               # Auto-scaling automation
├── 📁 infrastructure/              # Infrastructure as Code
│   ├── main.tf                     # Terraform configuration
│   └── templates/
│       └── user_data.sh            # Server provisioning
├── 📁 src/                         # Application Source
│   ├── kafka_producer.py           # Event-driven automation
│   ├── config.py                   # Configuration management
│   ├── search.py                   # Search functionality
│   └── ...                         # Other modules
├── 📁 docs/                        # Documentation
│   └── automation_engineer.md      # Complete automation guide
├── Dockerfile                      # Container automation
├── requirements.txt                # Dependencies
├── main.py                         # FastAPI application
└── README.md                       # This file
```

## 🔧 Automation Scripts

### `scripts/ansible-deploy.sh` - Ansible Deployment Automation
```bash
# Comprehensive Ansible deployment with multiple environments
./scripts/ansible-deploy.sh deploy -e production -v v1.2.0
./scripts/ansible-deploy.sh update -e staging -v v1.3.0
./scripts/ansible-deploy.sh monitor -e all
```
**Features:**
- ✅ Multi-environment deployment (dev/staging/prod)
- ✅ Zero-downtime rolling updates
- ✅ Automatic rollback on failure
- ✅ Health checks and validation
- ✅ Cost optimization and resource limits
- ✅ Monitoring and alerting setup
- ✅ Backup and recovery automation
- ✅ Performance tuning and optimization

### `scripts/setup.sh` - Environment Setup Automation
```bash
# Automated environment setup with cost and performance optimization
./scripts/setup.sh
```
**Features:**
- ✅ System requirement validation
- ✅ Virtual environment creation
- ✅ Dependency installation
- ✅ Configuration setup
- ✅ Health check script creation
- ✅ Backup automation setup
- ✅ Performance optimization

### `scripts/deploy.sh` - Deployment Automation
```bash
# Automated deployment with Docker and resource limits
./scripts/deploy.sh [environment]
```
**Features:**
- ✅ Pre-deployment checks
- ✅ Docker image building
- ✅ Resource limit configuration
- ✅ Health monitoring
- ✅ Auto-scaling setup
- ✅ Infrastructure deployment (Terraform)

### `scripts/health_check.sh` - Health Monitoring
```bash
# Automated health monitoring and validation
./scripts/health_check.sh
```
**Features:**
- ✅ Application status check
- ✅ API health validation
- ✅ Resource usage monitoring
- ✅ Docker service validation

### `scripts/auto_scale.sh` - Auto-scaling Automation
```bash
# Cost-sensitive auto-scaling based on resource usage
./scripts/auto_scale.sh [container-name]
```
**Features:**
- ✅ CPU and memory monitoring
- ✅ Automatic scaling up/down
- ✅ Cost optimization
- ✅ Performance tuning

## 🌐 API Endpoints

### Health Check
```bash
GET /health
Response: {"status": "healthy", "timestamp": "2024-01-01T00:00:00Z"}
```

### Ask Question
```bash
POST /ask
Content-Type: application/json

{
  "question": "Do you have Intel Xeon E5-2670 V3 processors?"
}

Response: {
  "answer": "Yes, we have the Intel Xeon E5-2670 V3. Description: High-performance server processor..."
}
```

### Interactive Documentation
```
http://localhost:8000/docs  # Swagger UI
http://localhost:8000/redoc # ReDoc
```

## 🌐 **How to Use the Customer Service Agent**

### 🎯 **For End Users (Customers)**

Once the system is running, here's how you can interact with the Customer Service Agent:

#### **Option 1: Web Interface (Easiest)**

1. **Open your web browser**
2. **Go to:** `http://localhost:8000/docs` (or your server's IP address)
3. **Click on the `/ask` endpoint**
4. **Click "Try it out"**
5. **Type your question** in the JSON format:
   ```json
   {
     "question": "Do you have Intel Xeon processors?"
   }
   ```
6. **Click "Execute"** to get your answer!

#### **Option 2: Direct API Calls**

**Using curl:**
```bash
# Ask about products
curl -X POST "http://localhost:8000/ask" \
     -H "Content-Type: application/json" \
     -d '{"question": "Do you have Intel Xeon E5-2670 V3 processors?"}'

# Ask about services
curl -X POST "http://localhost:8000/ask" \
     -H "Content-Type: application/json" \
     -d '{"question": "What warranty do you offer?"}'

# Ask about pricing
curl -X POST "http://localhost:8000/ask" \
     -H "Content-Type: application/json" \
     -d '{"question": "What is the price of Intel processors?"}'
```

**Using Python:**
```python
import requests

# Ask a question
response = requests.post(
    "http://localhost:8000/ask",
    json={"question": "Do you have Intel processors?"}
)

# Get the answer
answer = response.json()["answer"]
print(answer)
```

**Using JavaScript:**
```javascript
// Ask a question
fetch('http://localhost:8000/ask', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
    },
    body: JSON.stringify({
        question: 'Do you have Intel processors?'
    })
})
.then(response => response.json())
.then(data => console.log(data.answer));
```

### 💬 **Example Conversations**

#### **Product Inquiries:**
```
You: "Do you have Intel Xeon processors?"
Agent: "Yes, we have Intel Xeon processors available. The Intel Xeon E5-2670 V3 is a high-performance server processor with 12 cores and 24 threads. Price: $2,042.69. Available at: Main Warehouse. Contact: John Doe (john.doe@company.com)."

You: "What is the price of Intel Xeon E5-2670 V3?"
Agent: "The Intel Xeon E5-2670 V3 is priced at $2,042.69. It's currently in stock with 77 units available at our Main Warehouse location."

You: "Do you have any AMD processors?"
Agent: "Let me check our inventory for AMD processors..."
```

#### **Service Inquiries:**
```
You: "What warranty do you offer?"
Agent: "Based on our company policies, we offer a standard 1-year warranty on all hardware products, with extended warranty options available for enterprise customers."

You: "What services do you provide?"
Agent: "We provide computer hardware sales, technical support, consulting services, and custom system builds. Our team of certified technicians can assist with installation, configuration, and ongoing maintenance."

You: "How can I contact customer support?"
Agent: "You can reach our customer support team at support@company.com or call us at 1-800-TECH-SUPPORT. Our support hours are Monday-Friday 9 AM to 6 PM EST."
```

#### **General Inquiries:**
```
You: "What are your business hours?"
Agent: "Our business hours are Monday through Friday, 9:00 AM to 6:00 PM EST. We're closed on weekends and major holidays."

You: "Do you ship internationally?"
Agent: "Yes, we offer international shipping to most countries. Shipping costs and delivery times vary by location. Please contact our sales team for specific international shipping quotes."
```

### 🎯 **What You Can Ask About**

#### **Products & Inventory:**
- ✅ **Specific products**: "Do you have Intel Xeon E5-2670 V3?"
- ✅ **Product categories**: "What AMD processors do you carry?"
- ✅ **Pricing**: "What's the price of Intel processors?"
- ✅ **Availability**: "Is the Intel Xeon in stock?"
- ✅ **Specifications**: "What are the specs of the E5-2670 V3?"

#### **Services & Support:**
- ✅ **Warranty information**: "What warranty do you offer?"
- ✅ **Technical support**: "Do you provide installation services?"
- ✅ **Consulting**: "Do you offer IT consulting?"
- ✅ **Contact information**: "How can I reach customer support?"

#### **Company Information:**
- ✅ **Business hours**: "What are your operating hours?"
- ✅ **Shipping**: "Do you ship internationally?"
- ✅ **Returns**: "What's your return policy?"
- ✅ **Payment**: "What payment methods do you accept?"

### 🔍 **Tips for Best Results**

1. **Be Specific**: Instead of "Do you have processors?", ask "Do you have Intel Xeon E5-2670 V3 processors?"

2. **Ask One Question at a Time**: "What's the price and warranty?" → Ask about price first, then warranty

3. **Use Product Names**: "Intel Xeon E5-2670 V3" is better than "that Intel processor"

4. **Check Health First**: If the system seems slow, check `http://localhost:8000/health`

### 🚨 **Troubleshooting for Users**

**If you get an error:**
```bash
# Check if the service is running
curl http://localhost:8000/health

# If it's not responding, the service might be down
# Contact your system administrator
```

**If you get a generic answer:**
- Try rephrasing your question
- Be more specific about what you're looking for
- Check if you're using the correct product names

**If the response is slow:**
- The system might be processing a complex query
- Wait a few seconds and try again
- Check if there are many other users

### 📱 **Integration Examples**

#### **For Web Applications:**
```html
<!-- Simple HTML form -->
<form id="questionForm">
    <input type="text" id="question" placeholder="Ask about our products...">
    <button type="submit">Ask</button>
</form>
<div id="answer"></div>

<script>
document.getElementById('questionForm').onsubmit = async (e) => {
    e.preventDefault();
    const question = document.getElementById('question').value;
    
    const response = await fetch('/ask', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({question})
    });
    
    const data = await response.json();
    document.getElementById('answer').textContent = data.answer;
};
</script>
```

#### **For Mobile Apps:**
```javascript
// React Native example
const askQuestion = async (question) => {
    try {
        const response = await fetch('http://your-server:8000/ask', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({question})
        });
        const data = await response.json();
        return data.answer;
    } catch (error) {
        return 'Sorry, I cannot answer right now. Please try again later.';
    }
};
```

## 💰 Cost Optimization Features

### Resource Allocation by Environment
| Environment | Memory | CPU | Instances | Auto-scaling |
|-------------|--------|-----|-----------|--------------|
| Development | 512MB  | 0.5 | 1         | ❌           |
| Staging     | 1GB    | 1.0 | 2         | ✅           |
| Production  | 2GB    | 2.0 | 3         | ✅           |

### Auto-scaling Policies
- **Scale Up**: CPU > 80% OR Memory > 80%
- **Scale Down**: CPU < 30% AND Memory < 30%
- **Cooldown**: 300s (scale up), 600s (scale down)

### Cost Monitoring
- Real-time resource usage tracking
- Automated cost alerts
- Performance optimization
- Efficient caching strategies

## 🚀 Performance Optimization

### Latency Optimization
- **SSD Storage**: Fast I/O operations
- **Connection Pooling**: Database efficiency
- **Caching**: Response optimization
- **Load Balancing**: Traffic distribution

### Throughput Optimization
- **Worker Processes**: Parallel processing
- **Batch Processing**: Kafka efficiency
- **Compression**: Network optimization
- **Resource Limits**: Prevent over-allocation

## 🔒 Security Features

- **Non-root Container Execution**: Security best practices
- **Environment Variable Management**: Secure configuration
- **Network Security Groups**: Firewall automation
- **SSL/TLS Termination**: Production security
- **API Key Protection**: Secure authentication

## 📊 Monitoring & Observability

### Health Checks
```bash
# Manual health check
./scripts/health_check.sh

# Automated monitoring
./scripts/monitor.sh customer-service-agent-development
```

### Metrics Collection
- CPU and memory usage
- Response times
- Error rates
- Cost metrics

### Logging
- Application logs: `logs/customer_service.log`
- Health check logs: `logs/health_check.log`
- Monitoring logs: `logs/monitoring.log`
- Docker logs: `docker logs <container-name>`

## 🔄 Backup & Recovery

### Automated Backups
```bash
# Manual backup
./scripts/backup.sh

# Automated backup (cron)
0 2 * * * /path/to/scripts/backup.sh
```

### Recovery Procedures
- Data restoration from backups
- Service restart automation
- Health validation post-recovery
- Rollback procedures


## 📋 Troubleshooting

### Common Issues

1. **API not responding:**
   ```bash
   docker ps
   docker logs customer-service-agent-development
   ./scripts/health_check.sh
   ```

2. **High resource usage:**
   ```bash
   ./scripts/monitor.sh
   ./scripts/auto_scale.sh
   ```

3. **Infrastructure issues:**
   ```bash
   cd infrastructure
   terraform plan
   terraform refresh
   ```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add automation improvements
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🧪 **Testing & Running - Complete Guide**

### 🎯 **Quick Test (5 Minutes)**

Want to see it working immediately? Here's the fastest way:

```bash
# 1. Clone and setup (2 minutes)
git clone <repository-url>
cd customer-service-agent
chmod +x scripts/setup.sh
./scripts/setup.sh

# 2. Add your Google API key (30 seconds)
echo "GOOGLE_API_KEY=your-actual-api-key-here" >> .env

# 3. Run the application (1 minute)
source venv/bin/activate
uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# 4. Test in another terminal (30 seconds)
curl http://localhost:8000/health
curl -X POST "http://localhost:8000/ask" \
     -H "Content-Type: application/json" \
     -d '{"question": "What products do you have?"}'
```

### 🚀 **Detailed Testing Scenarios**

#### **Scenario 1: Local Development Testing**

**Prerequisites Check:**
```bash
# Check Python version
python3 --version  # Should be 3.8+

# Check if you have curl
curl --version

# Check available memory
free -h  # Should have at least 2GB available
```

**Step-by-Step Setup:**
```bash
# 1. Clone the repository
git clone <repository-url>
cd customer-service-agent

# 2. Make scripts executable
chmod +x scripts/setup.sh
chmod +x scripts/deploy.sh
chmod +x scripts/health_check.sh

# 3. Run automated setup
./scripts/setup.sh

# 4. Configure environment
nano .env
# Add: GOOGLE_API_KEY=your-actual-api-key-here

# 5. Activate virtual environment
source venv/bin/activate

# 6. Verify installation
python -c "import fastapi, uvicorn; print('✅ Dependencies installed')"
```

**Start the Application:**
```bash
# Start the API server
uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# You should see:
# INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
# INFO:     Started reloader process [12345] using StatReload
# INFO:     Started server process [12346]
# INFO:     Waiting for application startup.
# INFO:     Application startup complete.
```

**Test the API:**
```bash
# Test 1: Health check
curl http://localhost:8000/health
# Expected: {"status": "healthy", "timestamp": "..."}

# Test 2: Ask a question
curl -X POST "http://localhost:8000/ask" \
     -H "Content-Type: application/json" \
     -d '{"question": "Do you have Intel processors?"}'
# Expected: {"answer": "Yes, we have Intel processors..."}

# Test 3: Interactive documentation
# Open browser: http://localhost:8000/docs
```

#### **Scenario 2: Docker Testing**

**Prerequisites:**
```bash
# Check Docker installation
docker --version
docker-compose --version

# Check Docker daemon
docker ps
```

**Build and Run:**
```bash
# 1. Build the Docker image
docker build -t customer-service-agent:test .

# 2. Run the container
docker run -d \
  --name customer-service-agent-test \
  -p 8000:8000 \
  -e GOOGLE_API_KEY=your-api-key-here \
  customer-service-agent:test

# 3. Check container status
docker ps
docker logs customer-service-agent-test

# 4. Test the API
curl http://localhost:8000/health
```

**Using the Deployment Script:**
```bash
# Automated deployment with monitoring
./scripts/deploy.sh development

# Check deployment status
./scripts/health_check.sh
./scripts/monitor.sh customer-service-agent-development
```

#### **Scenario 3: Full Infrastructure Testing (Leaseweb)**

**Prerequisites:**
```bash
# Install Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Verify installation
terraform --version
```

**Deploy Infrastructure:**
```bash
# 1. Navigate to infrastructure directory
cd infrastructure

# 2. Create configuration
cat > terraform.tfvars << EOF
leaseweb_api_key = "your-leaseweb-api-key-here"
environment = "development"
app_name = "customer-service-agent"
EOF

# 3. Initialize Terraform
terraform init

# 4. Plan deployment
terraform plan

# 5. Apply changes
terraform apply -auto-approve

# 6. Get the load balancer IP
terraform output load_balancer_ip
```

**Test the Deployed Application:**
```bash
# Get the IP address
LOAD_BALANCER_IP=$(terraform output -raw load_balancer_ip)

# Test health endpoint
curl http://$LOAD_BALANCER_IP/health

# Test the API
curl -X POST "http://$LOAD_BALANCER_IP/ask" \
     -H "Content-Type: application/json" \
     -d '{"question": "What products do you offer?"}'
```

### 🧪 **Comprehensive Testing Suite**

#### **API Endpoint Testing**

**Health Check:**
```bash
# Basic health check
curl http://localhost:8000/health

# Detailed health check with timing
curl -w "@-" -o /dev/null -s "http://localhost:8000/health" <<'EOF'
     time_namelookup:  %{time_namelookup}\n
        time_connect:  %{time_connect}\n
     time_appconnect:  %{time_appconnect}\n
    time_pretransfer:  %{time_pretransfer}\n
       time_redirect:  %{time_redirect}\n
  time_starttransfer:  %{time_starttransfer}\n
                     ----------\n
          time_total:  %{time_total}\n
EOF
```

**Question Testing:**
```bash
# Test 1: Basic product inquiry
curl -X POST "http://localhost:8000/ask" \
     -H "Content-Type: application/json" \
     -d '{"question": "Do you have Intel Xeon processors?"}'

# Test 2: Specific product details
curl -X POST "http://localhost:8000/ask" \
     -H "Content-Type: application/json" \
     -d '{"question": "What is the price of Intel Xeon E5-2670 V3?"}'

# Test 3: General inquiry
curl -X POST "http://localhost:8000/ask" \
     -H "Content-Type: application/json" \
     -d '{"question": "What services do you provide?"}'

# Test 4: Error handling (empty question)
curl -X POST "http://localhost:8000/ask" \
     -H "Content-Type: application/json" \
     -d '{"question": ""}'
```

#### **Performance Testing**

**Load Testing:**
```bash
# Install Apache Bench (if not available)
sudo apt-get install apache2-utils

# Basic load test (10 requests, 2 concurrent)
ab -n 10 -c 2 -T application/json -p test_data.json http://localhost:8000/ask

# Create test data file
cat > test_data.json << EOF
{"question": "Do you have Intel processors?"}
EOF

# Extended load test
ab -n 100 -c 10 -T application/json -p test_data.json http://localhost:8000/ask
```

**Resource Monitoring:**
```bash
# Monitor system resources
htop

# Monitor Docker resources
docker stats customer-service-agent-test

# Check application logs
tail -f logs/customer_service.log
```

#### **Automation Testing**

**Health Check Automation:**
```bash
# Run automated health check
./scripts/health_check.sh

# Expected output:
# ✅ Virtual environment active
# ✅ Environment file exists
# ✅ API server is running on port 8000
# ✅ Disk space OK: 50GB free
# ✅ Memory OK: 2048MB free
# ✅ Health check completed
```

**Monitoring Automation:**
```bash
# Run system monitoring
./scripts/monitor.sh

# Expected output:
# 📊 System Monitoring Report
# 🖥️  System Info:
#   Hostname: your-hostname
#   Uptime: 2 days, 3 hours
#   Load Average: 0.5 0.3 0.2
# 🧠 Memory Usage:
#   Mem: 8.0G total, 2.1G used, 5.9G free
# 💾 Disk Usage:
#   /dev/sda1  50G  10G  40G  20% /
# 🐳 Docker Containers:
#   customer-service-agent-test  Up 2 minutes  0.0.0.0:8000->8000/tcp
```

**Auto-scaling Test:**
```bash
# Simulate high load
for i in {1..50}; do
  curl -X POST "http://localhost:8000/ask" \
       -H "Content-Type: application/json" \
       -d '{"question": "Test question '$i'"}' &
done

# Check auto-scaling
./scripts/auto_scale.sh customer-service-agent-test
```

### 🔧 **Troubleshooting Guide**

#### **Common Issues & Solutions**

**Issue 1: "ModuleNotFoundError: No module named 'fastapi'"`
```bash
# Solution: Activate virtual environment
source venv/bin/activate
pip install -r requirements.txt
```

**Issue 2: "Connection refused" on port 8000**
```bash
# Check if port is in use
lsof -i :8000

# Kill existing process if needed
sudo kill -9 $(lsof -t -i:8000)

# Or use different port
uvicorn main:app --host 0.0.0.0 --port 8001 --reload
```

**Issue 3: "Google API key not found"**
```bash
# Check environment file
cat .env

# Set API key manually
export GOOGLE_API_KEY=your-api-key-here
```

**Issue 4: "Docker build failed"**
```bash
# Clean Docker cache
docker system prune -a

# Rebuild without cache
docker build --no-cache -t customer-service-agent:test .
```

**Issue 5: "Terraform plan failed"**
```bash
# Check Terraform configuration
cd infrastructure
terraform validate

# Check API key
echo $LEASEWEB_API_KEY

# Reinitialize if needed
terraform init -reconfigure
```

#### **Debug Mode Testing**

**Enable Debug Logging:**
```bash
# Set debug environment
export LOG_LEVEL=DEBUG
export PYTHONPATH=/path/to/project

# Run with debug output
uvicorn main:app --host 0.0.0.0 --port 8000 --reload --log-level debug
```

**Test Individual Components:**
```bash
# Test Kafka producer
python -c "
from src.kafka_producer import send_query_event
result = send_query_event('test question')
print(f'Kafka test: {result}')
"

# Test database connection
python -c "
from src.db import db_conn
print('Database test: OK')
"

# Test search functionality
python -c "
from src.search import search_inventory
result = search_inventory('Intel')
print(f'Search test: {len(result)} results')
"
```

### 📊 **Testing Results Validation**

**Expected Test Results:**
```bash
# Health check should return:
{
  "status": "healthy",
  "timestamp": "2024-01-01T12:00:00Z",
  "version": "1.0.0",
  "environment": "development"
}

# Question response should return:
{
  "answer": "Yes, we have Intel Xeon processors available. The Intel Xeon E5-2670 V3 is a high-performance server processor with 12 cores and 24 threads..."
}

# Performance metrics should show:
# - Response time: < 2 seconds
# - Memory usage: < 1GB
# - CPU usage: < 50%
```

### 🎯 **Quick Validation Checklist**

Before considering the test successful, verify:

- [ ] Health endpoint responds with status "healthy"
- [ ] Question endpoint returns relevant answers
- [ ] Docker container runs without errors
- [ ] Logs show no critical errors
- [ ] Resource usage is within expected limits
- [ ] Auto-scaling scripts work correctly
- [ ] Backup scripts create valid backups
- [ ] Monitoring scripts provide useful output

## 🌐 **How to Use the Customer Service Agent**

### 🎯 **For End Users (Customers)**

Once the system is running, here's how you can interact with the Customer Service Agent:

#### **Option 1: Web Interface (Easiest)**

1. **Open your web browser**
2. **Go to:** `http://localhost:8000/docs` (or your server's IP address)
3. **Click on the `/ask` endpoint**
4. **Click "Try it out"**
5. **Type your question** in the JSON format:
   ```json
   {
     "question": "Do you have Intel Xeon processors?"
   }
   ```
6. **Click "Execute"** to get your answer!

#### **Option 2: Direct API Calls**

**Using curl:**
```bash
# Ask about products
curl -X POST "http://localhost:8000/ask" \
     -H "Content-Type: application/json" \
     -d '{"question": "Do you have Intel Xeon E5-2670 V3 processors?"}'

# Ask about services
curl -X POST "http://localhost:8000/ask" \
     -H "Content-Type: application/json" \
     -d '{"question": "What warranty do you offer?"}'

# Ask about pricing
curl -X POST "http://localhost:8000/ask" \
     -H "Content-Type: application/json" \
     -d '{"question": "What is the price of Intel processors?"}'
```

**Using Python:**
```python
import requests

# Ask a question
response = requests.post(
    "http://localhost:8000/ask",
    json={"question": "Do you have Intel processors?"}
)

# Get the answer
answer = response.json()["answer"]
print(answer)
```

**Using JavaScript:**
```javascript
// Ask a question
fetch('http://localhost:8000/ask', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
    },
    body: JSON.stringify({
        question: 'Do you have Intel processors?'
    })
})
.then(response => response.json())
.then(data => console.log(data.answer));
```

### 💬 **Example Conversations**

#### **Product Inquiries:**
```
You: "Do you have Intel Xeon processors?"
Agent: "Yes, we have Intel Xeon processors available. The Intel Xeon E5-2670 V3 is a high-performance server processor with 12 cores and 24 threads. Price: $2,042.69. Available at: Main Warehouse. Contact: John Doe (john.doe@company.com)."

You: "What is the price of Intel Xeon E5-2670 V3?"
Agent: "The Intel Xeon E5-2670 V3 is priced at $2,042.69. It's currently in stock with 77 units available at our Main Warehouse location."

You: "Do you have any AMD processors?"
Agent: "Let me check our inventory for AMD processors..."
```

#### **Service Inquiries:**
```
You: "What warranty do you offer?"
Agent: "Based on our company policies, we offer a standard 1-year warranty on all hardware products, with extended warranty options available for enterprise customers."

You: "What services do you provide?"
Agent: "We provide computer hardware sales, technical support, consulting services, and custom system builds. Our team of certified technicians can assist with installation, configuration, and ongoing maintenance."

You: "How can I contact customer support?"
Agent: "You can reach our customer support team at support@company.com or call us at 1-800-TECH-SUPPORT. Our support hours are Monday-Friday 9 AM to 6 PM EST."
```

#### **General Inquiries:**
```
You: "What are your business hours?"
Agent: "Our business hours are Monday through Friday, 9:00 AM to 6:00 PM EST. We're closed on weekends and major holidays."

You: "Do you ship internationally?"
Agent: "Yes, we offer international shipping to most countries. Shipping costs and delivery times vary by location. Please contact our sales team for specific international shipping quotes."
```

### 🎯 **What You Can Ask About**

#### **Products & Inventory:**
- ✅ **Specific products**: "Do you have Intel Xeon E5-2670 V3?"
- ✅ **Product categories**: "What AMD processors do you carry?"
- ✅ **Pricing**: "What's the price of Intel processors?"
- ✅ **Availability**: "Is the Intel Xeon in stock?"
- ✅ **Specifications**: "What are the specs of the E5-2670 V3?"

#### **Services & Support:**
- ✅ **Warranty information**: "What warranty do you offer?"
- ✅ **Technical support**: "Do you provide installation services?"
- ✅ **Consulting**: "Do you offer IT consulting?"
- ✅ **Contact information**: "How can I reach customer support?"

#### **Company Information:**
- ✅ **Business hours**: "What are your operating hours?"
- ✅ **Shipping**: "Do you ship internationally?"
- ✅ **Returns**: "What's your return policy?"
- ✅ **Payment**: "What payment methods do you accept?"

### 🔍 **Tips for Best Results**

1. **Be Specific**: Instead of "Do you have processors?", ask "Do you have Intel Xeon E5-2670 V3 processors?"

2. **Ask One Question at a Time**: "What's the price and warranty?" → Ask about price first, then warranty

3. **Use Product Names**: "Intel Xeon E5-2670 V3" is better than "that Intel processor"

4. **Check Health First**: If the system seems slow, check `http://localhost:8000/health`

### 🚨 **Troubleshooting for Users**

**If you get an error:**
```bash
# Check if the service is running
curl http://localhost:8000/health

# If it's not responding, the service might be down
# Contact your system administrator
```

**If you get a generic answer:**
- Try rephrasing your question
- Be more specific about what you're looking for
- Check if you're using the correct product names

**If the response is slow:**
- The system might be processing a complex query
- Wait a few seconds and try again
- Check if there are many other users

### 📱 **Integration Examples**

#### **For Web Applications:**
```html
<!-- Simple HTML form -->
<form id="questionForm">
    <input type="text" id="question" placeholder="Ask about our products...">
    <button type="submit">Ask</button>
</form>
<div id="answer"></div>

<script>
document.getElementById('questionForm').onsubmit = async (e) => {
    e.preventDefault();
    const question = document.getElementById('question').value;
    
    const response = await fetch('/ask', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({question})
    });
    
    const data = await response.json();
    document.getElementById('answer').textContent = data.answer;
};
</script>
```

#### **For Mobile Apps:**
```javascript
// React Native example
const askQuestion = async (question) => {
    try {
        const response = await fetch('http://your-server:8000/ask', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({question})
        });
        const data = await response.json();
        return data.answer;
    } catch (error) {
        return 'Sorry, I cannot answer right now. Please try again later.';
    }
};
```

---

## 🧪 **Testing & Running - Complete Guide**
