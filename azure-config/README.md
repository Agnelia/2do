# Azure Static Web App Configuration Directory

This directory contains environment-specific configuration for Azure Static Web App deployments.

## Environments

- `test/` - Test environment configuration
- `prod/` - Production environment configuration

Each environment contains:
- `config.json` - Environment-specific settings including build commands, Azure resource names, and application settings
- `staticwebapp.config.json` - Azure Static Web App routing configuration

## Configuration Explanation

### Application Settings
The `app_settings` in each `config.json` file define environment variables that can be used by the Flutter application:

- **ENVIRONMENT**: Identifies the deployment environment (`test` or `prod`)
- **API_BASE_URL**: Base URL for API calls (environment-specific endpoints)
- **SITE_URL**: The URL where the application will be deployed
- **ENABLE_DEBUG**: Controls debug mode features in the application