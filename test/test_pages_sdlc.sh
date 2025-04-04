#!/bin/bash
set -o pipefail  # ⚠️ Mejor que set -e para no cortar flujo por errores menores

echo "📄 Validación de Páginas - GORTÁZAR LegalTech"
echo "============================================="

# # Directorio base
# BASE_DIR="$(dirname "$0")/.."
# PAGES_DIR="src/pages"
# FAILED=0

# # 1. Verificar que hay archivos .astro
# TOTAL=$(find "$PAGES_DIR" -type f -name "*.astro" | wc -l)
# if [ "$TOTAL" -eq 0 ]; then
#   echo "❌ ERROR: No se encontraron archivos .astro en $PAGES_DIR"
#   exit 1
# else
#   echo "✅ Se encontraron $TOTAL páginas .astro"
# fi

# # 2. Buscar archivos no .astro
# INVALID_FILES=$(find "$PAGES_DIR" -type f ! -name "*.astro")
# if [ -n "$INVALID_FILES" ]; then
#   echo "⚠️ Archivos inválidos encontrados:"
#   echo "$INVALID_FILES"
#   FAILED=$((FAILED+1))
# fi

# # 3. Verificar contenido mínimo en cada página
# echo "🔍 Validando contenido básico de las páginas..."
# for page in $(find "$PAGES_DIR" -type f -name "*.astro"); do
#   if ! grep -q "<h1" "$page" && ! grep -q "<title" "$page"; then
#     echo "❌ $page no contiene <h1> ni <title> (falta contenido visible)"
#     FAILED=$((FAILED+1))
#   fi
# done

# # 4. Verificar uso de MainLayout
# echo "🧱 Verificando que cada página use MainLayout..."
# for page in $(find "$PAGES_DIR" -type f -name "*.astro"); do
#   if ! grep -q "import MainLayout" "$page"; then
#     echo "⚠️ $page no importa MainLayout (posible inconsistencia visual)"
#     FAILED=$((FAILED+1))
#   fi
# done

# # 5. Verificar que no estén vacías (<slot /> sin nada)
# echo "💬 Verificando que las páginas no estén vacías..."
# for page in $(find "$PAGES_DIR" -type f -name "*.astro"); do
#   if ! grep -q "<[a-z]" "$page"; then
#     echo "❌ $page está vacía (sin HTML visible)"
#     FAILED=$((FAILED+1))
#   fi
# done

# # Resultado final
# if [ "$FAILED" -gt 0 ]; then
#   echo "❌ Validación de páginas encontró $FAILED problemas"
#   exit 1
# else
#   echo "✅ Validación de páginas completada con éxito"
# fi


#!/bin/bash

BASE_DIR="$(dirname "$0")/.."
PAGES_DIR="$BASE_DIR/src/pages"
errores=0

echo "📄 Validación de Páginas - GORTÁZAR LegalTech"
echo "============================================="

num_pages=$(find "$PAGES_DIR" -name '*.astro' | wc -l)
echo "✅ Se encontraron $num_pages páginas .astro"

for pagina in $(find "$PAGES_DIR" -name '*.astro'); do
  contenido=$(grep -E '<h1>|<title>' "$pagina")
  html_visible=$(grep -E "<[a-z]+.*>.*<\/[a-z]+>" "$pagina")

  if [ -z "$contenido" ]; then
    echo "❌ ${pagina#$BASE_DIR/} no contiene <h1> ni <title> (falta contenido visible)"
    ((errores++))
  fi

  if [ -z "$html_visible" ]; then
    echo "❌ ${pagina#$BASE_DIR/} está vacía (sin HTML visible)"
    ((errores++))
  fi
done

if [ $errores -eq 0 ]; then
  echo "✅ Validación de páginas completada correctamente"
else
  echo "❌ Validación de páginas encontró $errores problema(s)"
fi

exit $errores
