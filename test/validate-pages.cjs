const fs = require('fs');
const path = require('path');

const langs = ['es', 'en', 'pt', 'it'];
const pages = ['index.astro', 'contacto.astro', 'nosotros.astro', 'servicios.astro', 'privacidad.astro'];

let missing = [];

langs.forEach(lang => {
  pages.forEach(page => {
    const filePath = path.join('src', 'pages', lang, page);
    if (!fs.existsSync(filePath)) {
      missing.push(filePath);
    }
  });
});

if (missing.length > 0) {
  console.error("❌ Faltan archivos .astro requeridos:");
  missing.forEach(file => console.error(" - " + file));
  process.exit(1);
} else {
  console.log("✅ Todas las páginas existen correctamente.");
}
