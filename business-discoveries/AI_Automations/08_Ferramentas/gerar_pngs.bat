@echo off
echo ========================================
echo Gerador de PNGs dos Logos
echo ========================================
echo.

REM Verificar se Python está instalado
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Python nao encontrado!
    echo Por favor, instale Python primeiro.
    pause
    exit /b 1
)

echo [1/3] Verificando bibliotecas necessarias...
python -c "import cairosvg" >nul 2>&1
if errorlevel 1 (
    echo [INFO] Instalando bibliotecas necessarias...
    pip install cairosvg pillow
    if errorlevel 1 (
        echo [ERRO] Falha ao instalar bibliotecas!
        pause
        exit /b 1
    )
)

echo [2/3] Convertendo SVGs para PNGs...
python gerar_pngs.py

echo.
echo [3/3] Concluido!
echo.
pause



