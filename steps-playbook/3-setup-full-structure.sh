#!/bin/bash
set -e

echo "=== Configurando estructura completa para GORTAZAR ==="

# 1. Crear directorios necesarios
echo "Creando directorios..."
mkdir -p src/{assets,components,layouts,pages,styles}
mkdir -p src/pages/{es,en,pt,it}

# 2. Generar archivo de redirección en src/pages/index.astro (raíz)
echo "Generando src/pages/index.astro (redirección a /es)..."
cat << 'EOF' > src/pages/index.astro
---
export function get() {
  return Astro.redirect('/es');
}
---
EOF

# 3. Crear el Layout Principal (src/layouts/MainLayout.astro)
echo "Generando src/layouts/MainLayout.astro..."
cat << 'EOF' > src/layouts/MainLayout.astro
---
const { title = 'Buffete Legal' } = Astro.props;
---
<!DOCTYPE html>
<html lang="es" class="dark">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>{title}</title>
    <!-- Favicon, metadatos SEO y Open Graph -->
    <link rel="icon" type="image/png" href="/assets/favicon.png" />
    <link rel="stylesheet" href="/styles/global.css" />
  </head>
  <body class="bg-gray-50">
    <header class="p-4 bg-gray-800 text-white">
      <div class="container mx-auto flex items-center justify-between">
        <!-- Logo -->
        <div class="logo">
          <img src="/assets/logo.svg" alt="Buffete Legal" class="h-10" />
        </div>
        <!-- Navegación responsive -->
        <nav>
          <ul class="flex space-x-4">
            <li><a href="/es/" class="hover:underline">Inicio</a></li>
            <li><a href="/es/nosotros" class="hover:underline">Nosotros</a></li>
            <li><a href="/es/servicios" class="hover:underline">Servicios</a></li>
            <li><a href="/es/contacto" class="hover:underline">Contacto</a></li>
          </ul>
        </nav>
      </div>
    </header>
    <main class="container mx-auto py-8">
      <slot />
    </main>
    <footer class="p-4 bg-gray-800 text-white">
      <div class="container mx-auto text-center">
        <p>&copy; {new Date().getFullYear()} Buffete Legal. Todos los derechos reservados.</p>
        <p>
          <a href="/es/privacidad" class="hover:underline">
            Política de Privacidad y RGPD
          </a>
        </p>
        <!-- Enlace a security.txt u otra info de seguridad -->
      </div>
    </footer>
  </body>
</html>
EOF

# 4. Crear archivo de configuración de Tailwind (tailwind.config.cjs)
if [ ! -f tailwind.config.cjs ]; then
  echo "Generando tailwind.config.cjs..."
  cat << 'EOF' > tailwind.config.cjs
module.exports = {
  darkMode: 'class', // Modo oscuro mediante la clase 'dark'
  content: ['./src/**/*.{astro,html,js,jsx,ts,tsx}'],
  theme: {
    extend: {
      colors: {
        'atlante-oscuro': '#0a2342',
        'dorado-tenue': '#d4af37',
        'gris-piedra': '#b0b0b0'
      },
    },
  },
  plugins: [],
};
EOF
else
  echo "tailwind.config.cjs ya existe. Saltando..."
fi

# 5. Crear archivo de estilos globales (src/styles/global.css)
echo "Generando src/styles/global.css..."
cat << 'EOF' > src/styles/global.css
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Estilos personalizados y animaciones sutiles */
EOF

# 6. Generar componente LanguageSwitcher (src/components/LanguageSwitcher.astro)
echo "Generando src/components/LanguageSwitcher.astro..."
cat << 'EOF' > src/components/LanguageSwitcher.astro
---
const languages = [
  { code: 'es', name: 'Español' },
  { code: 'en', name: 'English' },
  { code: 'pt', name: 'Português' },
  { code: 'it', name: 'Italiano' },
];
const currentLang = 'es'; // Lógica para determinar idioma actual, ajustar según sea necesario
---
<nav>
  <ul class="flex space-x-4">
    {languages.map(lang => (
      <li>
        <a href={\`/\${lang.code}/\`} class={lang.code === currentLang ? 'font-bold' : ''}>
          {lang.name}
        </a>
      </li>
    ))}
  </ul>
</nav>
EOF

# 7. Crear páginas base para cada idioma (ejemplo para español)
echo "Generando páginas base en src/pages/es/..."
for page in index nosotros servicios contacto privacidad 404; do
  echo "Generando src/pages/es/${page}.astro..."
  cat << EOF > src/pages/es/${page}.astro
---
import MainLayout from '../../layouts/MainLayout.astro';
const title = '${page^} - Buffete Legal';
---
<MainLayout title={title}>
  <section class="p-8">
    <h1>${page^}</h1>
    <p>Contenido de la página ${page} en español.</p>
  </section>
</MainLayout>
EOF
done

# Crear páginas vacías en los otros idiomas (en, pt, it) copiando el index de ejemplo
echo "Generando páginas base en otros idiomas (en, pt, it)..."
for lang in en pt it; do
  mkdir -p src/pages/$lang
  for page in index nosotros servicios contacto privacidad 404; do
    echo "Generando src/pages/${lang}/${page}.astro..."
    cat << EOF > src/pages/${lang}/${page}.astro
---
import MainLayout from '../../layouts/MainLayout.astro';
const title = '${page^} - Buffete Legal (${lang})';
---
<MainLayout title={title}>
  <section class="p-8">
    <h1>${page^} (${lang})</h1>
    <p>Contenido de la página ${page} en ${lang}.</p>
  </section>
</MainLayout>
EOF
  done
done

# 8. Generar assets placeholder (logo, favicon y firma digital)
echo "Generando assets de ejemplo en src/assets..."
mkdir -p src/assets
# Logo placeholder (SVG)
cat << 'EOF' > src/assets/logo.svg
<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">
  <rect width="100" height="100" fill="#0a2342"/>
  <text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" fill="#d4af37" font-size="20">Logo</text>
</svg>
EOF

# Favicon placeholder (PNG) – aquí solo creamos un archivo de texto para el ejemplo
echo "FAVICON" > src/assets/favicon.png

# Firma digital placeholder (SVG)
cat << 'EOF' > src/assets/firma.svg
<svg width="200" height="50" xmlns="http://www.w3.org/2000/svg">
  <text x="0" y="35" font-size="35" fill="#d4af37">Firma</text>
</svg>
EOF

# 9. Ejecutar la build local para verificar la configuración
echo "Ejecutando npm run build para validar la configuración..."
npm run build

# 10. Preparar commit y push (opcional)
echo "Preparando cambios para commit..."
git add .
git commit -m "Estructura completa generada: assets, components, layouts, pages y styles según branding GORTAZAR"
echo "¡Estructura generada y lista para pushear al repositorio!"
