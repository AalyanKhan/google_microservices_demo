#!/bin/bash

# Google Microservices Demo - Build All Services Script
# This script builds all microservices in the project for Docker learning

# Removed set -e to allow script to continue even if individual builds fail

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
    
    # Build the Docker image with account tag
    local full_image_name="$DOCKER_ACCOUNT_TAG/$service_name"
    print_status "Building Docker image: $full_image_name"
    
    # Use --no-cache to ensure fresh builds and --progress=plain for better output
    if docker build --no-cache --progress=plain -t "$full_image_name" -f "$dockerfile_path" "$service_path"; then
        print_success "$service_name built successfully as $full_image_name!"
        
        # Verify the image was created
        if docker images "$full_image_name" --format "{{.Repository}}:{{.Tag}}" | grep -q "$full_image_name"; then
            print_success "Image verification successful: $full_image_name"
        else
            print_error "Image verification failed: $full_image_name not found!"
            return 1
        fi
    else
        print_error "Failed to build $service_name!"
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

# Main execution
main() {
    print_status "🐳 Google Microservices Demo - Building All Services"
    print_status "=================================================="
    
    # Check if Docker is running
    check_docker
    
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
    
    # Build each service sequentially (one after another)
    local total_services=${#services[@]}
    local current_service=0
    
    for service_info in "${services[@]}"; do
        IFS=':' read -r service_name service_path dockerfile_name <<< "$service_info"
        dockerfile_path="$service_path/$dockerfile_name"
        ((current_service++))
        
        echo
        print_status "Building service: $service_name ($current_service/$total_services)"
        print_status "Path: $service_path"
        print_status "Dockerfile: $dockerfile_path"
        print_status "⏳ Starting build process..."
        
        # Record start time
        local start_time=$(date +%s)
        
        if build_service "$service_name" "$service_path" "$dockerfile_path"; then
            ((success_count++))
            local end_time=$(date +%s)
            local duration=$((end_time - start_time))
            print_success "$service_name completed successfully in ${duration}s!"
        else
            ((failure_count++))
            failed_services+=("$service_name")
            local end_time=$(date +%s)
            local duration=$((end_time - start_time))
            print_error "$service_name failed after ${duration}s!"
        fi
        
        echo "----------------------------------------"
        
        # Show progress
        print_status "Progress: $current_service/$total_services services completed"
        if [ $current_service -lt $total_services ]; then
            print_status "⏳ Preparing for next build..."
            # Small delay to ensure Docker resources are cleaned up
            sleep 2
        fi
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
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | grep "$DOCKER_ACCOUNT_TAG" || true
    
    echo
    print_status "🚀 Next Steps:"
    print_status "1. Test individual services: docker run -p <port>:<port> $DOCKER_ACCOUNT_TAG/<service-name>"
    print_status "2. Push images to Docker Hub: ./push-all.sh"
    print_status "3. Create a Docker Compose file for orchestration"
    print_status "4. Set up service networking and communication"
    print_status "5. Implement health checks and monitoring"
    
    # Exit with appropriate code
    if [ $failure_count -gt 0 ]; then
        exit 1
    else
        exit 0
    fi
}

# Run main function
main "$@"
