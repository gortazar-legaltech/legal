#!/bin/bash

echo "🔍 Iniciando corrección de rutas en archivos Astro..."

# Archivos generales
FILES=(
  "ASSETS.md"
  "README.md"
  "package.json"
  "sdlc_report.md"
  "astro.config.mjs"
  "tailwind.config.js"
)

# Componentes
COMPONENTS=(
  "src/components/LanguageSwitcher.astro"
  "src/components/Welcome.astro"
)

# Layouts
LAYOUTS=(
  "src/layouts/BaseLayout.astro"
  "src/layouts/Layout.astro"
  "src/layouts/MainLayout.astro"
)

# Página principal
ROOT_PAGES=("src/pages/index.astro")

# Idiomas y subpáginas
LOCALES=(en es pt it)
SUBPAGES=(index contacto nosotros privacidad servicios 404)

# 🧠 Reemplazos seguros usando template literals en href y src
function fix_paths() {
  local file=$1

  echo "🛠️  Corrigiendo rutas en: $file"

  # Solo si es archivo Astro o HTML
  if [[ "$file" == *.astro || "$file" == *.html ]]; then
    # Sustituye href="/algo" → href={`\${import.meta.env.BASE_URL}algo`}
    sed -i -E 's|href="/([^"]+)"|href={`'"'${import.meta.env.BASE_URL}'"'\1`}|g' "$file"

    # Sustituye src="/algo" → src={`\${import.meta.env.BASE_URL}algo`}
    sed -i -E 's|src="/([^"]+)"|src={`'"'${import.meta.env.BASE_URL}'"'\1`}|g' "$file"
  fi

  # Sustitución adicional en archivos JS/Config (cuando aplicable)
  sed -i "s|'/legal/|import.meta.env.BASE_URL|g" "$file"
  sed -i 's|"/legal/|import.meta.env.BASE_URL|g' "$file"
}

# Procesar archivos generales
for file in "${FILES[@]}"; do
  [ -f "$file" ] && fix_paths "$file"
done

# Componentes
for file in "${COMPONENTS[@]}"; do
  [ -f "$file" ] && fix_paths "$file"
done

# Layouts
for file in "${LAYOUTS[@]}"; do
  [ -f "$file" ] && fix_paths "$file"
done

# Página raíz
for file in "${ROOT_PAGES[@]}"; do
  [ -f "$file" ] && fix_paths "$file"
done

# Páginas por idioma
for lang in "${LOCALES[@]}"; do
  for page in "${SUBPAGES[@]}"; do
    file="src/pages/$lang/${page}.astro"
    [ -f "$file" ] && fix_paths "$file"
  done
done

echo "✅ Todas las rutas han sido corregidas con éxito."
echo "📦 Ejecuta ahora: pnpm dev"
