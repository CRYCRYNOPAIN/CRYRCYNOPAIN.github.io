@echo off
echo === 1. 生成静态文件 ===
bundle exec jekyll build

echo === 2. 进入 gh-pages Worktree ===
cd D:\Develop\gh-pages

echo === 3. 清空旧内容 ===
git rm -rf .

echo === 4. 复制新内容 ===
xcopy D:\Develop\CRYRCYNOPAIN.github.io\_site\* . /E /Y

echo === 5. 添加文件 ===
git add .

echo === 6. 提交变更 ===
git commit -m "Deploy %date% %time%"

echo === 7. 推送到远程 ===
git push origin gh-pages

echo === 8. 返回主目录 ===
cd D:\Develop\CRYRCYNOPAIN.github.io
echo === 部署完成！===
pause