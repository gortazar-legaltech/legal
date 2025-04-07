import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  // URL base de tu sitio, esencial para generar URLs absolutas y sitemaps precisos
  site: 'https://gortazar-legaltech.github.io/',

  // Subdirectorio desde el cual se servirá el sitio
  base: '/legal/',

  // Controla la presencia de la barra inclinada al final de las URLs
  trailingSlash: 'never', // Opciones: 'always', 'never', 'ignore'

  // Directorio de salida para los archivos generados durante la compilación
  outDir: './dist',

  // Directorio para activos estáticos
  publicDir: './public',

  // Integraciones adicionales
  integrations: [
    sitemap({
      filter: (page) => !page.includes('/exclude-this-page'), // Excluye páginas específicas del sitemap
      customPages: [
        'https://gortazar-legaltech.github.io/legal/es',
      ], // Añade páginas personalizadas al sitemap
      changefreq: 'weekly', // Frecuencia de cambio de las páginas
      priority: 0.8, // Prioridad de las páginas
      i18n: {
        defaultLocale: '/es',
        locales: {
          es: 'es-ES',
          en: 'en-US',
          pt: 'pt-PT',
          it: 'it-IT',
        },
      }, // Configuración de internacionalización para el sitemap
    }),
  ],

  // Configuración de internacionalización
  i18n: {
    defaultLocale: 'es',
    locales: ['es', 'en', 'pt', 'it'],
    routing: {
      prefixDefaultLocale: false, // No añade prefijo al idioma por defecto
      redirectToDefaultLocale: true, // Redirige a la versión en el idioma por defecto si no se especifica idioma
    },
    fallback: {
      pt: 'es', // Si no se encuentra una página en portugués, muestra la versión en español
      it: 'en', // Si no se encuentra una página en italiano, muestra la versión en inglés
    },
  },

  // Configuración de construcción
  build: {
    assets: '_astro', // Directorio para activos generados por Astro
    format: 'directory', // Formato de salida de las páginas
  },
});
