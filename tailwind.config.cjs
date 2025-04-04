module.exports = {
  darkMode: 'class', // Activa el modo oscuro a través de la clase 'dark'
  content: ['./src/**/*.{astro,html,js,jsx,ts,tsx}'],
  theme: {
    extend: {
      colors: {
        'atlante-oscuro': '#0a2342',
        'dorado-tenue': '#d4af37',
        'gris-piedra': '#b0b0b0'
      },
    },
  },
  plugins: [],
};
