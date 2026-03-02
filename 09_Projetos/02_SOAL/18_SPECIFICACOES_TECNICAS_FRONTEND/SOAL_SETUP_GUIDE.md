# SOAL Frontend: Manual Setup Guide

> **Note:** The AI Agent could not detect `npm` or `node` in the current environment path. Please execute these commands in your terminal to initialize the project with the approved "Industrial Precision" architecture.

## 1. Prerequisites
Ensure you have Node.js 18+ installed.
```bash
node -v
# Should be v18.17.0 or higher
```

## 2. Initialize Next.js Project
Run this command from the `business-discoveries` root directory:

```bash
# Initialize the app (Use 'frontend' as the project name)
npx create-next-app@latest frontend --typescript --tailwind --eslint --no-src-dir --app --import-alias "@/*"
```
*If asked to proceed, say **Yes**.*

## 3. Install Core Dependencies
We need these for the dashboards:

```bash
cd frontend
npm install lucide-react recharts clsx tailwind-merge
```

## 4. Install Shadcn UI (The Design System)
Initialize the component library with these specific settings to match the Dark Industrial theme:

```bash
npx shadcn-ui@latest init
```
**Select these options:**
- Which style would you like to use? › **Default**
- Which color would you like to use as base color? › **Slate**
- Do you want to use CSS variables for colors? › **yes**

## 5. Next Steps for the AI (Claude Code)
Once this setup is done, you can ask Claude Code to:
1. "Implement the dashboards defined in `SOAL_FRONTEND_MASTERPLAN.md`."
2. "Use the prompts in `dashboard_design_prompts.md` for the UI logic."

The Masterplan contains all the color tokens and component specs needed.
