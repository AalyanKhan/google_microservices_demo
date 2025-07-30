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

## 🐳 Docker Learning Path

### Phase 1: Basic Containerization
1. **Start with simple services**: Begin with stateless services like `currencyservice`
2. **Understand Dockerfile layers**: Study how each instruction creates a layer
3. **Practice image building**: Build and tag images for each service

### Phase 2: Multi-stage Builds
1. **Optimize image sizes**: Use multi-stage builds for compiled languages (Go, Java, .NET)
2. **Security considerations**: Learn about distroless images and security scanning
3. **Build context optimization**: Understand `.dockerignore` and build context

### Phase 3: Networking & Communication
1. **Container networking**: Learn about Docker networks and service discovery
2. **Inter-service communication**: Understand gRPC and HTTP communication
3. **Load balancing**: Practice with multiple instances of the same service

### Phase 4: Orchestration
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
```

### Build All Services
```bash
# Build all services at once
./build-all.sh  # Create this script to build all services
```

## 📚 Docker Concepts Covered

### 1. Dockerfile Best Practices
- **Base Image Selection**: Choosing appropriate base images
- **Layer Caching**: Optimizing build times with layer caching
- **Security**: Running as non-root user, minimal attack surface
- **Multi-stage Builds**: Reducing final image size

### 2. Container Networking
- **Bridge Networks**: Default Docker networking
- **Custom Networks**: Creating isolated network environments
- **Service Discovery**: How containers find each other
- **Port Mapping**: Exposing container ports to host

### 3. Data Persistence
- **Volumes**: Persistent data storage
- **Bind Mounts**: Development-time file sharing
- **Volume Drivers**: Using different storage backends

### 4. Environment Management
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
```

### Python Services (Email, Recommendation, Shopping Assistant)
```dockerfile
# Learn about:
# - Python dependency management in containers
# - Virtual environments in Docker
# - Python-specific optimizations
```

### Node.js Services (Payment, Currency)
```dockerfile
# Learn about:
# - npm dependency caching
# - Node.js production optimizations
# - Package.json best practices
```

### .NET Services (Cart Service)
```dockerfile
# Learn about:
# - .NET containerization
# - Framework dependencies
# - .NET-specific optimizations
```

### Java Services (Ad Service)
```dockerfile
# Learn about:
# - JVM optimization in containers
# - Maven/Gradle in Docker
# - Java application server configuration
```

## 🚀 Advanced Docker Topics

### 1. Container Orchestration
- **Docker Compose**: Multi-container applications
- **Service Scaling**: Running multiple instances
- **Health Checks**: Monitoring service health
- **Dependency Management**: Service startup order

### 2. Production Considerations
- **Security Scanning**: Vulnerability assessment
- **Image Signing**: Trust and integrity
- **Resource Limits**: CPU and memory constraints
- **Logging**: Centralized log management

### 3. Monitoring & Debugging
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
2. Set up monitoring and logging
3. Create production-ready configurations
4. Implement security best practices

## 🐛 Troubleshooting

### Common Issues
- **Port Conflicts**: Ensure ports are not already in use
- **Network Issues**: Check Docker network configuration
- **Build Failures**: Verify Dockerfile syntax and dependencies
- **Service Communication**: Ensure proper service discovery

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
```

## 📚 Additional Resources

- [Docker Official Documentation](https://docs.docker.com/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [Microservices Patterns](https://microservices.io/)

## 🤝 Contributing

This is a learning project! Feel free to:
- Improve Dockerfiles
- Add new services
- Enhance documentation
- Share your learning experiences

## 📄 License

This project is based on Google's microservices demo and is intended for educational purposes.

---

**Happy Learning! 🐳**

Start with one service, understand its Dockerfile, then gradually work through the entire stack. Each service teaches different Docker concepts and best practices.
