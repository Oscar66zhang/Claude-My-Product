---
name: Serene Ledger
colors:
  surface: '#f8fafb'
  surface-dim: '#d8dadb'
  surface-bright: '#f8fafb'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f4f5'
  surface-container: '#eceeef'
  surface-container-high: '#e6e8e9'
  surface-container-highest: '#e1e3e4'
  on-surface: '#191c1d'
  on-surface-variant: '#3d4949'
  inverse-surface: '#2e3132'
  inverse-on-surface: '#eff1f2'
  outline: '#6d7979'
  outline-variant: '#bcc9c8'
  surface-tint: '#006a6a'
  primary: '#006a6a'
  on-primary: '#ffffff'
  primary-container: '#4ebaba'
  on-primary-container: '#004747'
  inverse-primary: '#6ed7d7'
  secondary: '#a8372d'
  on-secondary: '#ffffff'
  secondary-container: '#ff7768'
  on-secondary-container: '#710d0b'
  tertiary: '#924b25'
  on-tertiary: '#ffffff'
  tertiary-container: '#ee9468'
  on-tertiary-container: '#6b2c08'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#8bf3f3'
  primary-fixed-dim: '#6ed7d7'
  on-primary-fixed: '#002020'
  on-primary-fixed-variant: '#004f50'
  secondary-fixed: '#ffdad5'
  secondary-fixed-dim: '#ffb4aa'
  on-secondary-fixed: '#410001'
  on-secondary-fixed-variant: '#871f19'
  tertiary-fixed: '#ffdbcc'
  tertiary-fixed-dim: '#ffb693'
  on-tertiary-fixed: '#351000'
  on-tertiary-fixed-variant: '#75340f'
  background: '#f8fafb'
  on-background: '#191c1d'
  surface-variant: '#e1e3e4'
  expense-red: '#F26D5F'
  income-teal: '#4EBABA'
  surface-white: '#FFFFFF'
  text-primary: '#1A1C1E'
  text-secondary: '#6A7178'
typography:
  display-num:
    fontFamily: manrope
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -1px
  headline-lg:
    fontFamily: manrope
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-md:
    fontFamily: manrope
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: manrope
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: manrope
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.5px
  num-md:
    fontFamily: manrope
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  headline-lg-mobile:
    fontFamily: manrope
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  margin-mobile: 16px
  margin-tablet: 24px
  gutter: 12px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 24px
---

## Brand & Style

The design system is built on the pillars of **Trust, Calm, and Efficiency**. It targets the modern professional who values clarity over complexity. The brand personality is that of a quiet, reliable assistant—never intrusive, always helpful.

The chosen design style is **Minimalist Corporate Modern**. It avoids the clutter of traditional financial software in favor of a "lightweight" aesthetic. This is achieved through generous whitespace, a restricted color palette, and a focus on high-legibility typography. The interface should feel "airy" yet structured, using soft shadows and cards to create a sense of organized simplicity.

## Colors

The palette is strategically limited to promote financial focus and reduce cognitive load. 

- **Primary (Teal):** Used for primary actions, branding, and representing "Income." It evokes a sense of growth and stability.
- **Secondary (Orange-Red):** Reserved strictly for "Expenses" and critical warnings. This provides an immediate semantic signal to the user.
- **Neutral (Light Grayish White):** This serves as the foundational background color, providing a soft, low-glare surface that makes the card-based content pop.

**Color Application Rules:**
- Backgrounds should default to the neutral gray-white.
- Cards and high-level containers must use pure white to create a subtle "lift" effect.
- Interactive elements (like the floating action button) utilize the primary teal to signify the main task: adding a record.

## Typography

The design system utilizes **Manrope** across all levels for its exceptional balance between geometric modernism and functional legibility. Since the core of the product is financial data, specific attention is paid to numerical rendering.

- **Numbers-First Approach:** Financial totals use the `display-num` and `num-md` styles, which feature slightly tighter letter spacing and heavier weights to ensure they are the first thing a user sees.
- **Hierarchy:** Headlines are bold and concise. Labels use uppercase styling with increased letter spacing to differentiate metadata from core content.
- **Readability:** Body text maintains a comfortable line height to ensure that remarks and descriptions remain legible even on smaller mobile screens.

## Layout & Spacing

This design system employs a **fixed-width card layout** optimized for mobile interaction. The grid follows a strict 4-column structure on mobile devices, expanding to a centered container on larger screens.

**Spacing Principles:**
- **Rhythm:** A 4px/8px baseline grid ensures vertical consistency.
- **Safe Zones:** A 16px outer margin is mandatory on all mobile screens to prevent content from touching the device edges.
- **Grouping:** Use `stack-sm` (8px) for related elements (e.g., an icon and its label) and `stack-md` (16px) for separating logical sections within a card.
- **Reflow:** On tablets, cards can transition from a single-column list to a dual-column masonry or grid layout to maximize screen real estate.

## Elevation & Depth

To maintain a "lightweight" feel, the design system avoids heavy shadows and deep gradients. Instead, it uses **tonal layering** combined with **ambient shadows**.

- **Level 0 (Background):** The neutral light-grayish white base.
- **Level 1 (Cards):** Pure white surfaces with a soft, diffused shadow (Blur: 12px, Y: 4px, Opacity: 4%, Color: Primary-Teal-Tinted-Dark).
- **Level 2 (Interactive/Keypad):** Elements that are active or require immediate touch (like numeric buttons) use a slightly higher shadow or a high-contrast border to indicate tactility.
- **Overlays:** Modals and bottom sheets use a 40% opacity backdrop blur (Glassmorphism) to maintain context while focusing user attention on the entry task.

## Shapes

The shape language is **friendly and modern**, utilizing medium-high roundedness to soften the financial data's "hardness."

- **Cards & Inputs:** Standardized at 12px (`rounded-lg`) to create a cohesive container language.
- **Small Components:** Chips and small buttons use 8px (`rounded-md`).
- **Full Roundedness:** Success indicators, icons, and the main "Add" (+) button utilize a circular (pill-shaped) geometry to denote "Action" and "Complete."

## Components

### Buttons
- **Primary:** Filled with Primary Teal, white text, 12px rounded corners. Used for "Save" and "Add."
- **Secondary:** Light gray background or outline, used for "Cancel" or "Edit."

### Cards
- Standard records appear in white cards with 12px rounded corners. Each card includes a Lucide icon (left), category/remark text (center), and the amount (right).

### Input Fields & Keypad
- **Numeric Keypad:** High-contrast layout with large touch targets. Buttons have a subtle 1px border or a slight "lift" shadow.
- **Text Inputs:** Use a 1px soft teal border when focused, with a background color that matches the app background to remain unobtrusive.

### Chips & Categories
- Category selection uses a grid of "icon + text" chips. When selected, the icon container fills with Primary Teal, and the icon flips to white.

### Lists
- Lists use `gutter` spacing between items. Swipe actions (like Delete) reveal a Secondary Red background behind the card as it slides.

### Icons
- Use the **Lucide** set. Strokes should be consistent at 2px weight to match the clean typography. Emojis can be used as category backups for a more personal, "friendly" feel.