# 


#!/bin/bash

echo "🔍 Iniciando SDLC Suite para GORTÁZAR LegalTech"
date
echo "=============================================="

errores_totales=0

# Assets
bash "$(dirname "$0")/test_assets_sdlc.sh"
errores_totales=$((errores_totales + $?))

# Layouts
bash "$(dirname "$0")/test_layouts_sdlc.sh"
errores_totales=$((errores_totales + $?))

# Components
bash "$(dirname "$0")/test_components_sdlc.sh"
errores_totales=$((errores_totales + $?))

# Pages
bash "$(dirname "$0")/test_pages_sdlc.sh"
errores_totales=$((errores_totales + $?))

# Styles
#bash "$(dirname "$0")/test_styles_sdlc.sh"
#errores_totales=$((errores_totales + $?))

echo ""
echo "🧾 Resumen SDLC Final"
echo "----------------------"
echo "🔸 Total de errores detectados: $errores_totales"

if [ "$errores_totales" -eq 0 ]; then
  echo "✅ Suite SDLC completada SIN ERRORES."
else
  echo "❌ Suite SDLC completada CON ERRORES."
fi

exit $errores_totales
