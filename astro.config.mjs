import { defineConfig } from 'astro/config';
import sitemap from "@astrojs/sitemap";
export default defineConfig({
  site: 'https://gortazar-legaltech.github.io/gortazar-legaltech/',
  integrations: [sitemap()],
  outDir: './dist',
  base: '/',
});
