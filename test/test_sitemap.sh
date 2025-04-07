#!/bin/bash
set -o pipefail  # ⚠️ Mejor que set -e para no cortar flujo por errores menores

echo "🛰️ Validando sitemap completo con sitemap-0.xml"

SITEMAP_URL="http://localhost:4321/sitemap-0.xml"
TMP_FILE="/tmp/sitemap-0.xml"
ERROR_FILE="/tmp/sitemap_errors.log"

# Limpiamos registros anteriores
rm -f "$ERROR_FILE"

# Descargamos el sitemap
curl -s "$SITEMAP_URL" -o "$TMP_FILE"

# Validación básica del XML
if grep -q "<urlset" "$TMP_FILE" || grep -q "<sitemapindex" "$TMP_FILE"; then
  echo "✅ sitemap-0.xml detectado correctamente"
else
  echo "❌ Error: No se detectó sitemap válido (ni <urlset> ni <sitemapindex>)"
  exit 1
fi

echo "🔍 Comprobando accesibilidad de todos los enlaces declarados en el sitemap:"

# Recorremos todas las URLs
grep "<loc>" "$TMP_FILE" | sed -E 's/.*<loc>(.*)<\/loc>.*/\1/' | while read -r url; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
  if [[ "$code" == "200" ]]; then
    echo "✔️ $url [OK]"
  else
    echo "❌ $url [ERROR $code]"
    echo "$url [$code]" >> "$ERROR_FILE"
  fi
done

# Comprobamos si hubo errores
if [[ -s "$ERROR_FILE" ]]; then
  echo "🚨 Validación final: Se encontraron errores en uno o más enlaces del sitemap:"
  cat "$ERROR_FILE"
  exit 1
else
  echo "🏁 Validación final: Todos los enlaces del sitemap son accesibles"
  exit 0
fi



# echo "🛰️ Validando sitemap completo con sitemap-0.xml"
#
# # Asegúrate de que SITE no termine con "/" para evitar dobles barras.
#
# curl -s "http://localhost:4321/sitemap-0.xml" -o /tmp/sitemap-0.xml
#
# if grep -q "<urlset" /tmp/sitemap-0.xml || grep -q "<sitemapindex" /tmp/sitemap-0.xml; then
#   echo "✅ sitemap-0.xml detectado correctamente"
# else
#   echo "❌ Error: No se detectó sitemap válido"
#   exit 1
# fi
#
# echo "🔍 Comprobando accesibilidad de todos los sitemaps:"
# grep "<loc>" /tmp/sitemap-0.xml | sed -E 's/.*<loc>(.*)<\/loc>.*/\1/' | while read -r url; do
#   code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
#   if [[ "$code" == "200" ]]; then
#     echo "✔️ $url [OK]"
#   else
#     echo "❌ $url [ERROR $code]"
#   fi
# done
#
# echo "🏁 Validación completa"
