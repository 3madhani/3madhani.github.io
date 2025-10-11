Write-Host "🚀 Building Flutter Web..."
flutter build web

Write-Host "📦 Committing source code..."
git add .
git commit -m "Update and deploy $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git push origin master

Write-Host "🌐 Deploying to GitHub Pages..."
git subtree push --prefix build/web origin gh-pages

Write-Host "✅ Deployment complete! Visit https://3madhani.github.io"
