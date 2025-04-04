#!/bin/bash

BASE_DIR="$(dirname "$0")/.."
PAGES_DIR="$BASE_DIR/src/pages"
errores=0

echo "🧱 Validación de Layouts - GORTÁZAR LegalTech"
echo "==============================================="

# Excepción para index.astro con redirección
exceptions=("src/pages/index.astro")

paginas_sin_layout=()
for pagina in $(find "$PAGES_DIR" -name '*.astro'); do
  relative_page=${pagina#$BASE_DIR/}
  if [[ " ${exceptions[@]} " =~ " ${relative_page} " ]]; then
    echo "✅ Página permitida sin Layout detectada: $relative_page"
    continue
  fi

  if ! grep -q "import .*MainLayout" "$pagina"; then
    paginas_sin_layout+=("$relative_page")
  fi
done

if [ ${#paginas_sin_layout[@]} -eq 0 ]; then
  echo "✅ Todas las páginas usan MainLayout"
else
  echo "❌ Las siguientes páginas no usan MainLayout:"
  for pagina in "${paginas_sin_layout[@]}"; do
    echo "  - $pagina"
    ((errores++))
  done
fi

if [ $errores -eq 0 ]; then
  echo "✅ Validación de Layouts completada correctamente"
else
  echo "❌ Validación de Layouts con $errores errores"
fi

exit $errores
