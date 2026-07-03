echo "1.删除docs/并重新构建"
echo ""
# 1. 彻底清空旧的构建产物
rm -rf docs/

# 2. 进行全量构建（确保所有 HTML 正确生成）
hugo --cleanDestinationDir

echo "2.重新提交git."
echo ""
git add .
git commit -m "$(date +%Y-%m-%d) update"
git push origin main

echo "3.等待部署GitHub Actions 构建完成."
echo "4.到cf刷新CDN"
