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

import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import fs from 'node:fs';
import path from 'node:path';

const baseUrl = 'https://gortazar-legaltech.github.io/';

function generateCustomPages() {
  const locales = ['es', 'en', 'pt', 'it'];
  const pages = [];

  for (const locale of locales) {
    const dir = `./src/pages/${locale}`;
    if (fs.existsSync(dir)) {
      const files = fs.readdirSync(dir);
      files.forEach((file) => {
        if (file.endsWith('.astro') || file.endsWith('.md')) {
          const page = file.replace('.astro', '').replace('.md', '');
          const url = page === 'index' ? `/${locale}/` : `/${locale}/${page}/`;
          pages.push(`${baseUrl}${url}`);
        }
      });
    }
  }

  return pages;
}

export default defineConfig({
  site: baseUrl,
  base: '/',
  trailingSlash: 'always',
  outDir: './dist',
  integrations: [
    sitemap({
      i18n: {
        defaultLocale: 'es',
        locales: {
          es: 'es-ES',
          en: 'en-US',
          pt: 'pt-PT',
          it: 'it-IT',
        }
      },
      customPages: generateCustomPages(),
      sitemap: `${baseUrl}/sitemap-index.xml`,
      filter: (page) => !page.includes('404'),
    }),
  ],
  i18n: {
    defaultLocale: 'es',
    locales: ['es', 'en', 'pt', 'it'],
    routing: {
      prefixDefaultLocale: false,
      redirectToDefaultLocale: true,
    },
    fallback: {
      pt: 'es',
      it: 'en',
    }
  }
});
