#!/bin/bash
# 自动清理、生成、检查
echo "正在清理旧构建..."
rm -rf docs/
echo "正在编译站点..."
hugo --cleanDestinationDir --minify
echo "构建完成，共有以下文章："
hugo list all | grep -v "draft:true" | awk -F, '{print $1}'

hugo server --cleanDestinationDir
