#!/bin/bash

echo "🛰️ Validando sitemap completo con sitemap-index.xml"

SITE="http://localhost:4321/"
SITEMAP_INDEX="$SITE/sitemap-index.xml"

curl -s "$SITEMAP_INDEX" -o /tmp/sitemap-index.xml

if grep -q "<sitemapindex" /tmp/sitemap-index.xml; then
  echo "✅ sitemap-index.xml detectado correctamente"
else
  echo "❌ Error: No se detectó el sitemapindex"
  exit 1
fi

echo "🔍 Comprobando accesibilidad de todos los sitemaps:"
grep "<loc>" /tmp/sitemap-index.xml | sed -E 's/.*<loc>(.*)<\/loc>.*/\1/' | while read -r url; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
  if [[ "$code" == "200" ]]; then
    echo "✔️ $url [OK]"
  else
    echo "❌ $url [ERROR $code]"
  fi
done

echo "🏁 Validación completa"

