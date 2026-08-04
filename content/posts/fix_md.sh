#!/bin/bash
for f in *.md; do
  # 提取标题
  title=$(grep "^title:" "$f" | head -n1 | sed 's/title: //')
  # 提取分类
  cat_list=$(grep "^  - " "$f" | head -n1 | sed 's/  - //')
  
  # 重新生成干净的头部
  echo "---" > tmp.md
  echo "title: $title" >> tmp.md
  echo "date: 2026-07-04" >> tmp.md
  echo "categories: [\"$cat_list\"]" >> tmp.md
  echo "draft: false" >> tmp.md
  echo "---" >> tmp.md
  
  # 追加原文中 --- 下面的所有内容
  sed -n '/---/,/---/!p' "$f" >> tmp.md
  
  # 覆盖原文件
  mv tmp.md "$f"
done
