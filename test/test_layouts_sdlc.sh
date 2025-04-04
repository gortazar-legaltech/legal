#!/bin/bash
set -o pipefail  # ⚠️ Mejor que set -e para no cortar flujo por errores menores

echo "🧱 Validación de Layouts - GORTÁZAR LegalTech"
echo "==============================================="
# Directorio base
BASE_DIR="$(dirname "$0")/.."
LAYOUTS_DIR="src/layouts"
PAGES_DIR="src/pages"
FAILED=0

# 1. Validar existencia de MainLayout.astro
if [ ! -f "$LAYOUTS_DIR/MainLayout.astro" ]; then
  echo "❌ ERROR: Falta $LAYOUTS_DIR/MainLayout.astro"
  FAILED=$((FAILED+1))
else
  echo "✅ MainLayout.astro existe"
fi

# 2. Validar que todos los layouts contienen <slot />
MISSING_SLOT=$(grep -L "<slot" "$LAYOUTS_DIR"/*.astro || true)
if [ -n "$MISSING_SLOT" ]; then
  echo "❌ ERROR: Los siguientes layouts no contienen <slot />:"
  echo "$MISSING_SLOT"
  FAILED=$((FAILED+1))
else
  echo "✅ Todos los layouts contienen <slot />"
fi

# 3. Validar que las páginas importan un layout
echo "🔍 Verificando páginas que NO usan layouts:"
NO_LAYOUT_PAGES=()
for file in $(find "$PAGES_DIR" -name "*.astro"); do
  if ! grep -q "import MainLayout" "$file"; then
    NO_LAYOUT_PAGES+=("$file")
  fi
done

if [ ${#NO_LAYOUT_PAGES[@]} -gt 0 ]; then
  echo "❌ Las siguientes páginas no usan MainLayout:"
  for page in "${NO_LAYOUT_PAGES[@]}"; do
    echo "  - $page"
  done
  FAILED=$((FAILED+1))
else
  echo "✅ Todas las páginas usan MainLayout"
fi

# Resultado final
if [ "$FAILED" -gt 0 ]; then
  echo "❌ Validación de Layouts con $FAILED errores"
  exit 1
else
  echo "✅ Validación de Layouts completada correctamente"
fi
