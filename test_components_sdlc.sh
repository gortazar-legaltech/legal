#!/bin/bash
set -e

echo "🧩 Validación de Componentes - GORTÁZAR LegalTech"
echo "================================================="

COMPONENTS_DIR="src/components"
LAYOUTS_DIR="src/layouts"
PAGES_DIR="src/pages"
FAILED=0

# 1. Verificar que existe src/components
if [ ! -d "$COMPONENTS_DIR" ]; then
  echo "❌ ERROR: No existe la carpeta $COMPONENTS_DIR"
  FAILED=$((FAILED+1))
else
  echo "✅ Carpeta $COMPONENTS_DIR encontrada"
fi

# 2. Detectar componentes que no sean .astro/.jsx/.tsx
BAD_COMPONENTS=$(find "$COMPONENTS_DIR" -type f ! -name "*.astro" ! -name "*.jsx" ! -name "*.tsx")
if [ -n "$BAD_COMPONENTS" ]; then
  echo "⚠️ COMPONENTES con extensiones no válidas:"
  echo "$BAD_COMPONENTS"
  FAILED=$((FAILED+1))
else
  echo "✅ Todos los componentes tienen extensión válida (.astro/.jsx/.tsx)"
fi

# 3. Validar que se usan (importan) en layouts o páginas
echo "🔎 Buscando componentes sin uso..."
UNUSED=()
for comp in "$COMPONENTS_DIR"/*.astro; do
  name=$(basename "$comp" .astro)
  if ! grep -qr "$name" "$PAGES_DIR" "$LAYOUTS_DIR"; then
    UNUSED+=("$name")
  fi
done

if [ ${#UNUSED[@]} -gt 0 ]; then
  echo "⚠️ Componentes no usados detectados:"
  for comp in "${UNUSED[@]}"; do
    echo "  - $comp"
  done
else
  echo "✅ Todos los componentes son utilizados en el código"
fi

# 4. Verificar que componentes "contenedor" tengan slot
echo "🧬 Verificando <slot /> en componentes contenedores..."
for comp in "$COMPONENTS_DIR"/*.astro; do
  name=$(basename "$comp")
  if [[ "$name" =~ Card|Box|Container|Wrapper ]] && ! grep -q "<slot" "$comp"; then
    echo "⚠️ $name parece contenedor pero no tiene <slot />"
    FAILED=$((FAILED+1))
  fi
done

# Resultado final
if [ "$FAILED" -gt 0 ]; then
  echo "❌ Validación de componentes encontró $FAILED problema(s)"
  exit 1
else
  echo "✅ Validación de componentes completada con éxito"
fi
