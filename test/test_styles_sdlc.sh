#!/bin/bash
set -o pipefail  # ⚠️ Mejor que set -e para no cortar flujo por errores menores

echo "🎨 Validación de Estilos - GORTÁZAR LegalTech"
echo "============================================="
BASE_DIR="$(dirname "$0")/.."
LAYOUT_FILE="$BASE_DIR/src/layouts/Layout.astro"
PAGES_DIR="$BASE_DIR/src/pages"

GLOBAL_CSS_IMPORT="import '../styles/global.css';"

echo "🔍 Verificando import global.css en Layout Base..."

# Validar que Layout base tenga el import global
if grep -q "$GLOBAL_CSS_IMPORT" "$LAYOUT_FILE"; then
  echo "✅ global.css importado correctamente en Layout base."
else
  echo "❌ Falta import global.css en Layout base: $LAYOUT_FILE"
  exit 1
fi

# Validar que cada página utilice el layout base
echo "🔍 Verificando que todas las páginas utilicen Layout base..."

FALLOS=0
for pagina in $(find "$PAGES_DIR" -name '*.astro'); do
  if ! grep -q "import .*Layout.* from.*layouts/Layout" "$pagina"; then
    echo "⚠️ Layout base NO utilizado en: ${pagina#$BASE_DIR/}"
    ((FALLOS++))
  fi
done

if [ $FALLOS -eq 0 ]; then
  echo "✅ Todas las páginas usan correctamente Layout base."
else
  echo "❌ Hay páginas sin el Layout base. Total páginas con error: $FALLOS"
  exit 1
fi

# Verificación adicional de estilos inline
echo "🚫 Buscando estilos inline prohibidos..."
INLINE_STYLES=$(grep -rn 'style="' "$PAGES_DIR")
if [ -z "$INLINE_STYLES" ]; then
  echo "✅ No se encontraron estilos inline."
else
  echo "❌ Se encontraron estilos inline prohibidos:"
  echo "$INLINE_STYLES"
  exit 1
fi

echo "✅ Validación de estilos completada exitosamente."
