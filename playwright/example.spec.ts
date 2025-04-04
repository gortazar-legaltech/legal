import { test, expect } from '@playwright/test';

test('Homepage carga correctamente', async ({ page }) => {
  await page.goto('http://localhost:4321/legal/es');
  await expect(page).toHaveTitle(/Buffete Legal/);
});
