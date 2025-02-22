#!/bin/bash

# Check if an app name was provided as an argument
if [ -z "$1" ]; then
  echo "Error: Please provide a name for your Next.js app."
  echo "Usage: ./setup/next.sh <app-name>"
  exit 1
fi

APP_NAME=$1

# Convert the app name to title case
APP_TITLE=$(echo "$APP_NAME" | awk '{ for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2)) } 1')

# Step 1: Initialize a new Next.js app with canary version
echo "Initializing a new Next.js app named $APP_NAME..."
pnpm create next-app@canary "$APP_NAME" --ts --eslint --src-dir --app --import-alias "@/*" --tailwind --yes

# Step 2: Move into project directory and install dependencies
cd "$APP_NAME"
echo "Installing dependencies..."
pnpm install next-themes lucide-react

# Step 3: Initialize shadcn
echo "Initializing shadcn..."
pnpm dlx shadcn@canary init -d

# Step 4: Install all shadcn components
echo "Installing all shadcn components..."
pnpm dlx shadcn@canary add -a --overwrite -y

# Step 5: Create theme-provider.tsx component
echo "Creating theme-provider.tsx..."
mkdir -p src/components
cat > src/components/theme-provider.tsx <<EOL
"use client"

import * as React from "react"
import { ThemeProvider as NextThemesProvider } from "next-themes"
import { type ThemeProviderProps } from "next-themes/dist/types"

export function ThemeProvider({ children, ...props }: ThemeProviderProps) {
  return <NextThemesProvider {...props}>{children}</NextThemesProvider>
}
EOL

# Step 6: Create theme-toggle.tsx component
echo "Creating theme-toggle.tsx..."
cat > src/components/theme-toggle.tsx <<EOL
"use client"

import * as React from "react"
import { Moon, Sun } from "lucide-react"
import { useTheme } from "next-themes"
import { Button } from "@/components/ui/button"

export function ThemeToggle() {
  const [mounted, setMounted] = React.useState(false)

  React.useEffect(() => {
    setMounted(true)
  }, [])

  const { theme, setTheme } = useTheme()

  if (!mounted) {
    return <Button variant="outline" size="icon" />
  }

  return (
    <Button
      variant="outline"
      size="icon"
      onClick={() => setTheme(theme === "light" ? "dark" : "light")}
    >
      <Sun className="size-[1.2rem] rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
      <Moon className="absolute size-[1.2rem] rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
      <span className="sr-only">Toggle theme</span>
    </Button>
  )
}
EOL

# Step 7: Create global-nav.tsx component
echo "Creating global-nav.tsx..."
cat > src/components/global-nav.tsx <<EOL
import { ThemeToggle } from "@/components/theme-toggle"

export function GlobalNav() {
  return (
    <nav className="fixed top-0 left-0 right-0 flex justify-between items-center p-4 bg-zinc-300 dark:bg-black">
      <div className="text-2xl font-bold">$APP_TITLE</div>
      <ThemeToggle />
    </nav>
  )
}
EOL

# Step 8: Update layout.tsx
echo "Updating layout.tsx..."
cat > src/app/layout.tsx <<EOL
import type { Metadata } from "next";
import { Bitter } from "next/font/google";
import "./globals.css";
import { ThemeProvider } from "@/components/theme-provider";
import { GlobalNav } from "@/components/global-nav";

const bitter = Bitter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "$APP_TITLE",
  description: "Generated by create next app",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={\`\${bitter.className} antialiased\`}>
        <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
          <GlobalNav />
          {children}
        </ThemeProvider>
      </body>
    </html>
  );
}
EOL

# Step 9: Update page.tsx
echo "Updating page.tsx..."
cat > src/app/page.tsx <<EOL
import { Button } from "@/components/ui/button"

export default function Home() {
  return (
    <div className="flex items-center justify-center min-h-screen">
      <Button>Hello</Button>
    </div>
  );
}
EOL

# Step 10: Create conventions.md
echo "Creating conventions.md..."
cat > conventions.md <<EOL
# Folder Structure:
root
├── public
│   └── images
├── src
│   └── app
│       ├── favicon.ico
│       ├── globals.css
│       ├── layout.tsx
│       ├── page.tsx
│       └── components
│           ├── ui
│           ├── hooks
│           └── lib
├── .env
├── .env.local
├── next.config.mjs
├── package.json
├── README.md
├── tailwind.config.ts
└── tsconfig.json

# Conventions:
- Assume next-themes is being used and is already implemented
- Assume all ShadCN components are installed and available to use
- Use ShadCN components and lucide-react icons wherever possible
- All components should look good in dark or light mode using Tailwind's 'dark' modifier
- Add "use client" to the top of files which rely on React to maintain state or have interactivity or use hooks.
EOL

# Step 11: Create .aider.conf.yml
echo "Creating .aider.conf.yml..."
cat > .aider.conf.yml <<EOL
read: ["conventions.md", "package.json"]
EOL

# Step 12: Create .clinerules
echo "Creating .clinerules..."
cat > .clinerules <<EOL
## General Guidelines
- prefer pnpm for installs
- focus on code changes, optimization and new code generation
- Focus on meaningful code changes specific to user requests. 

## Next JS App Guidelines
- Follow clean coding principles
- Code should be type safe
- Use professional and clear comments where helpful
- use shadcn components wherever possible
- prefer lucide react icons
- Assume next-themes is implemented and dark mode is default
- Use tailwind classes
- Prefer tailwind colors over custom css colors
- Assume app uses src dir 
- Assume app uses app router
- Assume all components must look good in either dark or light mode
- Page routes should remain server components
- Client-side functionality should be implemented in client components within feature folders
- Feature UI components should be client components
- State management and interactivity should be handled in client components

## Next JS App Architecture Guidelines
- Prefer feature module pattern: /src/app/features/[feature-name]
- Use Repository, Service, Hooks pattern where appropriate
- Repositories and Services should implement interfaces
- Use Zod for type inference and validation where appropriate
- Assume mock data should be generated in sufficient quantity to thoroughly test and review the feature requested. A mock data repository is the suggested approach.

## Import Guidelines
- Use @/ alias for all imports from the src directory
- Example: import { Button } from "@/components/ui/button"
- The @/ alias is properly configured in tsconfig.json
- Avoid relative paths for imports from src directory
- Keep imports organized and grouped by type (external, internal, etc.)

FEATURE FOLDER EXAMPLE
src/app/features/[feature-name]/
├── components/
├── hooks/
├── repository/
├── service/
├── types/
└── utils/
EOL

echo "Opening in VS Code..."
code .

echo "Setup complete! Your Next.js app with shadcn components is ready."
echo "To start developing, run: cd $APP_NAME && pnpm dev"