# Setup Instructions for Azure Static Web App Deployment

This document provides step-by-step instructions for setting up the Azure Static Web App deployment configuration for the 2do Health Reminders project.

## Prerequisites Checklist

- [ ] Azure subscription with sufficient permissions (Owner or Contributor role)
- [ ] GitHub repository with admin access (to add secrets)
- [ ] Azure CLI installed locally on your machine
- [ ] Flutter SDK 3.24.0 or higher (for local testing)

## Roles and Permissions

**Repository Owner/Admin**: Must perform steps 3-4 (Azure setup and GitHub secrets)  
**Developers**: Can perform steps 1-2 and 5+ (branch creation and testing)  
**Azure Admin**: Must have Owner or Contributor role on Azure subscription

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

**Who:** Repository owner or team member with Azure subscription admin permissions  
**Where:** Run locally on your machine from the repository root directory  
**Prerequisites:** Azure CLI must be installed and you must be logged in to Azure

### Setup Steps:

1. **Open terminal/command prompt on your local machine**

2. **Navigate to the repository directory:**
   ```bash
   cd /path/to/your/cloned/2do/repository
   ```

3. **Log in to Azure CLI (if not already logged in):**
   ```bash
   az login
   ```
   This will open a browser window for authentication. Make sure you log in with an account that has Owner or Contributor permissions on your Azure subscription.

4. **Verify your Azure subscription:**
   ```bash
   az account show
   ```
   Ensure you're logged in to the correct subscription where you want to create the resources.

5. **Make the deployment script executable:**
   ```bash
   chmod +x deploy-azure.sh
   ```

6. **Run the Azure resource setup commands:**
   ```bash
   # Setup test environment
   ./deploy-azure.sh setup test
   
   # Setup production environment  
   ./deploy-azure.sh setup prod
   ```

**What these commands do:**
- Create Azure Resource Groups (`rg-2do-test` and `rg-2do-prod`)
- Create Azure Static Web Apps (`2do-health-reminders-test` and `2do-health-reminders-prod`)
- Generate deployment tokens for GitHub Actions

**Important**: Save the deployment tokens provided by the script output - you'll need them for GitHub secrets configuration.

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

**Summary of who does what:**
- **Repository Owner/Azure Admin**: Steps 3-4 (Azure setup, GitHub secrets)
- **Development Team**: Steps 1-2, 5+ (branch setup, testing, development)  
- **All Team Members**: Can use the deployment pipeline once setup is complete