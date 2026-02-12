@echo off
echo ===================================================
echo Perfect Scene Creator - Startup Script
echo ===================================================

echo Checking for Node.js...
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed or not in your PATH.
    echo Please install it from https://nodejs.org/ first.
    pause
    exit /b
)

echo [1/3] Preparando o Frontend (Client)...
cd client
if not exist node_modules (
    echo Instalando dependencias do frontend...
    call npm install
)
echo Gerando versao de producao do site...
call npm run build

echo [2/3] Preparando o Backend (Server)...
cd ../server
echo Sincronizando dependencias do backend...
call npm install

echo [3/3] Iniciando o Aplicativo unificado na porta 3000...
echo.
echo ===================================================
echo  SITE PRONTO: http://localhost:3000
echo ===================================================
echo.
node server.js
pause
