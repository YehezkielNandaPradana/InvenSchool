---
name: InvenSchool System
colors:
  surface: '#f8f9fa'
  surface-dim: '#d9dadb'
  surface-bright: '#f8f9fa'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f4f5'
  surface-container: '#edeeef'
  surface-container-high: '#e7e8e9'
  surface-container-highest: '#e1e3e4'
  on-surface: '#191c1d'
  on-surface-variant: '#434655'
  inverse-surface: '#2e3132'
  inverse-on-surface: '#f0f1f2'
  outline: '#737686'
  outline-variant: '#c3c6d7'
  surface-tint: '#0053db'
  primary: '#004ac6'
  on-primary: '#ffffff'
  primary-container: '#2563eb'
  on-primary-container: '#eeefff'
  inverse-primary: '#b4c5ff'
  secondary: '#515f74'
  on-secondary: '#ffffff'
  secondary-container: '#d5e3fc'
  on-secondary-container: '#57657a'
  tertiary: '#6a1edb'
  on-tertiary: '#ffffff'
  tertiary-container: '#8343f4'
  on-tertiary-container: '#f7edff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dbe1ff'
  primary-fixed-dim: '#b4c5ff'
  on-primary-fixed: '#00174b'
  on-primary-fixed-variant: '#003ea8'
  secondary-fixed: '#d5e3fc'
  secondary-fixed-dim: '#b9c7df'
  on-secondary-fixed: '#0d1c2e'
  on-secondary-fixed-variant: '#3a485b'
  tertiary-fixed: '#eaddff'
  tertiary-fixed-dim: '#d2bbff'
  on-tertiary-fixed: '#25005a'
  on-tertiary-fixed-variant: '#5a00c6'
  background: '#f8f9fa'
  on-background: '#191c1d'
  surface-variant: '#e1e3e4'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 57px
    fontWeight: '700'
    lineHeight: 64px
    letterSpacing: -0.25px
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  title-lg:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0.5px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.25px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.1px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  container-padding-mobile: 16px
  container-padding-desktop: 32px
  gutter: 16px
---

## Brand & Style

This design system is built on the principles of Material Design 3, tailored for the high-utility environment of school inventory management. The brand personality is **reliable, efficient, and transparent**, ensuring that faculty and staff can manage assets with zero cognitive friction.

The visual style follows a **Modern Corporate** aesthetic:
- **Clarity First:** A focus on functional white space and high-contrast typography to ensure legibility in various lighting conditions (classrooms, warehouses, offices).
- **Professionalism:** Utilizing a disciplined blue primary palette to evoke trust and institutional stability.
- **Soft Precision:** Combining high-radius geometry (16-20px) with a rigorous 8dp grid to create an interface that feels both modern and mathematically sound.

## Colors

The palette is anchored by a vibrant **Institutional Blue** that drives action and identifies primary interactive elements. 

- **Primary (#2563EB):** Used for key actions, active states, and primary branding.
- **Surface & Background:** A clean white background (#FFFFFF) paired with a very light gray surface (#F9FAFB) for cards and containers to create subtle tonal separation without heavy borders.
- **Semantic Tokens:**
    - **Success:** Vibrant green for "In Stock" or "Repaired" statuses.
    - **Warning:** Amber for "Low Stock" or "Maintenance Due."
    - **Error:** Deep red for "Damaged," "Missing," or "Overdue."

## Typography

This design system utilizes **Inter** for all roles to maximize readability across dense data tables and inventory lists. 

- **Headlines:** Use Semi-Bold weights to provide clear section anchoring.
- **Body:** Set with generous line-height (1.5x) to prevent eye fatigue during long sessions of data entry.
- **Labels:** Used for table headers and button text, employing a slightly heavier weight (600) and increased letter spacing for rapid scanning.
- **Scaling:** Headlines shift to a smaller scale on mobile devices to preserve horizontal space for inventory counts.

## Layout & Spacing

The system is built on a strict **8dp grid**, ensuring all components align perfectly. 

- **Layout Model:** A fluid grid for mobile and tablet, transitioning to a 12-column fixed-max-width grid (1440px) for desktop management dashboards.
- **Margins:** 16px for mobile, 24px for tablet, and 32px for desktop views.
- **Consistency:** All component heights (buttons, inputs) should be multiples of 8px. Use 16px (md) as the standard padding for cards and containers.

## Elevation & Depth

In alignment with Material 3, depth is primarily conveyed through **Tonal Elevation** rather than heavy shadows.

- **Level 0 (Flat):** The main background (#FFFFFF).
- **Level 1 (Low):** Surface cards (#F9FAFB) with a very subtle, diffused shadow (4px blur, 2% opacity) to distinguish asset cards from the background.
- **Level 2 (Active):** Hovered cards or active dropdowns use a slightly more pronounced shadow (8px blur, 4% opacity).
- **Level 3 (Modal):** Dialogs and pop-overs use a 16px blur with 8% opacity to provide clear focus.

## Shapes

The shape language is approachable and modern, utilizing high-radius corners to soften the density of inventory data.

- **Small Components:** Checkboxes and small tags use `rounded-sm` (4px).
- **Medium Components:** Buttons and Input fields use `rounded-md` (8px).
- **Large Components:** Inventory cards, dialogs, and main containers use `rounded-xl` (20px) as the signature corner radius for the design system.

## Components

### Buttons
- **Primary:** Filled with #2563EB, white text, 20px corner radius.
- **Secondary:** Tonal palette (light blue background with dark blue text).
- **Icon Buttons:** Use Material Symbols (Rounded style), centered with 8px internal padding.

### Cards
- **Asset Card:** Uses Surface color (#F9FAFB), 20px radius, Level 1 elevation. Contains a clear image thumbnail with 12px radius.

### Input Fields
- **Search & Text:** Outlined style with 1px border (#E2E8F0). On focus, border thickens to 2px and changes to Primary Blue.

### Status Badges (Chips)
- **General:** Small, pill-shaped, 500-weight text.
- **Success Badge:** Light green background (#D1FAE5) with Dark green text (#065F46).
- **Warning Badge:** Light amber background (#FEF3C7) with Dark amber text (#92400E).
- **Error Badge:** Light red background (#FEE2E2) with Dark red text (#991B1B).

### Lists & Tables
- **Inventory Rows:** 56px minimum height. Use subtle 1px dividers (#F1F5F9).
- **Interactive Rows:** Shift background to #F1F5F9 on hover to indicate clickability.