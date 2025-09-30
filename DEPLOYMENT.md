# Azure Static Web App Deployment Guide

This document describes how to deploy the 2do Health Reminders application to Azure Static Web Apps.

## Overview

The application is configured for deployment to two environments:
- **Test Environment**: Deployed from the `test` branch
- **Production Environment**: Deployed from the `main` branch

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   GitHub Repo   │    │  GitHub Actions │    │  Azure Static   │
│                 │    │                 │    │   Web Apps      │
│  ┌───────────┐  │    │  ┌───────────┐  │    │                 │
│  │Main Branch│──┼────┼──│Prod Deploy│──┼────┼──► Production    │
│  └───────────┘  │    │  └───────────┘  │    │                 │
│                 │    │                 │    │                 │
│  ┌───────────┐  │    │  ┌───────────┐  │    │                 │
│  │Test Branch│──┼────┼──│Test Deploy│──┼────┼──► Test          │
│  └───────────┘  │    │  └───────────┘  │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Configuration Structure

```
├── azure-config/                    # Azure deployment configurations
│   ├── README.md                   # Configuration documentation
│   ├── test/                       # Test environment config
│   │   ├── config.json            # Test environment settings
│   │   └── staticwebapp.config.json # Test Azure SWA config
│   └── prod/                       # Production environment config
│       ├── config.json            # Production environment settings
│       └── staticwebapp.config.json # Production Azure SWA config
├── staticwebapp.config.json         # Root Azure SWA config
├── deploy-azure.sh                  # Deployment helper script
└── .github/
    ├── workflows/
    │   ├── azure-static-web-apps.yml # Azure deployment workflow
    │   └── build-and-deploy.yml     # Updated main workflow
    └── copilot-config.yml           # Copilot configuration
```

## Prerequisites

1. **Azure Subscription**: You need an active Azure subscription
2. **Azure CLI**: Install Azure CLI for local management
3. **Flutter SDK**: Version 3.24.0 or higher
4. **GitHub Repository**: With appropriate secrets configured

## Setup Instructions

### 1. Azure Resources Setup

**Who should run this:** Repository owner or team member with Azure subscription admin permissions  
**Where to run:** Locally on your machine from the repository root directory  
**Prerequisites:** Azure CLI installed and logged in to Azure

Use the provided deployment script to set up Azure resources:

```bash
# Navigate to repository directory
cd /path/to/your/2do/repository

# Log in to Azure (if not already logged in)
az login

# Setup test environment
./deploy-azure.sh setup test

# Setup production environment
./deploy-azure.sh setup prod
```

This will:
- Create Azure Resource Groups
- Create Azure Static Web Apps
- Generate deployment tokens (save these for GitHub secrets)

### 2. GitHub Secrets Configuration

Add the following secrets to your GitHub repository:

| Secret Name | Description | Source |
|-------------|-------------|---------|
| `AZURE_STATIC_WEB_APPS_API_TOKEN_TEST` | Test environment deployment token | Azure CLI output |
| `AZURE_STATIC_WEB_APPS_API_TOKEN_PROD` | Production environment deployment token | Azure CLI output |

To add secrets:
1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add each secret with the appropriate name and value

### 3. Branch Structure

Ensure your repository has the following branches:
- `main`: Production branch
- `test`: Test branch (for Copilot PRs and testing)

Create the test branch if it doesn't exist:
```bash
git checkout -b test
git push origin test
```

## Deployment Process

### Automatic Deployment

The deployment happens automatically via GitHub Actions when:

**Test Environment:**
- Push to `test` branch
- Pull request opened/updated targeting `test` branch

**Production Environment:**
- Push to `main` branch  
- Pull request opened/updated targeting `main` branch

### Manual Deployment

You can also deploy manually using the deployment script:

```bash
# Deploy to test environment
./deploy-azure.sh deploy test

# Deploy to production environment
./deploy-azure.sh deploy prod
```

## Environment Configuration

### Test Environment
- **URL**: https://test-2do-health-reminders.azurestaticapps.net
- **Branch**: `test`
- **Debug Mode**: Enabled (`ENABLE_DEBUG: "true"`)
- **Cache Policy**: No cache (for testing)

### Production Environment
- **URL**: https://2do-health-reminders.azurestaticapps.net
- **Branch**: `main`
- **Debug Mode**: Disabled (`ENABLE_DEBUG: "false"`)
- **Cache Policy**: 1 hour cache

## Copilot Integration

The repository includes configuration guidance for GitHub Copilot to target the `test` branch for pull requests. **Note: This requires manual setup by the repository owner.**

### How Copilot Integration Works:

1. **Manual Configuration Required**: The `.github/copilot-config.yml` file is a reference configuration that documents the intended branch targeting strategy, but GitHub Copilot's branch targeting must be configured manually through:
   - Repository default branch settings
   - Branch protection rules
   - Team/organization Copilot policies

2. **Intended Workflow**:
   - Copilot-generated PRs → Target `test` branch → Deploy to test environment
   - Manual review and testing in test environment
   - After approval, changes can be merged to `main` for production deployment

3. **Benefits**:
   - Copilot changes are tested in the test environment first
   - Production stability is maintained through staged deployments
   - Proper review process for production deployments

**Implementation Steps**: See `SETUP-INSTRUCTIONS.md` section "Set Default Branch for Copilot" for manual configuration steps.

## Monitoring and Troubleshooting

### Viewing Deployment Status

1. **GitHub Actions**: Check the Actions tab in your repository
2. **Azure Portal**: Monitor in the Azure Static Web Apps section
3. **Deployment Script**: Use `./deploy-azure.sh info [environment]` for quick status

### Common Issues

1. **Deployment Token Issues**
   - Verify secrets are correctly set in GitHub
   - Regenerate tokens if needed using Azure CLI

2. **Build Failures**
   - Check Flutter version compatibility
   - Ensure all dependencies are available
   - Review test failures in GitHub Actions

3. **Routing Issues**
   - Verify `staticwebapp.config.json` is copied to build output
   - Check navigation fallback configuration

### Logs and Diagnostics

- **GitHub Actions Logs**: Available in the Actions tab
- **Azure Logs**: Available in Azure Portal → Static Web Apps → Functions
- **Flutter Build Logs**: Check the build step in GitHub Actions

## Site URLs

After successful deployment, your applications will be available at:

- **Test**: https://test-2do-health-reminders.azurestaticapps.net
- **Production**: https://2do-health-reminders.azurestaticapps.net

## Security Considerations

- Deployment tokens are stored as GitHub secrets
- Environment-specific configurations prevent cross-environment issues
- Production deployments require code review through pull requests
- Test environment has relaxed security for debugging

## Maintenance

### Updating Configuration

1. Modify configuration files in `azure-config/`
2. Test changes in the test environment first
3. Deploy to production after validation

### Scaling

Azure Static Web Apps automatically scale based on demand. No manual intervention required for scaling.

### Backup

- Code is backed up in GitHub repository
- Azure automatically maintains deployment history
- Configuration files are version controlled

## Support

For deployment issues:
1. Check this documentation
2. Review GitHub Actions logs
3. Use the deployment script's info command
4. Contact the development team

---

**Note**: Ensure all secrets are properly configured before attempting deployment. Test deployments should always be validated in the test environment before promoting to production.