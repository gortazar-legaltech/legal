#!/bin/bash
set -e

echo "🛠️ Validando entorno local de GORTÁZAR LegalTech"

SECURITY_FILE="src/pages/.well-known/security.txt"
CORRECTED_FILE="src/pages/.well-known/_security.txt"

if [ -f "$SECURITY_FILE" ]; then
  echo "⚠️ Corrigiendo archivo de seguridad..."
  mv "$SECURITY_FILE" "$CORRECTED_FILE"
fi

npm run dev &

sleep 4
echo "🌍 Abrir navegador en http://localhost:4321/legal"
xdg-open "http://localhost:4321/legal" || open "http://localhost:4321/legal"
