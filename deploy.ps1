# deploy.ps1
$ErrorActionPreference = "Stop"

Write-Host "`n🚀 Building Flutter Web..." -ForegroundColor Cyan

flutter build web --release

Write-Host "`n📦 Checking for source changes..." -ForegroundColor Yellow

# Commit changes on master only if there are any
if ((git status --porcelain) -ne "") {
    git add .
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m "Update Flutter web build $timestamp"
    git push origin master
    Write-Host "✔ Changes committed and pushed to master." -ForegroundColor Green
}
else {
    Write-Host "ℹ No source changes to commit." -ForegroundColor DarkYellow
}

Write-Host "`n🌐 Deploying to GitHub Pages..." -ForegroundColor Cyan

# Inject cache-busting version into index.html
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
(Get-Content build/web/index.html) -replace '</head>', "<meta name='build-version' content='$timestamp'></head>" | Set-Content build/web/index.html
Write-Host "🧩 Added cache-busting version: $timestamp" -ForegroundColor Cyan


# Split and deploy build/web to gh-pages
git subtree split --prefix build/web -b gh-pages-temp
git push origin gh-pages-temp:gh-pages --force
git branch -D gh-pages-temp

Write-Host "`n✅ Deployment complete!" -ForegroundColor Green
Write-Host "🌍 Visit: https://3madhani.github.io" -ForegroundColor Blue
