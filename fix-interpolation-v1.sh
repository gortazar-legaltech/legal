#!/bin/bash

echo "🚀 Iniciando corrección rigurosa de interpolaciones incorrectas de \${import.meta.env.BASE_URL}..."

# Recorremos todos los archivos .astro y .js del proyecto
FILES=$(find src/ -type f \( -name "*.astro" -o -name "*.js" \))

for file in $FILES; do
  echo "🔧 Procesando $file..."

  # Reemplazo de href="/${import.meta.env.BASE_URL}xyz"
  sed -i -E 's|href="\/\$\{import\.meta\.env\.BASE_URL\}([^"]*)"|href={`\${import.meta.env.BASE_URL}\1`}|g' "$file"

  # Reemplazo de src="/${import.meta.env.BASE_URL}xyz"
  sed -i -E 's|src="\/\$\{import\.meta\.env\.BASE_URL\}([^"]*)"|src={`\${import.meta.env.BASE_URL}\1`}|g' "$file"

  # Reemplazo de rutas con comillas simples
  sed -i -E "s|href='\/\$\{import\.meta\.env\.BASE_URL\}([^']*)'|href={`\${import.meta.env.BASE_URL}\1`}|g" "$file"
  sed -i -E "s|src='\/\$\{import\.meta\.env\.BASE_URL\}([^']*)'|src={`\${import.meta.env.BASE_URL}\1`}|g" "$file"

  # Reemplazo de rutas directamente con slash inicial (precaución)
  sed -i -E "s|href=\"/legal/([^\"']*)\"|href={`\${import.meta.env.BASE_URL}\1`}|g" "$file"
  sed -i -E "s|src=\"/legal/([^\"']*)\"|src={`\${import.meta.env.BASE_URL}\1`}|g" "$file"

done

echo "✅ Todas las rutas han sido corregidas correctamente."
echo "💡 Puedes lanzar ahora: pnpm dev"
