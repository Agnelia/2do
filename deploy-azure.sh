#!/bin/bash

# Azure Static Web App Deployment Script for 2do Health Reminders
# This script helps set up Azure Static Web Apps for both test and production environments

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

print_usage() {
    print_color $BLUE "Azure Static Web App Deployment Script"
    echo ""
    print_color $YELLOW "Usage: $0 [command] [environment]"
    echo ""
    print_color $GREEN "Commands:"
    echo "  setup      Set up Azure resources for the specified environment"
    echo "  deploy     Deploy the application to the specified environment"
    echo "  info       Show deployment information"
    echo "  help       Show this help message"
    echo ""
    print_color $GREEN "Environments:"
    echo "  test       Test environment"
    echo "  prod       Production environment"
    echo ""
    print_color $YELLOW "Examples:"
    echo "  $0 setup test"
    echo "  $0 deploy prod"
    echo "  $0 info test"
}

check_prerequisites() {
    print_color $BLUE "Checking prerequisites..."
    
    # Check if Azure CLI is installed
    if ! command -v az &> /dev/null; then
        print_color $RED "Azure CLI is not installed. Please install it first:"
        print_color $YELLOW "https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
        exit 1
    fi
    
    # Check if Flutter is installed
    if ! command -v flutter &> /dev/null; then
        print_color $RED "Flutter is not installed. Please install it first:"
        print_color $YELLOW "https://flutter.dev/docs/get-started/install"
        exit 1
    fi
    
    print_color $GREEN "Prerequisites check passed!"
}

login_azure() {
    print_color $BLUE "Checking Azure login status..."
    
    if ! az account show &> /dev/null; then
        print_color $YELLOW "Please log in to Azure..."
        az login
    fi
    
    print_color $GREEN "Azure login verified!"
}

setup_environment() {
    local env=$1
    local config_file="azure-config/${env}/config.json"
    
    if [ ! -f "$config_file" ]; then
        print_color $RED "Configuration file not found: $config_file"
        exit 1
    fi
    
    print_color $BLUE "Setting up Azure Static Web App for $env environment..."
    
    # Read configuration
    local app_name=$(jq -r '.deployment.azure_static_web_app_name' "$config_file")
    local resource_group=$(jq -r '.deployment.resource_group' "$config_file")
    local location=$(jq -r '.deployment.location' "$config_file")
    
    print_color $YELLOW "Configuration:"
    print_color $YELLOW "  App Name: $app_name"
    print_color $YELLOW "  Resource Group: $resource_group"
    print_color $YELLOW "  Location: $location"
    
    # Create resource group if it doesn't exist
    print_color $BLUE "Creating resource group $resource_group..."
    az group create --name "$resource_group" --location "$location" --output table
    
    # Create Static Web App
    print_color $BLUE "Creating Static Web App $app_name..."
    az staticwebapp create \
        --name "$app_name" \
        --resource-group "$resource_group" \
        --source "https://github.com/Agnelia/2do" \
        --location "$location" \
        --branch "main" \
        --app-location "build/web" \
        --output table
    
    # Get deployment token
    print_color $BLUE "Getting deployment token..."
    local deployment_token=$(az staticwebapp secrets list --name "$app_name" --resource-group "$resource_group" --query "properties.apiKey" --output tsv)
    
    print_color $GREEN "Setup completed successfully!"
    print_color $YELLOW "Please add the following secret to your GitHub repository:"
    print_color $YELLOW "Secret name: AZURE_STATIC_WEB_APPS_API_TOKEN_$(echo $env | tr '[:lower:]' '[:upper:]')"
    print_color $YELLOW "Secret value: $deployment_token"
}

deploy_application() {
    local env=$1
    local config_file="azure-config/${env}/config.json"
    
    if [ ! -f "$config_file" ]; then
        print_color $RED "Configuration file not found: $config_file"
        exit 1
    fi
    
    print_color $BLUE "Deploying to $env environment..."
    
    # Install dependencies
    print_color $BLUE "Installing Flutter dependencies..."
    flutter pub get
    
    # Run tests
    print_color $BLUE "Running tests..."
    flutter test
    
    # Build application
    print_color $BLUE "Building Flutter web application..."
    if [ "$env" = "prod" ]; then
        flutter build web --release --dart-define=ENVIRONMENT=prod
    else
        flutter build web --release --dart-define=ENVIRONMENT=test
    fi
    
    # Copy static web app configuration
    print_color $BLUE "Copying Static Web App configuration..."
    cp "azure-config/${env}/staticwebapp.config.json" "build/web/"
    
    print_color $GREEN "Build completed! The application is ready for deployment."
    print_color $YELLOW "Use GitHub Actions to deploy or manually upload the build/web folder."
}

show_info() {
    local env=$1
    local config_file="azure-config/${env}/config.json"
    
    if [ ! -f "$config_file" ]; then
        print_color $RED "Configuration file not found: $config_file"
        exit 1
    fi
    
    print_color $BLUE "Deployment Information for $env environment:"
    print_color $GREEN "$(jq -r '.name' "$config_file")"
    print_color $YELLOW "Description: $(jq -r '.description' "$config_file")"
    print_color $YELLOW "Environment: $(jq -r '.environment' "$config_file")"
    print_color $YELLOW "Site URL: $(jq -r '.app_settings.SITE_URL' "$config_file")"
    print_color $YELLOW "App Name: $(jq -r '.deployment.azure_static_web_app_name' "$config_file")"
    print_color $YELLOW "Resource Group: $(jq -r '.deployment.resource_group' "$config_file")"
    print_color $YELLOW "Location: $(jq -r '.deployment.location' "$config_file")"
}

# Main script logic
if [ $# -eq 0 ]; then
    print_usage
    exit 1
fi

command=$1
environment=$2

case $command in
    "setup")
        if [ -z "$environment" ]; then
            print_color $RED "Environment is required for setup command"
            print_usage
            exit 1
        fi
        check_prerequisites
        login_azure
        setup_environment "$environment"
        ;;
    "deploy")
        if [ -z "$environment" ]; then
            print_color $RED "Environment is required for deploy command"
            print_usage
            exit 1
        fi
        check_prerequisites
        deploy_application "$environment"
        ;;
    "info")
        if [ -z "$environment" ]; then
            print_color $RED "Environment is required for info command"
            print_usage
            exit 1
        fi
        show_info "$environment"
        ;;
    "help")
        print_usage
        ;;
    *)
        print_color $RED "Unknown command: $command"
        print_usage
        exit 1
        ;;
esac