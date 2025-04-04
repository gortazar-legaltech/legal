#!/bin/bash
set -e
LOG_FILE="sdlc_test_log.txt"

echo "🧪 Iniciando validación SDLC GORTÁZAR LegalTech" | tee $LOG_FILE
echo "Fecha: $(date)" | tee -a $LOG_FILE
echo "======================================" | tee -a $LOG_FILE
echo "🧪 Iniciando test completo SDLC para GORTÁZAR LegalTech..."
echo "Iniciando test completo SDLC..." >> $LOG_FILE

# Paso 1: Validación estructura de páginas
echo "✅ [1/4] Validando estructura..." | tee -a $LOG_FILE
node test/validate-pages.cjs >> $LOG_FILE 2>&1

# Paso 2: Lanzar servidor local
echo "🌐 [2/4] Lanzando servidor de desarrollo..." | tee -a $LOG_FILE
npm run dev >> $LOG_FILE 2>&1 &
sleep 5

# Paso 3: Test de navegación con curl
echo "🔗 [3/4] Navegación funcional local..." | tee -a $LOG_FILE
BASE_URL="http://localhost:4321/legal/es"
ROUTES=("" "nosotros" "servicios" "contacto" "privacidad")
FAILED=0

for route in "${ROUTES[@]}"; do
  URL="$BASE_URL/$route"
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
  if [ "$STATUS" -eq 200 ] || [ "$STATUS" -eq 308 ]; then
    echo "✅ [$STATUS] $URL" | tee -a $LOG_FILE
  else
    echo "❌ [$STATUS] ERROR - $URL" | tee -a $LOG_FILE
    FAILED=$((FAILED+1))
  fi
done

# Paso 4: Validación de contratos de assets
echo "🧾 [4/4] Validando assets gráficos..." | tee -a $LOG_FILE
./test_assets__sdlc.sh >> $LOG_FILE 2>&1

if [ "$FAILED" -gt 0 ]; then
  echo "❌ Navegación falló en $FAILED rutas. Revisa $LOG_FILE"
  exit 1
else
  echo "🎉 Todos los test SDLC se han completado con éxito."
  echo "✅ SDLC PASSED." >> $LOG_FILE
fi

# Paso 5: Validación de contratos de styles
echo "🧾 [4/4] Validando assets gráficos..." | tee -a $LOG_FILE
./test_layouts_sdlc.sh >> $LOG_FILE 2>&1

if [ "$FAILED" -gt 0 ]; then
  echo "❌ Navegación falló en $FAILED rutas. Revisa $LOG_FILE"
  exit 1
else
  echo "🎉 Todos los test SDLC se han completado con éxito."
  echo "✅ SDLC PASSED." >> $LOG_FILE
fi

echo "📄 El log completo está disponible en: $LOG_FILE"
