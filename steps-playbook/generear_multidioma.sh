#!/bin/bash
set -e

# ============================================
# Script para generar la estructura multiidioma en Astro
# ============================================

# 1. Crear directorios necesarios
echo "Creando directorios de páginas y componentes..."
mkdir -p src/pages/es src/pages/en src/pages/pt src/pages/it src/components src/layouts

# 2. Crear redirección desde la raíz hacia el idioma por defecto (/es)
echo "Creando archivo de redirección en src/pages/index.astro..."
cat << 'EOF' > src/pages/index.astro
---
import { redirect } from 'astro/runtime/server';
redirect('/es');
---
EOF

# 3. Crear la página de inicio en español (src/pages/es/index.astro)
echo "Creando página de inicio en español..."
cat << 'EOF' > src/pages/es/index.astro
---
import MainLayout from '../../layouts/MainLayout.astro';
const title = 'Inicio - Buffete Legal';
---
<MainLayout title={title}>
  <section class="hero">
    <h1>Bienvenidos a Buffete Legal</h1>
    <p>Soluciones jurídicas con sabiduría ancestral y visión de futuro.</p>
    <!-- Aquí puedes agregar tu CTA, imágenes y demás elementos visuales -->
  </section>
</MainLayout>
EOF

# 4. Crear el componente LanguageSwitcher (src/components/LanguageSwitcher.astro)
echo "Creando componente LanguageSwitcher..."
cat << 'EOF' > src/components/LanguageSwitcher.astro
---
const languages = [
  { code: 'es', name: 'Español' },
  { code: 'en', name: 'English' },
  { code: 'pt', name: 'Português' },
  { code: 'it', name: 'Italiano' },
];
// Lógica simplificada: define el idioma actual. Adapta esta lógica según tus necesidades.
const currentLang = 'es';
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

# 5. Crear el layout principal (src/layouts/MainLayout.astro)
echo "Creando layout principal..."
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
    <!-- Aquí incluye favicon, metadatos SEO y Open Graph -->
  </head>
  <body class="bg-gray-50">
    <header>
      <!-- Inserta aquí tu logo, membrete y navegación responsive -->
      <astro-slot name="header" />
      <!-- Puedes incluir el LanguageSwitcher en el header o donde lo prefieras -->
      <slot name="LanguageSwitcher" />
    </header>
    <main>
      <slot />
    </main>
    <footer>
      <!-- Información legal, RGPD, política de privacidad, etc. -->
      <astro-slot name="footer" />
    </footer>
  </body>
</html>
EOF

echo "La estructura multiidioma se ha creado correctamente."
