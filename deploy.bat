@echo off
echo === 1. 生成静态文件 ===
rem 切换到脚本所在目录（通常为站点根目录）
cd /d "%~dp0"

echo Running: bundle exec jekyll build
bundle exec jekyll build
if errorlevel 1 (
	echo Jekyll build 失败，停止部署。
	pause
	exit /b 1
)

echo === 2. 进入 gh-pages 工作区 ===
set "GHPAGES_DIR=D:\Develop\gh-pages"
if not exist "%GHPAGES_DIR%" (
	echo 错误：目标目录 %GHPAGES_DIR% 不存在。
	pause
	exit /b 1
)

pushd "%GHPAGES_DIR%"

echo === 3. 清空旧内容（在 Git 中标记删除） ===
rem 使用 git rm 删除工作区中的已跟踪文件（保留 .git 目录）
git rm -rf . 2>nul || (
	echo 注意：git rm 失败（可能无跟踪文件），继续清空目录内容。
)

echo === 额外清理未被 git 管理的文件 ===
rem 删除所有文件和文件夹（保守做法：保留 .git）
for /f "delims=" %%I in ('dir /b') do (
	if /i not "%%I"==".git" (
		rd /s /q "%%I" 2>nul || del /f /q "%%I" 2>nul
	)
)

echo === 4. 复制新内容 ===
set "SITE_DIR=D:\Develop\CRYRCYNOPAIN.github.io\_site"
if not exist "%SITE_DIR%" (
	echo 错误：源站点目录 %SITE_DIR% 不存在。
	popd
	pause
	exit /b 1
)

echo Copying from "%SITE_DIR%" to "%GHPAGES_DIR%"
xcopy "%SITE_DIR%\*" "%GHPAGES_DIR%\" /E /Y /I

echo === 5. 添加文件 ===
git add .

echo === 8. 返回原目录 ===
popd
cd /d "%~dp0"
echo === 部署完成！===
pause