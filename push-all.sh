#!/bin/bash

# Google Microservices Demo - Push All Services Script
# This script pushes all microservices Docker images to Docker Hub

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

# Function to push a service
push_service() {
    local service_name=$1
    local full_image_name="$DOCKER_ACCOUNT_TAG/$service_name"
    
    print_status "Pushing $full_image_name..."
    
    # Check if image exists locally
    if ! docker image inspect "$full_image_name" > /dev/null 2>&1; then
        print_error "Image $full_image_name not found locally!"
        print_warning "Make sure you have built the images first using ./build-all.sh"
        return 1
    fi
    
    # Push the Docker image
    if docker push "$full_image_name"; then
        print_success "$full_image_name pushed successfully!"
    else
        print_error "Failed to push $full_image_name!"
        return 1
    fi
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

# Function to check Docker Hub login
check_docker_login() {
    if ! docker info | grep -q "Username:"; then
        print_warning "You may not be logged in to Docker Hub."
        print_warning "Run 'docker login' to authenticate with Docker Hub."
        echo
        read -p "Do you want to continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_status "Please run 'docker login' first and then try again."
            exit 1
        fi
    else
        print_success "Docker Hub authentication verified"
    fi
}

# Main execution
main() {
    print_status "🚀 Google Microservices Demo - Pushing All Services"
    print_status "=================================================="
    
    # Check if Docker is running
    check_docker
    
    # Check Docker Hub login
    check_docker_login
    
    # Get the script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$SCRIPT_DIR"
    
    # Ask for Docker account tag
    echo
    print_status "Please enter your Docker Hub account tag (e.g., aalyankhan029):"
    read -p "Docker account tag: " DOCKER_ACCOUNT_TAG
    
    if [ -z "$DOCKER_ACCOUNT_TAG" ]; then
        print_error "Docker account tag cannot be empty!"
        exit 1
    fi
    
    print_success "Using Docker account tag: $DOCKER_ACCOUNT_TAG"
    echo
    
    print_status "Starting push process from: $SCRIPT_DIR"
    echo
    
    # Define all services
    declare -a services=(
        "adservice"
        "cartservice"
        "checkoutservice"
        "currencyservice"
        "emailservice"
        "frontend"
        "loadgenerator"
        "paymentservice"
        "productcatalogservice"
        "recommendationservice"
        "shippingservice"
        "shoppingassistantservice"
    )
    
    # Track push results
    local success_count=0
    local failure_count=0
    local failed_services=()
    
    # Push each service
    for service_name in "${services[@]}"; do
        echo
        print_status "Pushing service: $service_name"
        
        if push_service "$service_name"; then
            ((success_count++))
        else
            ((failure_count++))
            failed_services+=("$service_name")
        fi
        
        echo "----------------------------------------"
    done
    
    # Print summary
    echo
    print_status "🏁 Push Summary"
    print_status "=================="
    print_success "Successfully pushed: $success_count services"
    
    if [ $failure_count -gt 0 ]; then
        print_error "Failed to push: $failure_count services"
        print_error "Failed services: ${failed_services[*]}"
        echo
        print_warning "Some services failed to push. Check the error messages above."
        print_warning "Common issues:"
        print_warning "  - Not logged in to Docker Hub"
        print_warning "  - Network connectivity problems"
        print_warning "  - Image not found locally"
        print_warning "  - Permission issues with Docker Hub"
    else
        print_success "All services pushed successfully! 🎉"
    fi
    
    echo
    print_status "📋 Pushed Services:"
    print_status "You can now pull these images using:"
    for service_name in "${services[@]}"; do
        if [[ ! " ${failed_services[@]} " =~ " ${service_name} " ]]; then
            echo "  docker pull $DOCKER_ACCOUNT_TAG/$service_name"
        fi
    done
    
    echo
    print_status "🚀 Next Steps:"
    print_status "1. Verify images on Docker Hub: https://hub.docker.com/r/$DOCKER_ACCOUNT_TAG"
    print_status "2. Test pulling images: docker pull $DOCKER_ACCOUNT_TAG/<service-name>"
    print_status "3. Use images in Docker Compose or Kubernetes deployments"
    print_status "4. Set up automated builds with GitHub Actions or similar CI/CD"
    
    # Exit with appropriate code
    if [ $failure_count -gt 0 ]; then
        exit 1
    else
        exit 0
    fi
}

# Run main function
main "$@"
