import { defineConfig } from 'astro/config';
import sitemap from "@astrojs/sitemap";

export default defineConfig({
  site: 'https://gortazar-legaltech.github.io/legal/',
  base: '/legal/',
  outDir: './dist',
  integrations: [sitemap()],
});
