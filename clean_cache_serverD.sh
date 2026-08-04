#调试模式 
set -x 
rm -rf public/ -v 
rm -rf resources/ -v
sleep 1 

hugo server -D 
