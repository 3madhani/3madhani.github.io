# 🚀 Flutter Web Deploy Script for GitHub Pages
# Author: Emad Hany
# Repo: 3madhani.github.io

Write-Host "🚀 Building Flutter Web..."

# Step 1: Clean and get dependencies
flutter clean
flutter pub get

# Step 2: Define your GitHub Pages base path
# ✅ FIXED: Use "/" for username.github.io sites (not "/repo-name/")
$baseHref = "/"

# Step 3: Replace $FLUTTER_BASE_HREF in web/index.html temporarily
$indexFile = "web\index.html"
$originalContent = Get-Content $indexFile -Raw
$updatedContent = $originalContent -replace '\$FLUTTER_BASE_HREF', $baseHref
$updatedContent | Set-Content $indexFile

Write-Host "✅ Updated base href to $baseHref"

# Step 4: Build Flutter web release
flutter build web --release

# Step 5: Restore original index.html
$originalContent | Set-Content $indexFile

# Step 6: Add a timestamp meta tag to index.html to avoid caching issues
$builtIndexPath = "build\web\index.html"
if (Test-Path $builtIndexPath) {
    (Get-Content $builtIndexPath) -replace '</head>', "<meta name='build-timestamp' content='$(Get-Date -Format "yyyyMMddHHmmss")'></head>" | Set-Content $builtIndexPath
    Write-Host "🕓 Added build timestamp"
}
else {
    Write-Host "⚠️ Build folder not found. Something may have gone wrong with Flutter build."
    exit 1
}

# Step 7: Commit source changes
Write-Host "📦 Committing source code..."
git add .
git commit -m "Update and deploy $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-Null
git push origin master

# Step 8: Deploy to GitHub Pages using subtree
Write-Host "🌐 Deploying to GitHub Pages..."
git subtree split --prefix build/web -b gh-pages-temp
git push origin gh-pages-temp:gh-pages --force
git branch -D gh-pages-temp

Write-Host "✅ Deployment complete! Visit https://3madhani.github.io"
Write-Host "⏳ Note: It may take 1-2 minutes for changes to appear. Clear cache with Ctrl+Shift+R"