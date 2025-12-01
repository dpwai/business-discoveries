#!/usr/bin/env python3
"""
Script para converter logos SVG em PNG
Requer: pip install cairosvg pillow
"""

import os
import sys

try:
    import cairosvg
    from PIL import Image
except ImportError:
    print("❌ Bibliotecas necessárias não instaladas.")
    print("📦 Instale com: pip install cairosvg pillow")
    sys.exit(1)

def svg_to_png(svg_path, png_path, width=None, height=None, scale=2):
    """
    Converte SVG para PNG
    
    Args:
        svg_path: Caminho do arquivo SVG
        png_path: Caminho de saída do PNG
        width: Largura desejada (None = automático)
        height: Altura desejada (None = automático)
        scale: Escala para alta resolução (2 = retina)
    """
    try:
        # Ler SVG
        with open(svg_path, 'rb') as svg_file:
            svg_data = svg_file.read()
        
        # Converter para PNG
        if width and height:
            png_data = cairosvg.svg2png(
                bytestring=svg_data,
                output_width=width * scale,
                output_height=height * scale
            )
        else:
            png_data = cairosvg.svg2png(
                bytestring=svg_data,
                scale=scale
            )
        
        # Salvar PNG
        with open(png_path, 'wb') as png_file:
            png_file.write(png_data)
        
        print(f"✅ Convertido: {os.path.basename(svg_path)} → {os.path.basename(png_path)}")
        return True
    except Exception as e:
        print(f"❌ Erro ao converter {svg_path}: {e}")
        return False

def main():
    """Converte todos os logos SVG em PNG"""
    
    logos = [
        {
            'svg': 'logo_conceito.svg',
            'png': 'logo_conceito.png',
            'width': 400,
            'height': 120
        },
        {
            'svg': 'logo_vertical.svg',
            'png': 'logo_vertical.png',
            'width': 200,
            'height': 250
        },
        {
            'svg': 'logo_icone.svg',
            'png': 'logo_icone.png',
            'width': 120,
            'height': 120
        },
        {
            'svg': 'logo_monocromatico.svg',
            'png': 'logo_monocromatico.png',
            'width': 400,
            'height': 120
        },
        {
            'svg': 'logo_fundo_escuro.svg',
            'png': 'logo_fundo_escuro.png',
            'width': 400,
            'height': 120
        }
    ]
    
    print("🎨 Convertendo logos SVG para PNG...\n")
    
    success_count = 0
    for logo in logos:
        svg_path = os.path.join(os.path.dirname(__file__), logo['svg'])
        png_path = os.path.join(os.path.dirname(__file__), logo['png'])
        
        if os.path.exists(svg_path):
            if svg_to_png(svg_path, png_path, logo['width'], logo['height']):
                success_count += 1
        else:
            print(f"⚠️  Arquivo não encontrado: {logo['svg']}")
    
    print(f"\n✨ Conversão concluída! {success_count}/{len(logos)} logos convertidos.")
    print(f"📁 Arquivos PNG salvos no mesmo diretório.")

if __name__ == '__main__':
    main()



