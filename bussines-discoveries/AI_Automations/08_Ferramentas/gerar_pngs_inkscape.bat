@echo off
echo ========================================
echo Gerador de PNGs usando Inkscape
echo ========================================
echo.
echo IMPORTANTE: Inkscape deve estar instalado!
echo Download: https://inkscape.org/release/
echo.

REM Verificar se Inkscape está instalado
where inkscape >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Inkscape nao encontrado!
    echo Por favor, instale Inkscape primeiro.
    echo Download: https://inkscape.org/release/
    pause
    exit /b 1
)

echo [INFO] Convertendo logos SVG para PNG...
echo.

REM Converter cada logo
echo [1/5] Logo Horizontal...
inkscape logo_conceito.svg --export-filename=logo_conceito.png --export-width=800 --export-height=240
if errorlevel 1 echo [ERRO] Falha ao converter logo_conceito.svg

echo [2/5] Logo Vertical...
inkscape logo_vertical.svg --export-filename=logo_vertical.png --export-width=400 --export-height=500
if errorlevel 1 echo [ERRO] Falha ao converter logo_vertical.svg

echo [3/5] Icone...
inkscape logo_icone.svg --export-filename=logo_icone.png --export-width=240 --export-height=240
if errorlevel 1 echo [ERRO] Falha ao converter logo_icone.svg

echo [4/5] Logo Monocromatico...
inkscape logo_monocromatico.svg --export-filename=logo_monocromatico.png --export-width=800 --export-height=240
if errorlevel 1 echo [ERRO] Falha ao converter logo_monocromatico.svg

echo [5/5] Logo Fundo Escuro...
inkscape logo_fundo_escuro.svg --export-filename=logo_fundo_escuro.png --export-width=800 --export-height=240
if errorlevel 1 echo [ERRO] Falha ao converter logo_fundo_escuro.svg

echo.
echo [CONCLUIDO] Conversao finalizada!
echo Arquivos PNG salvos no mesmo diretorio.
echo.
pause



