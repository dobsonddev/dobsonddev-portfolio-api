# dobsonddev-portfolio-api

[⚠️⚠️ WORK IN PROGRESS ⚠️⚠️]

---

# Go + AWS Portfolio API

## Project Overview

This project contains a Go-based API designed to serve as a backend for `https://www.dobsond.dev`, my personal portfolio website. The infrastructure is fully defined and managed as code (IaC) using Terraform, and it is deployed on Amazon Web Services (AWS) using a modern, containerized architecture with ECS Fargate.

The infrastructure is built to be , secure, and maintainable, with automated TLS/SSL certificate management and a clear, future path for autoamated continuous deployment. 

Development Roadmap:
- [x] Create base AWS infra + deployment, which will deploy api server upon manual ECR image pushes
- [ ] Build and deploy Go api server for dobsond.dev, which will contain the API endpoints for Momo chatbot feature
- [ ] Update frontend to hit and handle API calls to these new, separate api endpoints (instead of using Next.js internal API ecosystem)
- [ ] Hook up AWS Code+ to this repo's `main` branch, so that each push to main triggers a fresh Build + Deploy. (Aka automate CI/CD instead of manual image pushes)
- [ ] Find something else interesting to learn through this project - whether it be for Go or Terraform/IaC!

## Technology Stack

* **Application:** Go
* **Containerization:** Docker
* **Cloud Provider:** Amazon Web Services (AWS)
* **Infrastructure as Code:** Terraform
* **CI/CD & DNS:** Vercel (for DNS management)

### AWS Infrastructure Components

* **Networking:** Custom VPC with public and private subnets across two availability zones.
* **Container Orchestration:** Elastic Container Service (ECS) with AWS Fargate for serverless container execution.
* **Load Balancing:** Application Load Balancer (ALB) to distribute traffic and handle TLS termination.
* **Container Registry:** Elastic Container Registry (ECR) to store the application's Docker images.
* **Security:** IAM Roles for granular permissions, Security Groups for network firewalling, and AWS Certificate Manager (ACM) for SSL certificates.
* **Configuration Management:** AWS Systems Manager (SSM) Parameter Store for securely storing secrets like API keys.

## Prerequisites

Before you begin, ensure you have the following tools installed and configured:

* [Go](https://go.dev/doc/install) (for application development)
* [Docker](https://docs.docker.com/get-docker/) (for containerizing the application)
* [Terraform](https://developer.hashicorp.com/terraform/downloads) (for managing the cloud infrastructure in which this api server will run)
* [AWS CLI](https://aws.amazon.com/cli/) (configured with credentials for your AWS account)

## Setup and Deployment

The process is divided into two main phases: provisioning the cloud infrastructure and deploying the application.

### Phase 1: Provisioning the AWS Infrastructure

These steps create the entire AWS foundation for the API to run on.

1.  **Navigate to the Terraform Directory:**
    ```bash
    cd terraform
    ```

2.  **Initialize Terraform:**
    This downloads the necessary providers (AWS, Vercel, etc.).
    ```bash
    terraform init
    ```

3.  **Plan the Infrastructure:**
    This shows you what resources Terraform will create, change, or destroy.
    ```bash
    terraform plan
    ```

4.  **Apply the Infrastructure:**
    This builds all the AWS resources defined in the `.tf` files. You will be prompted to confirm.
    ```bash
    terraform apply
    ```
    *Note: The first time you apply, you may need to follow a two-step process to validate the ACM SSL certificate with your Vercel DNS if you haven't automated it with a Vercel provider.*

### Phase 2: Deploying the Go Application

Once the infrastructure is `Applied` successfully, it is ready to host your application.

1.  **Build the Docker Image:**
    From the root of your project directory, build the Docker image for your Go application.
    ```bash
    docker build -t portfolio-api .
    ```

2.  **Log in to AWS ECR:**
    Authenticate your Docker client with your private Elastic Container Registry.
    ```bash
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 203811615434.dkr.ecr.us-east-1.amazonaws.com
    ```

3.  **Tag and Push the Image to ECR:**
    Tag your local image to match the ECR repository URI and then push it.
    ```bash
    # Get your ECR repository URL from Terraform outputs
    export ECR_URL=$(terraform -chdir=terraform output -raw ecr_repository_url)

    # Tag the image
    docker tag portfolio-api:latest $ECR_URL:latest

    # Push the image
    docker push $ECR_URL:latest
    ```

4.  **Update the Task Definition:**
    In your `ecs.tf` file, find the `aws_ecs_task_definition` resource. Update the `image` attribute to use the specific image URI you just pushed (e.g., `"${ECR_URL}:latest"`).

5.  **Apply the Final Change:**
    Run `terraform apply` one last time. Terraform will detect the change in the task definition and deploy a new version of your container to the ECS service, making your API live.
    ```bash
    terraform apply
    ```

## Accessing the API deployment

Once deployed, the API will be available at your configured domain, secured with SSL:

(e.g. **`https://api.dobsond.dev/`**)
