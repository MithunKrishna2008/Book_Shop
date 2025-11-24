# Git Workflow Guide

## Branching Strategy: Git Flow

### Branch Types

- **main**: Production-ready code
- **develop**: Integration branch for ongoing development
- **feature/***: New features
- **release/***: Release preparation
- **hotfix/***: Critical production fixes

## Common Workflows

### Creating a Feature

```bash
# Start from develop
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/new-feature

# Make changes and commit
git add .
git commit -m "feat: Add new feature"

# Push to remote
git push origin feature/new-feature
```

### Creating a Pull Request

1. Push feature branch to GitHub
2. Create Pull Request from `feature/new-feature` to `develop`
3. Wait for CI checks to pass
4. Get code review
5. Merge after approval

### Merging Feature Branch

**Option 1: Merge (preserves history)**
```bash
git checkout develop
git pull origin develop
git merge feature/new-feature
git push origin develop
```

**Option 2: Rebase (linear history)**
```bash
git checkout feature/new-feature
git rebase develop
git checkout develop
git merge feature/new-feature
git push origin develop
```

### Creating a Release

```bash
# Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v1.2.0

# Make release-specific changes (version bumps, etc.)
# Commit changes
git commit -m "chore: Bump version to 1.2.0"

# Merge to main and develop
git checkout main
git merge release/v1.2.0
git tag v1.2.0
git push origin main --tags

git checkout develop
git merge release/v1.2.0
git push origin develop
```

### Creating a Hotfix

```bash
# Create hotfix from main
git checkout main
git pull origin main
git checkout -b hotfix/critical-bug

# Fix the bug
git commit -m "fix: Critical security patch"

# Merge to main and develop
git checkout main
git merge hotfix/critical-bug
git tag v1.1.1
git push origin main --tags

git checkout develop
git merge hotfix/critical-bug
git push origin develop
```

## Git Commands Explained

### Rebase

**Purpose**: Replay commits on top of another branch for linear history.

```bash
# Interactive rebase (last 3 commits)
git rebase -i HEAD~3

# Rebase feature onto develop
git checkout feature/new-feature
git rebase develop
```

**When to use**:
- Before merging feature branches
- To clean up commit history
- To incorporate latest changes

**Benefits**:
- Clean, linear history
- Easier to read
- No unnecessary merge commits

### Fetch

**Purpose**: Download changes without merging.

```bash
# Fetch all branches
git fetch origin

# Fetch specific branch
git fetch origin develop

# See what changed
git log HEAD..origin/develop
```

**When to use**:
- Check for updates before pulling
- Inspect remote changes
- Update remote-tracking branches

**Benefits**:
- Safe operation
- Doesn't modify working directory
- Can be done frequently

### Merge

**Purpose**: Combine branches, preserving history.

```bash
# Merge feature into develop
git checkout develop
git merge feature/new-feature
```

**When to use**:
- Merging feature branches
- Preserving branch context
- Shared branches

**Benefits**:
- Complete history
- Shows branch relationships
- Safe for shared branches

## Commit Message Convention

Use conventional commits:

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting)
- `refactor:` Code refactoring
- `test:` Adding tests
- `chore:` Maintenance tasks

Example:
```bash
git commit -m "feat: Add user authentication"
git commit -m "fix: Resolve cart calculation bug"
git commit -m "docs: Update deployment guide"
```

## Useful Git Aliases

Add to `~/.gitconfig`:

```ini
[alias]
    co = checkout
    br = branch
    ci = commit
    st = status
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = !gitk
    lg = log --oneline --graph --decorate --all
```

## Troubleshooting

### Undo Last Commit (Keep Changes)
```bash
git reset --soft HEAD~1
```

### Undo Last Commit (Discard Changes)
```bash
git reset --hard HEAD~1
```

### Stash Changes
```bash
# Save changes
git stash

# Apply stashed changes
git stash pop

# List stashes
git stash list
```

### Resolve Merge Conflicts
```bash
# After merge conflict
git status  # See conflicted files
# Edit files to resolve conflicts
git add .
git commit
```

### Clean Working Directory
```bash
# Remove untracked files
git clean -f

# Remove untracked files and directories
git clean -fd

# Dry run (see what would be removed)
git clean -n
```

