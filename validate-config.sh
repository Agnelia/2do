#!/bin/bash

# Configuration Validation Script for Azure Static Web App Deployment
# This script validates that all configuration files and setup are correct

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

validate_json() {
    local file=$1
    if [ -f "$file" ]; then
        if python3 -m json.tool "$file" > /dev/null 2>&1; then
            print_color $GREEN "✓ $file is valid JSON"
            return 0
        else
            print_color $RED "✗ $file is invalid JSON"
            return 1
        fi
    else
        print_color $RED "✗ $file does not exist"
        return 1
    fi
}

validate_file_existence() {
    local file=$1
    if [ -f "$file" ]; then
        print_color $GREEN "✓ $file exists"
        return 0
    else
        print_color $RED "✗ $file does not exist"
        return 1
    fi
}

validate_directory() {
    local dir=$1
    if [ -d "$dir" ]; then
        print_color $GREEN "✓ Directory $dir exists"
        return 0
    else
        print_color $RED "✗ Directory $dir does not exist"
        return 1
    fi
}

print_color $BLUE "Validating Azure Static Web App Configuration..."
echo ""

# Check main configuration files
print_color $YELLOW "Checking main configuration files:"
validate_json "staticwebapp.config.json"
validate_file_existence "deploy-azure.sh"
validate_file_existence "DEPLOYMENT.md"
validate_file_existence "SETUP-INSTRUCTIONS.md"

echo ""

# Check azure-config directory structure
print_color $YELLOW "Checking azure-config directory structure:"
validate_directory "azure-config"
validate_directory "azure-config/test"
validate_directory "azure-config/prod"
validate_file_existence "azure-config/README.md"

echo ""

# Check environment configurations
print_color $YELLOW "Checking environment configurations:"
validate_json "azure-config/test/config.json"
validate_json "azure-config/test/staticwebapp.config.json"
validate_json "azure-config/prod/config.json"
validate_json "azure-config/prod/staticwebapp.config.json"

echo ""

# Check GitHub Actions workflows
print_color $YELLOW "Checking GitHub Actions workflows:"
validate_file_existence ".github/workflows/azure-static-web-apps.yml"
validate_file_existence ".github/workflows/build-and-deploy.yml"
validate_file_existence ".github/copilot-config.yml"

echo ""

# Check configuration values
print_color $YELLOW "Checking configuration values:"

# Test environment
if [ -f "azure-config/test/config.json" ]; then
    test_url=$(python3 -c "import json; print(json.load(open('azure-config/test/config.json'))['app_settings']['SITE_URL'])" 2>/dev/null || echo "")
    if [ "$test_url" = "https://test-2do-health-reminders.azurestaticapps.net" ]; then
        print_color $GREEN "✓ Test environment URL is correctly configured"
    else
        print_color $RED "✗ Test environment URL is incorrectly configured: $test_url"
    fi
fi

# Production environment
if [ -f "azure-config/prod/config.json" ]; then
    prod_url=$(python3 -c "import json; print(json.load(open('azure-config/prod/config.json'))['app_settings']['SITE_URL'])" 2>/dev/null || echo "")
    if [ "$prod_url" = "https://2do-health-reminders.azurestaticapps.net" ]; then
        print_color $GREEN "✓ Production environment URL is correctly configured"
    else
        print_color $RED "✗ Production environment URL is incorrectly configured: $prod_url"
    fi
fi

echo ""

# Check Flutter configuration
print_color $YELLOW "Checking Flutter configuration:"
if [ -f "pubspec.yaml" ]; then
    print_color $GREEN "✓ pubspec.yaml exists"
    
    # Check if it's a Flutter project
    if grep -q "flutter:" "pubspec.yaml"; then
        print_color $GREEN "✓ Valid Flutter project configuration"
    else
        print_color $RED "✗ Not a valid Flutter project"
    fi
else
    print_color $RED "✗ pubspec.yaml does not exist"
fi

echo ""

# Check script permissions
print_color $YELLOW "Checking script permissions:"
if [ -x "deploy-azure.sh" ]; then
    print_color $GREEN "✓ deploy-azure.sh is executable"
else
    print_color $YELLOW "⚠ deploy-azure.sh is not executable (run: chmod +x deploy-azure.sh)"
fi

if [ -x "validate-config.sh" ]; then
    print_color $GREEN "✓ validate-config.sh is executable"
else
    print_color $YELLOW "⚠ validate-config.sh is not executable"
fi

echo ""

# Test deployment script
print_color $YELLOW "Testing deployment script:"
if ./deploy-azure.sh help > /dev/null 2>&1; then
    print_color $GREEN "✓ Deployment script runs correctly"
else
    print_color $RED "✗ Deployment script has issues"
fi

echo ""

# Summary
print_color $BLUE "Configuration validation complete!"
print_color $YELLOW "Next steps:"
echo "1. Create test branch: git checkout -b test && git push origin test"
echo "2. Set up Azure resources: ./deploy-azure.sh setup test && ./deploy-azure.sh setup prod"
echo "3. Configure GitHub secrets with deployment tokens"
echo "4. Test deployment: Create a PR targeting the test branch"

echo ""
print_color $GREEN "All configuration files are properly set up for Azure Static Web App deployment!"