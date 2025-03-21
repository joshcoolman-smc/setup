# Next.js Project Setup Script

A script to quickly bootstrap a Next.js project with a modern stack and best practices.

## Features

The setup script provides a Next.js project with:

- TypeScript support
- ESLint configuration
- Tailwind CSS v4 for styling
- ShadcnUI components with latest patterns
- Dark mode support via next-themes
- Proper directory structure with src/ directory
- App Router
- Pre-configured components:
  - Theme toggle with dark/light mode
  - Global navigation bar
  - Responsive layout
  - Custom font (Bitter) integration

## Prerequisites

Make sure you have the following installed:

- Node.js (Latest LTS version recommended)
- pnpm (Package manager)
- Git

## Usage

Run the setup script from your desired parent directory:

```bash
./setup/next.sh your-app-name
```


The script will:
1. Create a new directory with your app name
2. Initialize a Next.js project with TypeScript and Tailwind CSS
3. Install and configure additional dependencies
4. Set up ShadcnUI components
5. Create theme components for dark mode support
6. Start the development server

## Project Structure

The script creates the following structure:

```
your-app-name/
├── public/
│   └── images/
├── src/
│   ├── app/
│   │   ├── favicon.ico
│   │   ├── globals.css
│   │   ├── layout.tsx
│   │   └── page.tsx
│   └── components/
│       ├── global-nav.tsx
│       ├── theme-provider.tsx
│       ├── theme-toggle.tsx
│       └── ui/
│           └── (shadcn components)
├── .env
├── .env.local
├── next.config.mjs
├── package.json
├── tailwind.config.ts
└── tsconfig.json
```

## Components

### Theme Provider
- Wraps the application with next-themes provider
- Enables system-wide dark/light mode support
- Persists theme preference

### Global Navigation
- Responsive navigation bar
- Displays app title
- Includes theme toggle button

### Theme Toggle
- Interactive dark/light mode toggle
- Smooth transition animations
- Accessible button with proper ARIA labels
- Handles SSR hydration correctly

## Conventions

The setup follows these conventions:

- Uses the App Router for routing
- Implements "use client" directives where needed
- Follows Next.js 13+ best practices
- Uses Tailwind CSS for styling
- Implements proper dark mode support using Tailwind's dark: modifier
- Uses ShadcnUI components for consistent UI elements
- Follows TypeScript best practices

## Development

After setup, you can:

1. Navigate to your project:
```bash
cd your-app-name
```

2. Start the development server:
```bash
pnpm run dev
```

3. Open [http://localhost:3000](http://localhost:3000) in your browser

## Customization

You can customize the setup by:

- Modifying the theme in `tailwind.config.ts`
- Adding new ShadcnUI components as needed
- Customizing the layout in `src/app/layout.tsx`
- Adding new pages in the `src/app` directory
- Creating new components in `src/components`
