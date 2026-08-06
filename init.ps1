cd D:\website\hugo-site
Stop-Process -Name hugo -ErrorAction SilentlyContinue
Remove-Item -LiteralPath .\themes\stack -Recurse -Force
git clone https://github.com/CaiJimmy/hugo-theme-stack.git .\themes\stack
hugo server