#!/bin/bash
# Usage: ./slimify.sh <source-image> <target-tag>
# Example: ./slimify.sh aalyankhan029/frontend:latest aalyankhan029/frontend-slim:latest

set -e

# Colors for readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SOURCE_IMAGE=$1
TARGET_TAG=$2

if [ -z "$SOURCE_IMAGE" ] || [ -z "$TARGET_TAG" ]; then
  echo -e "${YELLOW}Usage:${NC} ./slimify.sh <source-image> <target-tag>"
  exit 1
fi

echo -e "${GREEN}🚀 Starting Slim optimization for image:${NC} $SOURCE_IMAGE"
echo -e "${GREEN}🔖 Target optimized image tag:${NC} $TARGET_TAG"

# Run DockerSlim container (automation-friendly: removed -t flag)
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  dslim/slim build \
  --http-probe-off \
  --tag "$TARGET_TAG" \
  "$SOURCE_IMAGE"

echo -e "${GREEN}✅ Slim build complete!${NC}"
echo -e "${GREEN}📦 Original:${NC} $SOURCE_IMAGE"
echo -e "${GREEN}📦 Optimized:${NC} $TARGET_TAG"

# Optional: show before/after size comparison
echo -e "${YELLOW}--- Image sizes ---${NC}"
docker images | grep -E "$SOURCE_IMAGE|$TARGET_TAG"
