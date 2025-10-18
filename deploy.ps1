# 🚀 Flutter Web Deploy Script for GitHub Pages
# Author: Emad Hany
# Repo: 3madhani.github.io

Write-Host "🚀 Starting Flutter Web Build..." -ForegroundColor Cyan
Write-Host ""

# Step 0: Ensure we're on master branch
$currentBranch = git branch --show-current
if ($currentBranch -ne "master") {
    Write-Host "⚠️ Currently on '$currentBranch' branch. Switching to master..." -ForegroundColor Yellow
    git checkout master
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to switch to master branch. Commit or stash your changes first." -ForegroundColor Red
        exit 1
    }
}

# Step 1: Clean and get dependencies
Write-Host "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# Step 2: Build Flutter web with correct base href
Write-Host "🔨 Building Flutter web..."
flutter build web --release --base-href "/"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Flutter build failed!" -ForegroundColor Red
    exit 1
}

# Step 3: Add .nojekyll file (CRITICAL for GitHub Pages)
Write-Host "📝 Adding .nojekyll file..."
if (-not (Test-Path "build\web")) {
    Write-Host "❌ build\web doesn't exist. Build failed!" -ForegroundColor Red
    exit 1
}
New-Item -Path "build\web\.nojekyll" -ItemType File -Force | Out-Null
Write-Host "✅ .nojekyll file created"

# Step 4: Add build timestamp to prevent caching
$builtIndexPath = "build\web\index.html"
if (Test-Path $builtIndexPath) {
    $content = Get-Content $builtIndexPath -Raw
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $content = $content -replace '</head>', "<meta name='build-timestamp' content='$timestamp'></head>"
    $content | Set-Content $builtIndexPath
    Write-Host "🕓 Added build timestamp: $timestamp"
}
else {
    Write-Host "⚠️ index.html not found in build folder!" -ForegroundColor Yellow
}

# Step 5: Verify critical files exist
Write-Host "🔍 Verifying build files..."
$requiredFiles = @(
    "build\web\index.html",
    "build\web\flutter_bootstrap.js",
    "build\web\main.dart.js",
    "build\web\.nojekyll"
)

$allFilesPresent = $true
foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        Write-Host "❌ Missing required file: $file" -ForegroundColor Red
        $allFilesPresent = $false
    }
}

if (-not $allFilesPresent) {
    Write-Host "❌ Some required files are missing. Cannot deploy." -ForegroundColor Red
    exit 1
}
Write-Host "✅ All required files present"

# Step 6: Commit source changes on master
Write-Host "📦 Committing source code to master..."
git add .
$commitMsg = "Deploy $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git commit -m $commitMsg
if ($LASTEXITCODE -eq 0) {
    git push origin master
    Write-Host "✅ Source code committed and pushed"
}
else {
    Write-Host "⚠️ No changes to commit or commit failed" -ForegroundColor Yellow
}

# Step 7: Deploy to GitHub Pages
Write-Host "🌐 Deploying to gh-pages branch..."

# Clean up any existing temp branch
git branch -D gh-pages-temp 2>$null

# Create subtree split
git subtree split --prefix build/web -b gh-pages-temp

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Git subtree split failed!" -ForegroundColor Red
    exit 1
}

# Force push to gh-pages
git push origin gh-pages-temp:gh-pages --force

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to push to gh-pages!" -ForegroundColor Red
    git branch -D gh-pages-temp
    exit 1
}

# Cleanup temp branch
git branch -D gh-pages-temp
Write-Host "✅ Successfully deployed to gh-pages"

# Step 8: Verify .nojekyll on gh-pages
Write-Host "🔍 Verifying deployment on gh-pages..."
git fetch origin gh-pages
git checkout gh-pages
$noJekyllExists = Test-Path ".nojekyll"
git checkout master

if ($noJekyllExists) {
    Write-Host "✅ .nojekyll file confirmed on gh-pages branch" -ForegroundColor Green
}
else {
    Write-Host "⚠️ WARNING: .nojekyll file not found on gh-pages branch!" -ForegroundColor Yellow
    Write-Host "   This may cause issues with GitHub Pages serving files correctly." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ Deployment Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🌍 Your site: https://3madhani.github.io" -ForegroundColor White
Write-Host "⏳ Wait 1-2 minutes for GitHub Pages to update" -ForegroundColor Yellow
Write-Host "🔄 Hard refresh: Ctrl+Shift+R (or Cmd+Shift+R on Mac)" -ForegroundColor Yellow
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Visit your site in 1-2 minutes"
Write-Host "   2. Press F12 to open Developer Console"
Write-Host "   3. Check Console tab for any errors"
Write-Host "   4. Look for messages: 'Entrypoint loaded' and 'Engine initialized'"
Write-Host ""