# Go Portfolio API

> A modern, containerized Go API backend for portfolio websites, running in and deployed from AWS, using Terraform (Infrastructure as Code).

[![Work in Progress](https://img.shields.io/badge/status-work%20in%20progress-yellow)](https://github.com/yourusername/dobsonddev-portfolio-api)
## 🔄 Development Roadmap

- [x] **Infrastructure**: AWS setup with Terraform
- [ ] **Deployment**: Manual ECR image pushes
- [ ] **API Development**: Complete Go server endpoints  
- [ ] **Frontend Integration**: Update [my Next.js dobsonddev-portfolio](https://github.com/dobsonddev/dobsonddev-portfolio) project to hit this api for Momo AI Chatbot feature, instead of using internal API ecosystem
- [ ] **CI/CD**: Automated deployments on git push
- [ ] **Monitoring**: Implement ELK Stack (Elasticsearch, Logstash, Kibana) (always wanted to learn/build something with these tools)
- [ ] **Testing**: Unit, load, and integration tests (probably K6 + Playright) (always wanted to learn/build something with these tools)

## Biiiiig note - I know this infra is waaaayyyy overkill for just running a very basic api server. I plan to refactor this infra from ALB + ECS Fargate to simply Lambda + API Gateway - this will be 80-90% cheaper (ALB is billed by the hour, ~$18/mo regardless of use). Plan to refactor into this much more fitting infra soon, just wanted to get it off the ground with something working first.

## 🚀 Quick Start

This project deploys a Go API to AWS using Terraform. Perfect for portfolio backends, chatbots, or any lightweight API service.

### What You Get
- **Scalable**: ECS Fargate + Application Load Balancer
- **Secure**: HTTPS with auto-managed SSL certificates  
- **Cost-effective**: ~$15-25/month for light usage
- **Production-ready**: VPC, private subnets, proper IAM roles

## 📋 Prerequisites

```bash
# Required tools
go install
docker --version
terraform --version
aws configure list
```

## 🏗️ Architecture

```
Internet → ALB (HTTPS) → ECS Fargate → Go API
                ↓
         ACM Certificate + Route53/Vercel DNS
```

**AWS Services Used:**
- ECS Fargate (container orchestration)
- ALB (load balancing + SSL termination)
- ECR (container registry)
- VPC (networking)
- ACM (SSL certificates)
- SSM Parameter Store (secrets)

## ⚡ Deployment

### 1. Deploy Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 2. Build & Deploy Application

```bash
# Build image
docker build -t portfolio-api .

# Get ECR URL from Terraform
export ECR_URL=$(terraform -chdir=terraform output -raw ecr_repository_url)

# Login to ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin $ECR_URL

# Push image
docker tag portfolio-api:latest $ECR_URL:latest
docker push $ECR_URL:latest

# Deploy to ECS
terraform apply
```

### 3. Access Your API

Your API will be available at: `https://api.yourdomain.com`

## 🛠️ Configuration

### Environment Variables
Set these in `terraform/variables.tf`:

```hcl
variable "domain_name" {
  default = "api.yourdomain.com"
}

variable "aws_region" {
  default = "us-east-1"
}
```

### API Endpoints
Current endpoints (add yours in `main.go`):

```
GET  /health           - Health check
POST /api/chat         - Chatbot endpoint
GET  /api/projects     - Portfolio projects
```

## 🔧 Common Commands

```bash
# View deployed infrastructure
terraform show

# Check ECS service status
aws ecs describe-services --cluster portfolio-api --services portfolio-api-service

# View application logs
aws logs tail /ecs/portfolio-api --follow

# Destroy everything
terraform destroy
```

## 💡 Customization

### Using This for Your Own Project

1. **Fork this repository**
2. **Update configuration**:
   ```bash
   # In terraform/variables.tf
   domain_name = "api.yourdomain.com"
   
   # In terraform/ecr.tf  
   name = "your-project-name"
   ```
3. **Follow deployment steps above**

### Adding New API Endpoints

```go
// In main.go
func main() {
    r := gin.Default()
    
    // Add your endpoints here
    r.GET("/api/your-endpoint", yourHandler)
    
    r.Run(":8080")
}
```

## 🐛 Troubleshooting

**Common Issues:**

- **ECR login fails**: Check AWS credentials and region
- **SSL certificate pending**: Verify DNS settings in Vercel/Route53
- **ECS task fails**: Check CloudWatch logs for Go application errors
- **502 Bad Gateway**: Application might not be listening on port 8080

**Getting Help:**
```bash
# Check ECS task logs
aws logs describe-log-groups --log-group-name-prefix="/ecs/portfolio-api"

# Verify load balancer health
aws elbv2 describe-target-health --target-group-arn <your-target-group-arn>
```

## 📈 Cost Optimization

Expected monthly costs (us-east-1):
- ALB: ~$16
- ECS Fargate (0.25 vCPU, 0.5GB): ~$3-8  
- ECR storage: ~$1
- **Total: $20-25/month**

## 🤝 Contributing

1. Fork the project
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

MIT License - feel free to use this for your own projects!

---

Built with ❤️ using Go, Terraform, and AWS
