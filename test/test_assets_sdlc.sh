#!/bin/bash
set -o pipefail  # ⚠️ Mejor que set -e para no cortar flujo por errores menores

echo "🔍 Validando contratos de assets (estilo CI/CD SDLC)..."
# Directorio base
BASE_DIR="$(dirname "$0")/.."
ASSETS_DIR="src/assets"
REQUIRED=("logo.svg" "firma.svg" "favicon.svg" "favicon.ico")
MIN_WIDTH=200
FAILED=0

# 1. Verificar existencia
for asset in "${REQUIRED[@]}"; do
  if [ ! -f "$ASSETS_DIR/$asset" ]; then
    echo "❌ ERROR: Falta $asset en $ASSETS_DIR/"
    FAILED=$((FAILED+1))
  else
    echo "✅ Presente: $asset"
  fi
done

# 2. Validar ancho en SVGs (viewBox) si existen
for svg in logo.svg firma.svg; do
  FILE="$ASSETS_DIR/$svg"
  if [ -f "$FILE" ]; then
    WIDTH=$(grep -oP 'viewBox="[^"]+"' "$FILE" | grep -oP '\d+\s+\d+\s+\K\d+' | head -1)
    if [ "$WIDTH" -lt "$MIN_WIDTH" ]; then
      echo "⚠️  ADVERTENCIA: $svg tiene viewBox menor a ${MIN_WIDTH}px de ancho ($WIDTH)"
    else
      echo "✅ $svg tiene ancho SVG suficiente: $WIDTH"
    fi
  fi
done

# 3. Buscar archivos fuera de assets
echo "🧼 Buscando assets fuera de src/assets/..."
find . -type f \( -iname "*.svg" -o -iname "*.png" -o -iname "*.ico" \) ! -path "./src/assets/*" \
  ! -path "./node_modules/*" ! -path "./.git/*" > temp_assets.txt

if [ -s temp_assets.txt ]; then
  echo "❌ Encontrados assets fuera de src/assets/:"
  cat temp_assets.txt
  FAILED=$((FAILED+1))
else
  echo "✅ Todos los assets están dentro de src/assets/"
fi
rm -f temp_assets.txt

if [ "$FAILED" -gt 0 ]; then
  echo "❌ Validación de contrato de assets FALLIDA ($FAILED errores)."
  exit 1
else
  echo "✅ Validación de contrato de assets COMPLETADA CON ÉXITO."
fi
