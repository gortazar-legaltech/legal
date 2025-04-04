#!/bin/bash
set -o pipefail  # ⚠️ Mejor que set -e para no cortar flujo por errores menores

BASE_DIR="$(dirname "$0")/.."
LAYOUT_FILE="$BASE_DIR/src/layouts/Layout.astro"
STYLE_FILE="import '../styles/global.css';"

echo "🎨 Validación de Estilos - GORTÁZAR LegalTech"
echo "============================================="

# Directorio base
BASE_DIR="$(dirname "$0")/.."
STYLES_DIR="src/styles"
GLOBAL_CSS="$STYLES_DIR/global.css"
FAILED=0

# 1. Verificar existencia de src/styles
if [ ! -d "$STYLES_DIR" ]; then
  echo "❌ ERROR: No existe el directorio $STYLES_DIR"
  FAILED=$((FAILED+1))
else
  echo "✅ Directorio $STYLES_DIR encontrado"
fi

# 2. Verificar existencia de global.css
if [ ! -f "$GLOBAL_CSS" ]; then
  echo "❌ ERROR: Falta archivo global.css"
  FAILED=$((FAILED+1))
else
  echo "✅ global.css está presente"
fi

# 3. Verificar uso de Tailwind en global.css
if grep -q "@tailwind" "$GLOBAL_CSS"; then
  echo "✅ Tailwind CSS está configurado en global.css"
else
  echo "⚠️ ADVERTENCIA: No se encontraron directivas @tailwind en global.css"
fi

# 4. Verificar que páginas/layouts importen global.css
echo "🔍 Verificando importaciones de estilos en layouts/páginas..."
NOT_IMPORTED=0
for file in $(find src/layouts src/pages -type f -name "*.astro"); do
  if ! grep -q "global.css" "$file"; then
    echo "⚠️ Falta import de global.css en: $file"
    NOT_IMPORTED=$((NOT_IMPORTED+1))
  fi
done

if [ "$NOT_IMPORTED" -gt 0 ]; then
  echo "⚠️ En $NOT_IMPORTED archivos no se importa global.css"
else
  echo "✅ Todos los archivos relevantes importan global.css"
fi

# 5. Verificar que no haya estilos inline en .astro
echo "🚫 Buscando estilos inline prohibidos..."
INLINE=$(grep -r 'style=' src/pages src/layouts || true)
if [ -n "$INLINE" ]; then
  echo "❌ Estilos inline encontrados:"
  echo "$INLINE"
  FAILED=$((FAILED+1))
else
  echo "✅ No se encontraron estilos inline"
fi

# 6. Verificar branding contractual (si aplica)
if [ -f "$STYLES_DIR/branding.css" ]; then
  echo "✅ branding.css presente (estilos personalizados para cliente)"
  if grep -q "atlante-oscuro" "$STYLES_DIR/branding.css"; then
    echo "✅ Clase de color corporativo 'atlante-oscuro' definida"
  else
    echo "⚠️ Falta clase 'atlante-oscuro' en branding.css"
    FAILED=$((FAILED+1))
  fi
else
  echo "🔍 No se detectó branding.css (puede no aplicar para este cliente)"
fi

# Resultado final
if [ "$FAILED" -gt 0 ]; then
  echo "❌ Validación de estilos encontró $FAILED problema(s)"
  exit 1
else
  echo "✅ Validación de estilos completada exitosamente"
fi
