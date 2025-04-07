module.exports = {
  darkMode: 'class', // Gestión del modo oscuro mediante la clase 'dark'
  content: ['./src/**/*.{astro,html,js,jsx,ts,tsx}',
            './src/pages/**/*.{astro,html,js,ts}',
            './src/layouts/**/*.{astro,html,js,ts}',
            './src/components/**/*.{astro,html,js,ts}'],
  theme: {
    extend: {
      colors: {
        'atlante-oscuro': 'var(--color-atlante-oscuro)',
        'dorado-tenue': 'var(--color-dorado-tenue)',
        'gris-piedra': 'var(--color-gris-piedra)',
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
  ],
};
