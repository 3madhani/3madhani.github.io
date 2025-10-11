Write-Host "🚀 Building Flutter Web..."

flutter clean
flutter pub get
flutter build web --release

Write-Host "📦 Committing source code..."
git add .
git commit -m "Update Flutter web build $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")" | Out-Null
git push origin master

Write-Host "🌐 Deploying to GitHub Pages..."
# Create a temporary branch from build/web and push it as gh-pages
git subtree split --prefix build/web -b gh-pages-temp
git push origin gh-pages-temp:gh-pages --force
git branch -D gh-pages-temp

Write-Host "✅ Deployment complete! Visit https://3madhani.github.io"
