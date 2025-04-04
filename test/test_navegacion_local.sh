#!/bin/bash
set -e

echo "🧪 Test funcional de navegación para GORTÁZAR LegalTech"
echo "---------------------------------------------------------"

BASE_URL="http://localhost:4321/legal/es"
ROUTES=("" "nosotros" "servicios" "contacto" "privacidad")
FAILED=0

for route in "${ROUTES[@]}"; do
  URL="$BASE_URL/$route"
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
  if [ "$STATUS" -eq 200 ] || [ "$STATUS" -eq 308 ]; then
    echo "✅ [$STATUS] OK - $URL"
  else
    echo "❌ [$STATUS] ERROR - $URL"
    FAILED=$((FAILED+1))
  fi
done

# Probar comportamiento 404
echo "🔍 Test de página 404 esperada (recurso inexistente)..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/noexiste")
if [ "$STATUS" -eq 404 ]; then
  echo "✅ [404] Página de error funciona correctamente."
else
  echo "❌ [$STATUS] Página de error 404 falló"
  FAILED=$((FAILED+1))
fi

if [ "$FAILED" -gt 0 ]; then
  echo "❌ Navegación falló en $FAILED pruebas"
  exit 1
else
  echo "✅ Navegación validada con éxito en todas las rutas."
fi
