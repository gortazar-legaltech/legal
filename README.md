# GORTÁZAR LegalTech - Web Project

Proyecto web corporativo para **GORTÁZAR Legal Advisors**, desarrollado bajo estándares SDLC y metodología DevSecOps. Utiliza Astro con TailwindCSS para asegurar un rendimiento óptimo, diseño adaptativo y soporte multilingüe.

---

## 🌐 Contexto del Proyecto
Este repositorio es parte del ecosistema tecnológico de **ATLANTYDE**, enfocado en la innovación legal a través del uso intensivo de tecnología disruptiva, ofreciendo asesoramiento jurídico-tecnológico en múltiples idiomas: español (ES), portugués (PT), italiano (IT) e inglés (EN).

---

## 📌 Características Principales

- Diseño web responsive, optimizado para accesibilidad.
- Soporte multiidioma integrado con páginas específicas por idioma.
- SEO optimizado con metadata Open Graph.
- Validación automática mediante scripts de QA y pruebas SDLC (Playwright).
- Gestión de activos gráficos centralizada (`ASSETS.md`).

---

## 📚 Stack Tecnológico

- **Astro 5+**: Framework para generar sitios web ultrarrápidos.
- **TailwindCSS**: Estilización avanzada y minimalista.
- **Playwright**: Pruebas E2E automatizadas.
- **GitHub Actions**: CI/CD automatizado para validaciones SDLC.

---

## 🚀 Requisitos

- Node.js 18+
- Git
- Navegador compatible con estándares web recientes

---

## 📦 Instalación

```bash
npm install
```

## 🔧 Desarrollo Local

Para ejecutar el entorno local:
```bash
npm run dev
```

Acceso local disponible en: [http://localhost:4321/legal](http://localhost:4321/legal)

---

## 🛡️ Cumplimiento SDLC

Este repositorio incluye validaciones integrales del Ciclo de Vida de Desarrollo de Software (SDLC) para garantizar seguridad, eficiencia y estabilidad:

- **Pruebas unitarias y de estructura** (`/test/validate-pages.cjs`)
- **Pruebas E2E con Playwright** (accesibilidad, navegación y renderizado).
- **QA Scripts** (favicon, seguridad, integridad gráfica).

Ejecutar todas las validaciones SDLC:
```bash
sh test/run_sdlc_suite.sh
```

---

## 🔖 Documentación Gráfica

La documentación gráfica completa sobre activos visuales y directrices de diseño se encuentra en:
- [`ASSETS.md`](./ASSETS.md)

---

## 🌍 Internacionalización

El proyecto soporta múltiples idiomas mediante páginas dedicadas y un conmutador de idiomas integrado.

Generación automática de estructura multilingüe:
```bash
sh generear_multidioma.sh
```

---

## 📑 Licencia y Cumplimiento

Este proyecto cumple con estándares internacionales RGPD, accesibilidad web, seguridad digital y licencias abiertas adecuadas. El archivo `security.txt` está disponible públicamente en la carpeta:
- `/public/.well-known/security.txt`

---

## ⚖️ Contribuciones

Para contribuir, realizar un fork del proyecto, generar cambios en una rama separada y enviar una solicitud Pull Request detallada.

---

## 🔗 Enlaces Relacionados

- [ATLANTYDE - Innovación Legal y Tecnológica](https://atlantyde.com)
- [Documentación Astro](https://astro.build/docs)
- [Guía de TailwindCSS](https://tailwindcss.com/docs)

---

Para más información sobre configuraciones avanzadas y detalles técnicos adicionales, revisar los archivos específicos y scripts dentro del directorio `/test`.

