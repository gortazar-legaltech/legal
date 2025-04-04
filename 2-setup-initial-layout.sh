#!/bin/bash
set -e

echo "=== Configurando Layout Principal y Redirección Multiidioma ==="

# 1. Crear directorios necesarios
echo "Creando directorios..."
mkdir -p src/layouts src/styles src/pages

# 2. Crear archivo de redirección en src/pages/index.astro con la función get()
echo "Generando src/pages/index.astro (redirección a /es) utilizando Astro.redirect..."
cat << 'EOF' > src/pages/index.astro
---
export function get() {
  return Astro.redirect('/es');
}
---
EOF

# 3. Crear MainLayout.astro en src/layouts/
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
    <link rel="icon" type="image/png" href="/favicon.png" />
    <link rel="stylesheet" href="/styles/global.css" />
  </head>
  <body class="bg-gray-50">
    <header class="p-4 bg-gray-800 text-white">
      <div class="container mx-auto flex items-center justify-between">
        <!-- Logo -->
        <div class="logo">
          <img src="/logo.svg" alt="Buffete Legal" class="h-10" />
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
        <!-- Se puede incluir enlace o información de security.txt aquí -->
      </div>
    </footer>
  </body>
</html>
EOF

# 4. Crear tailwind.config.cjs en la raíz del proyecto (si no existe)
if [ ! -f tailwind.config.cjs ]; then
  echo "Generando tailwind.config.cjs..."
  cat << 'EOF' > tailwind.config.cjs
module.exports = {
  darkMode: 'class', // Activa el modo oscuro a través de la clase 'dark'
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

# 5. Crear archivo de estilos globales
echo "Generando src/styles/global.css..."
mkdir -p src/styles
cat << 'EOF' > src/styles/global.css
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Agrega aquí tus estilos personalizados y animaciones sutiles */
EOF

# 6. Ejecutar la build local para verificar la configuración
echo "Ejecutando npm run build para validar la configuración..."
npm run build

# 7. Preparar commit y push (opcional)
echo "Preparando cambios para commit..."
git add .
git commit -m "Configurado Layout Principal y redirección multiidioma con Astro.redirect"
echo "¡Estructura generada y lista para pushear al repositorio!"
