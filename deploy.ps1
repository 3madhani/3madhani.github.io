Write-Host "🚀 Building Flutter Web..."

flutter clean
flutter pub get
flutter build web --release

# 🧩 Add a timestamp to index.html to break cache
$indexPath = "build\web\index.html"
(Get-Content $indexPath) -replace '</head>', "<meta name='build-timestamp' content='$(Get-Date -Format "yyyyMMddHHmmss")'></head>" | Set-Content $indexPath

Write-Host "📦 Committing source code..."
git add .
git commit -m "Update and deploy $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")" | Out-Null
git push origin master

Write-Host "🌐 Deploying to GitHub Pages..."
git subtree split --prefix build/web -b gh-pages-temp
git push origin gh-pages-temp:gh-pages --force
git branch -D gh-pages-temp

Write-Host "✅ Deployment complete! Visit https://3madhani.github.io"
