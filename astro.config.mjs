import { defineConfig } from 'astro/config';
import sitemap from "@astrojs/sitemap";
export default defineConfig({
  site: 'https://gortazar-legaltech.github.io/',
  integrations: [sitemap()],
  outDir: './dist',
  base: 'legal/',
});
