#!/bin/bash
#!/bin/bash

set -o pipefail  # Mantiene rigor sin interrumpir el while
set -u           # Falla si hay una variable no definida

echo "🛰️ Validando sitemap completo con sitemap-0.xml"

SITEMAP_URL="http://localhost:4321/sitemap-0.xml"
TMP_FILE="/tmp/sitemap-0.xml"
ERROR_FILE="/tmp/sitemap_errors.log"

# Limpieza previa
rm -f "$TMP_FILE" "$ERROR_FILE"

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

# Variable de estado general
status=0

# Validar cada URL
while read -r url; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
  if [[ "$code" == "200" ]]; then
    echo "✔️ $url [OK]"
  else
    echo "❌ $url [ERROR $code]"
    echo "$url [$code]" >> "$ERROR_FILE"
    status=1  # Marca que hubo al menos un error
  fi
done < <(grep "<loc>" "$TMP_FILE" | sed -E 's/.*<loc>(.*)<\/loc>.*/\1/')

# Resultado final
if [[ "$status" -eq 1 ]]; then
  echo -e "\n🚨 Validación final: Se encontraron errores en uno o más enlaces:"
  cat "$ERROR_FILE"
else
  echo -e "\n🏁 Validación final: Todos los enlaces del sitemap son accesibles"
fi

exit "$status"
