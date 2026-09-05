/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        gold: {
          50: '#FFFDF0',
          100: '#FFF9C2',
          200: '#FFE866',
          300: '#FFD700',
          400: '#E5C158',
          500: '#D4AF37', // Primary Gold
          600: '#B58E29',
          700: '#996515',
          800: '#6B450B',
          900: '#3D2503',
        },
        dark: {
          950: '#070709', // Main background
          900: '#0C0D12', // Card background
          850: '#12141C', // Elevate background
          800: '#1A1D28', // Surface background
          700: '#2A2E3D', // Border color
          600: '#3F4457',
        }
      },
      fontFamily: {
        sans: ['Plus Jakarta Sans', 'Inter', 'system-ui', 'sans-serif'],
      },
      boxShadow: {
        'gold-sm': '0 2px 10px rgba(212, 175, 55, 0.12)',
        'gold-md': '0 4px 20px rgba(212, 175, 55, 0.2)',
        'gold-lg': '0 8px 30px rgba(212, 175, 55, 0.3)',
        'gold-glow': '0 0 25px rgba(212, 175, 55, 0.4)',
      },
      backgroundImage: {
        'gold-gradient': 'linear-[#D4AF37], #FFD700',
        'gold-metallic': 'linear-gradient(135deg, #BF953F 0%, #FCF6BA 25%, #B38728 50%, #FBF5B7 75%, #AA771C 100%)',
        'gold-text-grad': 'linear-gradient(135deg, #FFF099 0%, #D4AF37 50%, #996515 100%)',
        'dark-glass': 'linear-gradient(135deg, rgba(20, 20, 28, 0.8) 0%, rgba(12, 13, 18, 0.9) 100%)',
      }
    },
  },
  plugins: [],
}
