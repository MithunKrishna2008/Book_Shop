# How to Add GitHub Actions Workflow Automatically

## ⚠️ Current Issue

Your Personal Access Token doesn't have the `workflow` scope, which is required to push workflow files via Git or API.

## ✅ Solution: Update Token Permissions (Recommended)

### Step 1: Update Your Token

1. Go to: https://github.com/settings/tokens
2. Find your token or click "Generate new token (classic)"
3. **IMPORTANT**: Check the `workflow` scope checkbox
4. Generate/Update the token
5. Copy the new token

### Step 2: Push the Workflow File

Once you have a token with `workflow` scope, run:

```bash
git checkout main
git add .github/workflows/ci-cd.yml
git commit -m "ci: Add GitHub Actions CI/CD workflow"
git push https://YOUR_NEW_TOKEN@github.com/MithunKrishna2008/Book_Shop.git main
```

## 🔄 Alternative: Quick Manual Add (2 Minutes)

If you prefer not to update the token, you can add it manually:

### Step 1: Go to Your Repository
Visit: https://github.com/MithunKrishna2008/Book_Shop

### Step 2: Create the File
1. Click **"Add file"** → **"Create new file"**
2. In the file path box, type: `.github/workflows/ci-cd.yml`
3. GitHub will automatically create the directory structure

### Step 3: Copy the Content

Copy the entire content below and paste it into the file editor:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches:
      - main
      - develop
  pull_request:
    branches:
      - main
      - develop

env:
  NODE_VERSION: '20.x'
  PNPM_VERSION: '8'

jobs:
  # Job 1: Install Dependencies
  install-dependencies:
    name: Install Dependencies
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'pnpm'
      
      - name: Install pnpm
        uses: pnpm/action-setup@v2
        with:
          version: ${{ env.PNPM_VERSION }}
      
      - name: Install dependencies
        run: pnpm install
      
      - name: Cache dependencies
        uses: actions/cache@v3
        with:
          path: |
            node_modules
            .next/cache
          key: ${{ runner.os }}-pnpm-${{ hashFiles('**/pnpm-lock.yaml') }}
          restore-keys: |
            ${{ runner.os }}-pnpm-

  # Job 2: Lint Code
  lint:
    name: Lint Code
    runs-on: ubuntu-latest
    needs: install-dependencies
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'pnpm'
      
      - name: Install pnpm
        uses: pnpm/action-setup@v2
        with:
          version: ${{ env.PNPM_VERSION }}
      
      - name: Install dependencies
        run: pnpm install
      
      - name: Run linter
        run: pnpm lint

  # Job 3: Build Application
  build:
    name: Build Application
    runs-on: ubuntu-latest
    needs: install-dependencies
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'pnpm'
      
      - name: Install pnpm
        uses: pnpm/action-setup@v2
        with:
          version: ${{ env.PNPM_VERSION }}
      
      - name: Install dependencies
        run: pnpm install
      
      - name: Build application
        run: pnpm build
        env:
          NODE_ENV: production
      
      - name: Upload build artifacts
        uses: actions/upload-artifact@v3
        with:
          name: build-files
          path: .next
          retention-days: 7

  # Job 4: Run Tests (if available)
  test:
    name: Run Tests
    runs-on: ubuntu-latest
    needs: install-dependencies
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'pnpm'
      
      - name: Install pnpm
        uses: pnpm/action-setup@v2
        with:
          version: ${{ env.PNPM_VERSION }}
      
      - name: Install dependencies
        run: pnpm install
      
      - name: Run tests
        run: echo "Tests would run here if test scripts were configured"
        continue-on-error: true

  # Job 5: Deploy to Production (only on main branch)
  deploy:
    name: Deploy to Production
    runs-on: ubuntu-latest
    needs: [lint, build]
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'pnpm'
      
      - name: Install pnpm
        uses: pnpm/action-setup@v2
        with:
          version: ${{ env.PNPM_VERSION }}
      
      - name: Install dependencies
        run: pnpm install
      
      - name: Build application
        run: pnpm build
        env:
          NODE_ENV: production
      
      - name: Deploy to server
        run: |
          echo "Deployment would happen here"
          echo "This could use SSH to connect to your Linux server"
          echo "and trigger the deployment script"
        # Uncomment and configure for actual deployment:
        # - name: Deploy via SSH
        #   uses: appleboy/ssh-action@master
        #   with:
        #     host: ${{ secrets.SERVER_HOST }}
        #     username: ${{ secrets.SERVER_USER }}
        #     key: ${{ secrets.SSH_PRIVATE_KEY }}
        #     script: |
        #       cd /var/www/book-shopping-website
        #       ./scripts/deploy.sh
```

### Step 4: Commit
1. Scroll down to the commit section
2. Commit message: `ci: Add GitHub Actions CI/CD workflow`
3. Click **"Commit new file"**

## ✅ Verify It Worked

1. Go to: https://github.com/MithunKrishna2008/Book_Shop
2. Click on the **"Actions"** tab
3. You should see the workflow file is now active
4. Make a small change and push to trigger the pipeline

## 🚀 After Adding the Workflow

The CI/CD pipeline will automatically run on:
- Every push to `main` or `develop` branches
- Every Pull Request to `main` or `develop` branches

You can see the pipeline status in the **"Actions"** tab of your repository.

