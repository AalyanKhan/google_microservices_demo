#!/bin/bash

# Google Microservices Demo - Build All Services Script
# This script builds all microservices in the project for Docker learning

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
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

# Function to build a service
build_service() {
    local service_name=$1
    local service_path=$2
    local dockerfile_path=$3
    
    print_status "Building $service_name..."
    
    if [ ! -d "$service_path" ]; then
        print_error "Service directory $service_path not found!"
        return 1
    fi
    
    if [ ! -f "$dockerfile_path" ]; then
        print_error "Dockerfile not found at $dockerfile_path!"
        return 1
    fi
    
    cd "$service_path"
    
    # Build the Docker image
    if docker build -t "$service_name" -f "$dockerfile_path" .; then
        print_success "$service_name built successfully!"
    else
        print_error "Failed to build $service_name!"
        return 1
    fi
    
    cd - > /dev/null
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running or not accessible!"
        print_error "Please start Docker Desktop or Docker Engine and try again."
        exit 1
    fi
    print_success "Docker is running and accessible"
}

# Main execution
main() {
    print_status "🐳 Google Microservices Demo - Building All Services"
    print_status "=================================================="
    
    # Check if Docker is running
    check_docker
    
    # Get the script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$SCRIPT_DIR"
    
    print_status "Starting build process from: $SCRIPT_DIR"
    echo
    
    # Define all services with their paths and Dockerfile locations
    declare -a services=(
        "adservice:adservice:Dockerfile"
        "cartservice:cartservice/src:Dockerfile"
        "checkoutservice:checkoutservice:Dockerfile"
        "currencyservice:currencyservice:Dockerfile"
        "emailservice:emailservice:Dockerfile"
        "frontend:frontend:Dockerfile"
        "loadgenerator:loadgenerator:Dockerfile"
        "paymentservice:paymentservice:Dockerfile"
        "productcatalogservice:productcatalogservice:Dockerfile"
        "recommendationservice:recommendationservice:Dockerfile"
        "shippingservice:shippingservice:Dockerfile"
        "shoppingassistantservice:shoppingassistantservice:Dockerfile"
    )
    
    # Track build results
    local success_count=0
    local failure_count=0
    local failed_services=()
    
    # Build each service
    for service_info in "${services[@]}"; do
        IFS=':' read -r service_name service_path dockerfile_name <<< "$service_info"
        dockerfile_path="$service_path/$dockerfile_name"
        
        echo
        print_status "Building service: $service_name"
        print_status "Path: $service_path"
        print_status "Dockerfile: $dockerfile_path"
        
        if build_service "$service_name" "$service_path" "$dockerfile_path"; then
            ((success_count++))
        else
            ((failure_count++))
            failed_services+=("$service_name")
        fi
        
        echo "----------------------------------------"
    done
    
    # Print summary
    echo
    print_status "🏁 Build Summary"
    print_status "=================="
    print_success "Successfully built: $success_count services"
    
    if [ $failure_count -gt 0 ]; then
        print_error "Failed to build: $failure_count services"
        print_error "Failed services: ${failed_services[*]}"
        echo
        print_warning "Some services failed to build. Check the error messages above."
        print_warning "Common issues:"
        print_warning "  - Missing dependencies"
        print_warning "  - Dockerfile syntax errors"
        print_warning "  - Build context issues"
        print_warning "  - Network connectivity problems"
    else
        print_success "All services built successfully! 🎉"
    fi
    
    echo
    print_status "📋 Built Services:"
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | grep -E "(adservice|cartservice|checkoutservice|currencyservice|emailservice|frontend|loadgenerator|paymentservice|productcatalogservice|recommendationservice|shippingservice|shoppingassistantservice)" || true
    
    echo
    print_status "🚀 Next Steps:"
    print_status "1. Test individual services: docker run -p <port>:<port> <service-name>"
    print_status "2. Create a Docker Compose file for orchestration"
    print_status "3. Set up service networking and communication"
    print_status "4. Implement health checks and monitoring"
    
    # Exit with appropriate code
    if [ $failure_count -gt 0 ]; then
        exit 1
    else
        exit 0
    fi
}

# Run main function
main "$@"
