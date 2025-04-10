#!/bin/bash

set -o pipefail
set -u

echo "🛰️ Validando sitemap completo con sitemap-0.xml"

SITEMAP_URL="http://localhost:4321/sitemap-0.xml"
TMP_FILE="./sitemap-0.xml"
LOG_FILE="./sitemap_scan.log"
ERROR_FILE="./sitemap_errors.log"

# Mantener histórico de validaciones (no se borra)
echo -e "\n🗓️ Inicio de validación: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"

# Limpieza previa solo de archivos temporales
rm -f "$TMP_FILE" "$ERROR_FILE"

# Descargar el sitemap
curl -s "$SITEMAP_URL" -o "$TMP_FILE"

# Validar el XML
if grep -q "<urlset" "$TMP_FILE" || grep -q "<sitemapindex" "$TMP_FILE"; then
  echo "✅ sitemap-0.xml detectado correctamente" | tee -a "$LOG_FILE"
else
  echo "❌ Error: No se detectó sitemap válido (ni <urlset> ni <sitemapindex>)" | tee -a "$LOG_FILE"
  exit 1
fi

echo "🔍 Comprobando accesibilidad de todos los enlaces declarados en el sitemap:" | tee -a "$LOG_FILE"

# Estado de ejecución
status=0

# Validar cada URL y registrar todo
while read -r url; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
  if [[ "$code" == "200" ]]; then
    echo "✔️ $url [OK]" | tee -a "$LOG_FILE"
  else
    echo "❌ $url [ERROR $code]" | tee -a "$LOG_FILE"
    echo "$url [$code]" >> "$ERROR_FILE"
    status=1
  fi
done < <(grep "<loc>" "$TMP_FILE" | sed -E 's/.*<loc>(.*)<\/loc>.*/\1/')

# Resultado final
if [[ "$status" -eq 1 ]]; then
  echo -e "\n🚨 Validación final: Se encontraron errores en uno o más enlaces:" | tee -a "$LOG_FILE"
  cat "$ERROR_FILE" | tee -a "$LOG_FILE"
else
  echo -e "\n🏁 Validación final: Todos los enlaces del sitemap son accesibles" | tee -a "$LOG_FILE"
fi

exit "$status"
