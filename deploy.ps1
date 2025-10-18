# 🚀 Flutter Web Deploy Script for GitHub Pages (FIXED)
# Author: Emad Hany
# Repo: 3madhani.github.io

Write-Host "🚀 Starting Flutter Web Build..."

# Step 1: Clean and get dependencies
Write-Host "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# Step 2: Build Flutter web with correct base href
Write-Host "🔨 Building Flutter web..."
flutter build web --release --base-href "/"

# Step 3: Add .nojekyll file (prevents GitHub from ignoring _files)
Write-Host "📝 Adding .nojekyll file..."
New-Item -Path "build\web\.nojekyll" -ItemType File -Force | Out-Null

# Step 4: Add a timestamp to prevent caching
$builtIndexPath = "build\web\index.html"
if (Test-Path $builtIndexPath) {
    $content = Get-Content $builtIndexPath -Raw
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $content = $content -replace '</head>', "<meta name='build-timestamp' content='$timestamp'></head>"
    $content | Set-Content $builtIndexPath
    Write-Host "🕓 Added build timestamp: $timestamp"
}
else {
    Write-Host "⚠️ Build folder not found. Flutter build failed!"
    exit 1
}

# Step 5: Verify critical files exist
Write-Host "🔍 Verifying build files..."
$requiredFiles = @(
    "build\web\index.html",
    "build\web\flutter_bootstrap.js",
    "build\web\main.dart.js"
)

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        Write-Host "❌ Missing required file: $file"
        exit 1
    }
}
Write-Host "✅ All required files present"

# Step 6: Commit source changes
Write-Host "📦 Committing source code..."
git add .
$commitMsg = "Deploy $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git commit -m $commitMsg
git push origin master

# Step 7: Deploy to GitHub Pages
Write-Host "🌐 Deploying to gh-pages branch..."
git subtree split --prefix build/web -b gh-pages-temp
git push origin gh-pages-temp:gh-pages --force
git branch -D gh-pages-temp

Write-Host ""
Write-Host "✅ Deployment Complete!"
Write-Host "🌍 Your site: https://3madhani.github.io"
Write-Host "⏳ Wait 1-2 minutes for GitHub Pages to update"
Write-Host "🔄 Hard refresh: Ctrl+Shift+R (or Cmd+Shift+R on Mac)"
Write-Host ""