#!/bin/bash
# optimize-all.sh - Automatically slim all microservices
# Usage: ./optimize-all.sh

set -e

# Colors for readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

USERNAME="aalyankhan029"  # 👈 Update this to your Docker Hub username
SERVICES=(
  adservice
  cartservice
  checkoutservice
  currencyservice
  emailservice
  frontend
  loadgenerator
  paymentservice
  productcatalogservice
  recommendationservice
  shippingservice
)

echo -e "${BLUE}🚀 Starting full optimization pipeline for ${#SERVICES[@]} services...${NC}"
echo -e "${BLUE}📦 Docker Hub username: ${USERNAME}${NC}"
echo

# Check if slimify.sh exists and is executable
if [ ! -f "./slimify.sh" ]; then
  echo -e "${RED}❌ Error: slimify.sh not found in current directory${NC}"
  exit 1
fi

if [ ! -x "./slimify.sh" ]; then
  echo -e "${YELLOW}⚠️  Making slimify.sh executable...${NC}"
  chmod +x ./slimify.sh
fi

# Track success/failure counts
SUCCESS_COUNT=0
FAILURE_COUNT=0
FAILED_SERVICES=()

for service in "${SERVICES[@]}"; do
  echo
  echo -e "${BLUE}========================================${NC}"
  echo -e "${BLUE}🔧 Optimizing: ${service}${NC}"
  echo -e "${BLUE}========================================${NC}"

  SOURCE="${USERNAME}/${service}:latest"
  TARGET="${USERNAME}/${service}-slim:latest"

  # Ensure source image exists locally
  if ! docker image inspect "$SOURCE" > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Source image not found. Building first...${NC}"
    echo -e "${BLUE}🔨 Building ${service}...${NC}"
    
    # Try to build from service directory
    if [ -d "./${service}" ]; then
      (cd "$service" && docker build -t "$SOURCE" .)
    else
      echo -e "${RED}❌ Service directory ./${service} not found. Skipping...${NC}"
      FAILURE_COUNT=$((FAILURE_COUNT + 1))
      FAILED_SERVICES+=("$service")
      continue
    fi
  fi

  # Run slimify
  echo -e "${BLUE}🎯 Running DockerSlim optimization...${NC}"
  if ./slimify.sh "$SOURCE" "$TARGET"; then
    echo -e "${GREEN}✅ Successfully optimized ${service}${NC}"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
  else
    echo -e "${RED}❌ Failed to optimize ${service}${NC}"
    FAILURE_COUNT=$((FAILURE_COUNT + 1))
    FAILED_SERVICES+=("$service")
  fi
done

echo
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}📊 OPTIMIZATION SUMMARY${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✅ Successful: ${SUCCESS_COUNT}${NC}"
echo -e "${RED}❌ Failed: ${FAILURE_COUNT}${NC}"

if [ ${#FAILED_SERVICES[@]} -gt 0 ]; then
  echo -e "${RED}Failed services: ${FAILED_SERVICES[*]}${NC}"
fi

echo
echo -e "${BLUE}📦 Final optimized images:${NC}"
docker images | grep "$USERNAME" | grep "\-slim" || echo -e "${YELLOW}No slim images found${NC}"

echo
if [ $FAILURE_COUNT -eq 0 ]; then
  echo -e "${GREEN}🎉 All services optimized successfully!${NC}"
else
  echo -e "${YELLOW}⚠️  Some services failed optimization. Check the output above for details.${NC}"
fi

echo
echo -e "${BLUE}💡 Next steps:${NC}"
echo -e "${BLUE}   • Push slim images: docker push ${USERNAME}/<service>-slim:latest${NC}"
echo -e "${BLUE}   • Update docker-compose.yml to use slim images${NC}"
echo -e "${BLUE}   • Test your optimized microservices${NC}"
