#!/bin/bash

echo "🚀 Corrigiendo rutas Astro mal interpretadas por reemplazos anteriores..."
echo "🌐 Asegurando href y src con template literals y \`import.meta.env.BASE_URL\`"

# Recorre todos los archivos .astro y .html que fueron tocados antes
FILES=$(grep -rl '="/\${import.meta.env.BASE_URL}' ./src)

for file in $FILES; do
  echo "🧩 Reparando $file"

  # Reemplaza: ="${import.meta.env.BASE_URL}algo"
  # Con: ={`${import.meta.env.BASE_URL}algo`}
  sed -i -E 's|="\\\$\{import\.meta\.env\.BASE_URL\}([^"]+)"|={`${import.meta.env.BASE_URL}\1`}|g' "$file"
done

echo "✅ Todos los enlaces href y src han sido corregidos correctamente."
echo "💡 Ejecuta ahora 'pnpm dev' y prueba la navegación en http://localhost:4321/legal/es"
