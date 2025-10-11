Write-Host "🚀 Building Flutter Web..." -ForegroundColor Cyan

flutter clean
flutter pub get
flutter build web --release

# 🧩 Add cache-busting version to index.html
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
(Get-Content build/web/index.html) -replace '</head>', "<meta name='build-version' content='$timestamp'></head>" | Set-Content build/web/index.html
Write-Host "🧩 Added cache-busting version: $timestamp" -ForegroundColor Green

Write-Host "📦 Committing source code..." -ForegroundColor Cyan
git add .
git commit -m "Update and deploy $timestamp" | Out-Null
git push origin master

Write-Host "🌐 Deploying to GitHub Pages..." -ForegroundColor Cyan
git subtree split --prefix build/web -b gh-pages-temp
git push origin gh-pages-temp:gh-pages --force
git branch -D gh-pages-temp

Write-Host "✅ Deployment complete!" -ForegroundColor Green
Write-Host "🌍 Visit: https://3madhani.github.io"

Read-Host -Prompt "Press Enter to exit..."
exit