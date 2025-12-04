import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  output: "server",
  session: {
    driver: "memory"
  },
  plugins: [
    tailwindcss(),
  ],

  vite: {
    plugins: [tailwindcss()],
  },
})