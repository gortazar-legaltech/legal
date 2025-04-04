#!/bin/bash
set -e
LOG_FILE="sdlc_test_log.txt"
echo "🧪 Validación SDLC y Compliance - GORTÁZAR LegalTech" | tee $LOG_FILE
echo "Fecha: $(date)" | tee -a $LOG_FILE
echo "=====================================================" | tee -a $LOG_FILE

# Validación estructura .astro en todos los idiomas
echo "✅ [1/4] Estructura .astro por idioma..." | tee -a $LOG_FILE
node test/validate-pages.cjs >> $LOG_FILE 2>&1

# Validación de contratos de assets
echo "🧾 [2/4] Validación de contratos de assets..." | tee -a $LOG_FILE
./test_assets_contract.sh >> $LOG_FILE 2>&1

# Lanzar entorno local en background
echo "🌐 [3/4] Lanzando servidor Astro..." | tee -a $LOG_FILE
npm run dev >> $LOG_FILE 2>&1 &
sleep 6

# Test de navegación completo
echo "🔍 [4/4] Test de navegación dinámica..." | tee -a $LOG_FILE
BASE_URL="http://localhost:4321/legal"
FAILED=0
for lang in $(ls src/pages); do
  echo "🌍 Explorando idioma: $lang" | tee -a $LOG_FILE
  for path in $(find src/pages/$lang -name "*.astro"); do
    route=$(echo $path | sed "s|src/pages/$lang/||" | sed "s|index.astro||" | sed "s|.astro||")
    URL="$BASE_URL/$lang/$route"
    URL=$(echo $URL | sed 's|//|/|g') # limpiar posibles duplicaciones
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
    if [ "$STATUS" = "200" ] || [ "$STATUS" = "308" ]; then
      echo "✅ [$STATUS] $URL" | tee -a $LOG_FILE
    else
      echo "❌ [$STATUS] ERROR - $URL" | tee -a $LOG_FILE
      FAILED=$((FAILED+1))
    fi
  done
done

# Validar comportamiento del 404
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/es/noexiste")
if [ "$STATUS" = "404" ]; then
  echo "✅ [404] Página de error 404 funciona correctamente." | tee -a $LOG_FILE
else
  echo "❌ [$STATUS] Página 404 no responde como se espera." | tee -a $LOG_FILE
  FAILED=$((FAILED+1))
fi

if [ "$FAILED" -eq 0 ]; then
  echo "🎉 Validación SDLC finalizada sin errores." | tee -a $LOG_FILE
else
  echo "❌ Se detectaron $FAILED errores durante validación SDLC." | tee -a $LOG_FILE
  exit 1
fi
