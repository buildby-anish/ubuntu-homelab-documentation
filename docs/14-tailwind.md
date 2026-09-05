# 14 — Tailwind CSS

## Important distinction

Tailwind CSS is a frontend styling framework/toolchain. It is not a required component of the Ubuntu server itself.

Use it inside your web applications.

Official documentation:

https://tailwindcss.com/docs/installation/tailwind-cli

## CLI installation

```bash
npm install tailwindcss @tailwindcss/cli
```

Create `src/input.css`:

```css
@import "tailwindcss";
```

Run:

```bash
npx @tailwindcss/cli -i ./src/input.css -o ./src/output.css --watch
```

## Example project

```text
web-app/
├── src/
│   ├── input.css
│   ├── output.css
│   └── index.html
├── package.json
└── ...
```

## Docker deployment

A production frontend can be built in one container stage and served by Nginx/Caddy in another.

Conceptual flow:

```text
Node build container
      |
      | npm run build
      v
static files
      |
      v
Nginx/Caddy container
```

## Tailwind with Vite/frameworks

Official framework guides:

https://tailwindcss.com/docs/installation/framework-guides
