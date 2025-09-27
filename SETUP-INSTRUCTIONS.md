# Setup Instructions for Azure Static Web App Deployment

This document provides step-by-step instructions for setting up the Azure Static Web App deployment configuration for the 2do Health Reminders project.

## Prerequisites Checklist

- [ ] Azure subscription with sufficient permissions
- [ ] GitHub repository with admin access
- [ ] Azure CLI installed locally
- [ ] Flutter SDK 3.24.0 or higher

## 1. Create Test Branch

Since Copilot PRs should target the test branch, you need to create it:

```bash
# Clone the repository (if not already done)
git clone https://github.com/Agnelia/2do.git
cd 2do

# Create and push test branch from main
git checkout main
git checkout -b test
git push origin test
```

## 2. Configure Copilot Branch Targeting (Manual Setup Required)

**Important**: The Copilot integration requires manual configuration - it's not automatically applied by the configuration files.

To ensure Copilot creates PRs targeting the test branch, choose one of these approaches:

### Option A: Change Repository Default Branch (Recommended)
1. Go to GitHub repository settings
2. Navigate to "General" → "Default branch"
3. Change default branch from `main` to `test`
4. This will make all new PRs (including Copilot PRs) target `test` by default

### Option B: Configure Branch Protection Rules
1. Go to GitHub repository settings
2. Navigate to "Branches" → "Branch protection rules"
3. Set up rules that encourage PR creation to target `test` branch
4. Configure `main` branch to require PRs from `test` branch

### Option C: Organization/Team Copilot Policies
If you have GitHub Copilot for Business, configure organization-level policies to set default branch targeting.

**Note**: The `.github/copilot-config.yml` file is documentation/reference only - it doesn't automatically configure Copilot behavior.

## 3. Azure Resources Setup

Run the deployment script to create Azure resources:

```bash
# Make script executable
chmod +x deploy-azure.sh

# Setup test environment
./deploy-azure.sh setup test

# Setup production environment  
./deploy-azure.sh setup prod
```

**Important**: Save the deployment tokens provided by the script output.

## 4. Configure GitHub Secrets

Add these secrets to your GitHub repository (Settings → Secrets and variables → Actions):

| Secret Name | Value | Source |
|-------------|-------|---------|
| `AZURE_STATIC_WEB_APPS_API_TOKEN_TEST` | Token from test setup | Azure CLI output |
| `AZURE_STATIC_WEB_APPS_API_TOKEN_PROD` | Token from prod setup | Azure CLI output |

## 5. Verify Configuration

Check that all files are properly configured:

```bash
# Test deployment script
./deploy-azure.sh info test
./deploy-azure.sh info prod

# Validate JSON files
python3 -m json.tool staticwebapp.config.json
python3 -m json.tool azure-config/test/config.json
python3 -m json.tool azure-config/prod/config.json
```

## 6. Test Deployment

### Automatic Testing
1. Create a test pull request targeting the `test` branch
2. Verify GitHub Actions workflow runs successfully
3. Check deployment in Azure portal

### Manual Testing
```bash
# Test build locally
./deploy-azure.sh deploy test
```

## 7. Repository Configuration

### Branch Protection (Recommended)
Set up branch protection rules:

**For `main` branch:**
- Require PR reviews
- Require status checks (tests, build)
- Restrict pushes to admins only

**For `test` branch:**
- Allow direct pushes for testing
- Require status checks
- Auto-delete head branches

### Webhook Configuration
GitHub Actions will automatically trigger on:
- Push to `main` or `test` branches
- PRs opened/updated to `main` or `test` branches

## 8. Environment URLs

After successful deployment:
- **Test Environment**: https://test-2do-health-reminders.azurestaticapps.net
- **Production Environment**: https://2do-health-reminders.azurestaticapps.net

## 9. Workflow Verification

Expected workflow behavior:
- **Copilot PRs** → Target `test` branch → Deploy to test environment
- **Feature PRs** → Target `test` branch → Deploy to test environment  
- **Release PRs** → Target `main` branch → Deploy to production
- **Hotfix PRs** → Target `main` branch → Deploy to production

## 10. Monitoring Setup

1. **Azure Monitor**: Set up alerts for deployment failures
2. **GitHub Notifications**: Enable workflow notifications
3. **Application Insights**: Configure for production monitoring

## Troubleshooting

### Common Issues

1. **Authentication Errors**
   - Verify GitHub secrets are correctly set
   - Regenerate Azure deployment tokens if needed

2. **Build Failures**
   - Check Flutter version in workflows matches local version
   - Verify all dependencies are specified in pubspec.yaml

3. **Deployment Failures**
   - Check Azure Static Web App configuration
   - Verify resource group and app names match

### Getting Help

1. Check `DEPLOYMENT.md` for detailed deployment information
2. Review GitHub Actions logs for specific error messages
3. Use Azure portal diagnostics for deployment issues
4. Run `./deploy-azure.sh info [environment]` for quick status check

## Security Notes

- Keep Azure deployment tokens secure
- Use environment-specific configurations
- Enable Azure security features in production
- Regularly rotate deployment tokens

## Next Steps

After completing setup:
1. Test the deployment pipeline end-to-end
2. Configure custom domain (optional)
3. Set up monitoring and alerting
4. Document team deployment processes
5. Train team on new deployment workflow

---

**Note**: This setup creates separate environments for testing and production, ensuring proper CI/CD practices and reducing risk of production issues.