import { defineConfig } from 'astro/config';
import sitemap from "@astrojs/sitemap";

export default defineConfig({
  site: 'https://gortazar-legaltech.github.io/',
  base: '/legal/',
  outDir: './dist',
  integrations: [sitemap()],
  i18n: {
    defaultLocale: 'es',
    locales: ['es', 'en', 'pt', 'it'],
  },
});
