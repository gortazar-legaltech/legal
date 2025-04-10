import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'url';

// Función para generar páginas personalizadas a partir de "src/pages"

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const baseUrl = 'https://gortazar-legaltech.github.io';

// Función para generar páginas personalizadas a partir de "src/pages"
function generateCustomPages() {
  const locales = ['es', 'en', 'pt', 'it'];
  const pages = [];

  locales.forEach((locale) => {
    // Construye la ruta absoluta a la carpeta de cada idioma
    const localeDir = path.join(__dirname, 'src', 'pages', locale);
    if (fs.existsSync(localeDir)) {
      // Función recursiva para recorrer la carpeta
      const traverseDir = (dir, relativePath = '') => {
        const items = fs.readdirSync(dir);
        items.forEach((item) => {
          const fullPath = path.join(dir, item);
          const stat = fs.statSync(fullPath);
          if (stat.isDirectory()) {
            traverseDir(fullPath, path.join(relativePath, item));
          } else if (item.endsWith('.astro') || item.endsWith('.md')) {
            // Remueve la extensión (.astro o .md)
            const pageName = item.replace(/\.astro$|\.md$/, '');
            // Construye la URL en función de si es "index" u otro archivo
            let url;
            if (pageName === 'index') {
              url = relativePath ? `/${locale}/${relativePath}/` : `/${locale}/`;
            } else {
              url = relativePath ? `/${locale}/${relativePath}/${pageName}/` : `/${locale}/${pageName}/`;
            }
            // Asegura que se usen barras "/" incluso en Windows
            url = url.replace(/\\/g, '/');
            pages.push(`${baseUrl}${url}`);
          }
        });
      };

      traverseDir(localeDir);
    }
  });

  return pages;
}





export default defineConfig({
  site: baseUrl,
  base: '/',
  trailingSlash: 'always',
  outDir: './dist',
  vite: {
    optimizeDeps: {
      // Evita que Vite intente preoptimizar "astro/server"
      exclude: ['astro/server']
    },
    ssr: {
      // Marca "astro/server" como externo para la compilación SSR
      external: ['astro/server']
    },
    resolve: {
      alias: {
        // Redirige "astro/server" a "astro/runtime/server"
        'astro/server': 'astro/runtime/server'
      }
    }
  },
  integrations: [
    sitemap({
      i18n: {
        defaultLocale: 'es',
        locales: {
          es: 'es-ES',
          en: 'en-US',
          pt: 'pt-PT',
          it: 'it-IT'
        },
        routes: {
          es: '/es/',
          en: '/en/',
          pt: '/pt/',
          it: '/it/'
        }
      },
      customPages: generateCustomPages(),
      filter: (page) => !page.includes('404')
    })
  ]
});




// import { defineConfig } from 'astro/config';
// import sitemap from '@astrojs/sitemap';
// import node from '@astrojs/node'; // ← SSR aquí
//
// const sitemapI18n = {
//   defaultLocale: 'es',
//   locales: {
//     es: 'es-ES',
//     en: 'en-US',
//     pt: 'pt-PT',
//     it: 'it-IT',
//   }
// };
//
// export default defineConfig({
//   site: 'https://gortazar-legaltech.github.io/legal/',
//   base: '/',
//   outDir: './dist',
//   trailingSlash: 'always',
//   integrations: [
//     sitemap({
//       changefreq: 'weekly',
//       priority: 0.8,
//       // Este es el que usa Astro internamente (como array)
//       i18n: {
//            defaultLocale: 'es',
//            locales: {
//              es: 'es-ES',
//              en: 'en-US',
//              pt: 'pt-PT',
//              it: 'it-IT',
//            },
//          },
//     filter: (page) => !page.includes('/404'),
//     customPages: [
//       '/es', '/en', '/pt', '/it',
//       '/es/contacto', '/en/contacto', '/pt/contacto', '/it/contacto',
//       '/es/nosotros', '/en/nosotros', '/pt/nosotros', '/it/nosotros',
//       '/es/privacidad', '/en/privacidad', '/pt/privacidad', '/it/privacidad',
//       '/es/servicios', '/en/servicios', '/pt/servicios', '/it/servicios',
//     ],
//   ],
// });
