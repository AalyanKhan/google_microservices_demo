# Google Microservices Demo - Docker Learning Project

This repository contains a comprehensive microservices demo application from Google, specifically adapted for learning Docker in depth. Each service has been containerized with custom Dockerfiles to provide hands-on experience with Docker concepts, multi-stage builds, and microservices architecture.

## 🐳 Docker Learning Objectives

This project is designed to help you master:

- **Docker Fundamentals**: Containerization, images, and containers
- **Dockerfile Best Practices**: Multi-stage builds, layer optimization, and security
- **Microservices Architecture**: Service communication and container orchestration
- **Docker Networking**: Inter-service communication and service discovery
- **Docker Compose**: Multi-container application management
- **Production Considerations**: Security, performance, and monitoring
- **Image Optimization**: Advanced techniques for reducing image sizes

## 🏗️ Architecture Overview

This e-commerce application consists of 11 microservices:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │  Load Generator  │    │  Shopping       │
│   (Go)          │    │  (Python)        │    │  Assistant      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
    ┌────────────────────────────┼────────────────────────────┐
    │                            │                            │
┌───▼───┐  ┌─────────┐  ┌────────▼───┐  ┌─────────┐  ┌─────────┐
│ Cart  │  │Product  │  │Recommendation│  │Payment  │  │Shipping │
│Service│  │Catalog  │  │   Service    │  │Service  │  │Service  │
│(.NET) │  │ (Go)    │  │  (Python)    │  │(Node.js)│  │ (Go)    │
└───────┘  └─────────┘  └─────────────┘  └─────────┘  └─────────┘
    │            │              │            │            │
    └────────────┼──────────────┼────────────┼────────────┘
                 │              │            │
         ┌───────▼───┐  ┌───────▼───┐  ┌─────▼─────┐
         │Currency   │  │Email      │  │Ad         │
         │Service    │  │Service    │  │Service    │
         │(Node.js)  │  │(Python)   │  │(Java)     │
         └───────────┘  └───────────┘  └───────────┘
```

## 🚀 Services Overview

### Frontend Services
- **Frontend** (`frontend/`) - Go-based web application
- **Load Generator** (`loadgenerator/`) - Python-based traffic generator

### Core Business Services
- **Product Catalog Service** (`productcatalogservice/`) - Go service for product management
- **Cart Service** (`cartservice/`) - .NET service for shopping cart functionality
- **Recommendation Service** (`recommendationservice/`) - Python service for product recommendations
- **Checkout Service** (`checkoutservice/`) - Go service for order processing

### Supporting Services
- **Payment Service** (`paymentservice/`) - Node.js service for payment processing
- **Shipping Service** (`shippingservice/`) - Go service for shipping calculations
- **Currency Service** (`currencyservice/`) - Node.js service for currency conversion
- **Email Service** (`emailservice/`) - Python service for email notifications
- **Ad Service** (`adservice/`) - Java service for advertisement management
- **Shopping Assistant Service** (`shoppingservice/`) - Python service for AI assistance

## 📊 Docker Image Optimization Results

This project demonstrates advanced Docker optimization techniques, achieving significant size reductions through multi-stage builds and DockerSlim optimization:

| Repository | Original Size | Service | Language | After Multi-Stage | Slimmed Size | Reduction | Multiplier |
|------------|---------------|---------|----------|-------------------|--------------|-----------|------------|
| adservice | 689MB | adservice | Java | 276MB | 136MB | 80.3% | 5.1x |
| cartservice | 850MB | cartservice | .NET | 120MB | 48.6MB | 94.3% | 17.5x |
| checkoutservice | 1.61GB | checkoutservice | Go | 18.2MB | 16.1MB | 99.0% | 100x |
| currencyservice | 1.26GB | currencyservice | Node.js | 323MB | 103MB | 91.8% | 12.2x |
| emailservice | 1.24GB | emailservice | Python | 256MB | 9.4MB | 99.2% | 132x |
| frontend | 1.68GB | frontend | Go | 20.2MB | 18.2MB | 98.9% | 92.3x |
| loadgenerator | 1.24GB | loadgenerator | Python | 135MB | 39.9MB | 96.8% | 31.1x |
| paymentservice | 1.25GB | paymentservice | Node.js | 308MB | 103MB | 91.8% | 12.1x |
| productcatalogservice | 1.76GB | productcatalogservice | Go | 26MB | 23.9MB | 98.6% | 73.6x |
| recommendationservice | 1.24GB | recommendationservice | Python | 254MB | 9.4MB | 99.2% | 132x |
| shippingservice | 1.59GB | shippingservice | Go | 17.5MB | 17.5MB | 98.9% | 90.9x |
| **TOTAL** | **14.88 GB** | | | **1.75 GB** | **528 MB** | **96.4%** | **28.2x** |

### 🎯 Optimization Highlights

- **Total Size Reduction**: From 14.88 GB to 528 MB (96.4% reduction)
- **Best Performing Service**: Email Service (99.2% reduction, 132x smaller)
- **Multi-stage Build Impact**: Reduced total size from 14.88 GB to 1.75 GB
- **DockerSlim Impact**: Further reduced from 1.75 GB to 528 MB

## 🛠️ Slimify Script - Advanced Image Optimization

The `slimify.sh` script uses DockerSlim to create ultra-optimized container images by analyzing runtime behavior and removing unnecessary components.

### What is DockerSlim?

DockerSlim is a tool that automatically optimizes Docker images by:
- Analyzing container runtime behavior
- Removing unused files and dependencies
- Creating minimal, production-ready images
- Maintaining full application functionality

### How to Use the Slimify Script

```bash
# Basic usage
./slimify.sh <source-image> <target-tag>

# Example: Optimize the frontend service
./slimify.sh aalyankhan029/frontend:latest aalyankhan029/frontend-slim:latest

# Example: Optimize the cart service
./slimify.sh aalyankhan029/cartservice:latest aalyankhan029/cartservice-slim:latest
```

### Script Features

- **Automated Optimization**: Uses DockerSlim to analyze and optimize images
- **HTTP Probe Disabled**: Optimized for microservices (no web interface needed)
- **Size Comparison**: Shows before/after image sizes
- **Error Handling**: Stops on any errors for reliable builds
- **Color Output**: Easy-to-read terminal output with color coding

### Prerequisites for Slimify

```bash
# Ensure Docker is running
docker --version

# The script will automatically pull the dslim/slim image
# No additional installation required
```

### Advanced Usage

```bash
# Make the script executable
chmod +x slimify.sh

# Optimize multiple services
./slimify.sh aalyankhan029/frontend:latest aalyankhan029/frontend-slim:latest
./slimify.sh aalyankhan029/cartservice:latest aalyankhan029/cartservice-slim:latest
./slimify.sh aalyankhan029/checkoutservice:latest aalyankhan029/checkoutservice-slim:latest
```

## 🐳 Docker Learning Path

### Phase 1: Basic Containerization
1. **Start with simple services**: Begin with stateless services like `currencyservice`
2. **Understand Dockerfile layers**: Study how each instruction creates a layer
3. **Practice image building**: Build and tag images for each service

### Phase 2: Multi-stage Builds
1. **Optimize image sizes**: Use multi-stage builds for compiled languages (Go, Java, .NET)
2. **Security considerations**: Learn about distroless images and security scanning
3. **Build context optimization**: Understand `.dockerignore` and build context

### Phase 3: Advanced Optimization
1. **DockerSlim Integration**: Learn to use the slimify script for maximum optimization
2. **Image Analysis**: Understand what gets removed and why
3. **Production Readiness**: Create ultra-optimized production images

### Phase 4: Networking & Communication
1. **Container networking**: Learn about Docker networks and service discovery
2. **Inter-service communication**: Understand gRPC and HTTP communication
3. **Load balancing**: Practice with multiple instances of the same service

### Phase 5: Orchestration
1. **Docker Compose**: Create a complete stack with all services
2. **Environment management**: Use environment variables and config files
3. **Health checks**: Implement proper health checking for services

## 🛠️ Getting Started

### Prerequisites
- Docker Desktop or Docker Engine
- Docker Compose (optional, for orchestration)
- Git

### Quick Start
```bash
# Clone the repository
git clone https://github.com/AalyanKhan/google_microservices_demo.git
cd google_microservices_demo

# Build a single service (example: currency service)
cd currencyservice
docker build -t currency-service .

# Run the service
docker run -p 8080:8080 currency-service

# Optimize the service using slimify
cd ..
./slimify.sh currency-service currency-service-slim
```

### Build All Services
```bash
# Build all services at once
./build-all.sh  # Create this script to build all services

# Optimize all services
for service in adservice cartservice checkoutservice currencyservice emailservice frontend loadgenerator paymentservice productcatalogservice recommendationservice shippingservice; do
  ./slimify.sh aalyankhan029/$service:latest aalyankhan029/$service-slim:latest
done
```

## 📚 Docker Concepts Covered

### 1. Dockerfile Best Practices
- **Base Image Selection**: Choosing appropriate base images
- **Layer Caching**: Optimizing build times with layer caching
- **Security**: Running as non-root user, minimal attack surface
- **Multi-stage Builds**: Reducing final image size

### 2. Advanced Image Optimization
- **DockerSlim Integration**: Automated image optimization
- **Runtime Analysis**: Understanding what's actually needed
- **Dependency Reduction**: Removing unused components
- **Size Monitoring**: Tracking optimization effectiveness

### 3. Container Networking
- **Bridge Networks**: Default Docker networking
- **Custom Networks**: Creating isolated network environments
- **Service Discovery**: How containers find each other
- **Port Mapping**: Exposing container ports to host

### 4. Data Persistence
- **Volumes**: Persistent data storage
- **Bind Mounts**: Development-time file sharing
- **Volume Drivers**: Using different storage backends

### 5. Environment Management
- **Environment Variables**: Configuring container behavior
- **Secrets Management**: Handling sensitive data
- **Configuration Files**: Managing service configurations

## 🔧 Service-Specific Docker Learning

### Go Services (Frontend, Product Catalog, Checkout, Shipping)
```dockerfile
# Learn about:
# - Multi-stage builds for Go applications
# - Distroless images for security
# - Static binary compilation
# - Ultra-optimization with DockerSlim
```

### Python Services (Email, Recommendation, Shopping Assistant)
```dockerfile
# Learn about:
# - Python dependency management in containers
# - Virtual environments in Docker
# - Python-specific optimizations
# - Massive size reductions (99%+ possible)
```

### Node.js Services (Payment, Currency)
```dockerfile
# Learn about:
# - npm dependency caching
# - Node.js production optimizations
# - Package.json best practices
# - Node.js optimization techniques
```

### .NET Services (Cart Service)
```dockerfile
# Learn about:
# - .NET containerization
# - Framework dependencies
# - .NET-specific optimizations
# - Cross-platform .NET containers
```

### Java Services (Ad Service)
```dockerfile
# Learn about:
# - JVM optimization in containers
# - Maven/Gradle in Docker
# - Java application server configuration
# - Java container optimization
```

## 🚀 Advanced Docker Topics

### 1. Image Optimization Techniques
- **Multi-stage Builds**: Reducing build-time dependencies
- **DockerSlim Analysis**: Runtime-based optimization
- **Layer Optimization**: Minimizing layer count and size
- **Base Image Selection**: Choosing the right foundation

### 2. Container Orchestration
- **Docker Compose**: Multi-container applications
- **Service Scaling**: Running multiple instances
- **Health Checks**: Monitoring service health
- **Dependency Management**: Service startup order

### 3. Production Considerations
- **Security Scanning**: Vulnerability assessment
- **Image Signing**: Trust and integrity
- **Resource Limits**: CPU and memory constraints
- **Logging**: Centralized log management

### 4. Monitoring & Debugging
- **Container Logs**: Accessing and managing logs
- **Resource Monitoring**: CPU, memory, and network usage
- **Debugging**: Troubleshooting container issues
- **Performance Tuning**: Optimizing container performance

## 📖 Learning Exercises

### Beginner Level
1. Build and run each service individually
2. Understand the Dockerfile for each service
3. Experiment with different base images
4. Practice port mapping and networking

### Intermediate Level
1. Create a Docker Compose file for the entire stack
2. Implement health checks for all services
3. Set up service discovery and communication
4. Optimize Dockerfile layers for faster builds

### Advanced Level
1. Implement multi-stage builds for all services
2. Use the slimify script to optimize all images
3. Set up monitoring and logging
4. Create production-ready configurations
5. Implement security best practices

### Expert Level
1. Achieve 95%+ size reduction on all services
2. Create custom optimization scripts
3. Implement automated optimization pipelines
4. Master DockerSlim advanced features

## 🐛 Troubleshooting

### Common Issues
- **Port Conflicts**: Ensure ports are not already in use
- **Network Issues**: Check Docker network configuration
- **Build Failures**: Verify Dockerfile syntax and dependencies
- **Service Communication**: Ensure proper service discovery
- **Slimify Failures**: Check DockerSlim prerequisites

### Debugging Commands
```bash
# Check running containers
docker ps

# View container logs
docker logs <container-name>

# Inspect container details
docker inspect <container-name>

# Check Docker networks
docker network ls

# Check image sizes
docker images

# Analyze image layers
docker history <image-name>
```

### Slimify Troubleshooting
```bash
# Check if DockerSlim is working
docker run --rm dslim/slim version

# Debug slimify script
bash -x ./slimify.sh <source-image> <target-tag>

# Check Docker daemon access
docker info
```

## 📚 Additional Resources

- [Docker Official Documentation](https://docs.docker.com/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [DockerSlim Documentation](https://github.com/docker-slim/docker-slim)
- [Microservices Patterns](https://microservices.io/)

## 🤝 Contributing

This is a learning project! Feel free to:
- Improve Dockerfiles
- Add new services
- Enhance documentation
- Share your learning experiences
- Contribute optimization techniques

## 📄 License

This project is based on Google's microservices demo and is intended for educational purposes.

---

**Happy Learning! 🐳**

Start with one service, understand its Dockerfile, then gradually work through the entire stack. Each service teaches different Docker concepts and best practices. Use the slimify script to achieve maximum optimization and learn advanced container techniques!