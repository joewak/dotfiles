# Stripe Connect Embedded Components - Customization Guide

Complete guide for customizing the appearance and behavior of Stripe Connect embedded components to match your application's brand and user experience.

## Appearance API

The Appearance API allows you to customize the visual design of all embedded components to match your brand.

### Configuration Structure

```javascript
const stripeConnectInstance = loadConnectAndInitialize({
  publishableKey: 'pk_test_...',
  fetchClientSecret,
  appearance: {
    overlays: 'dialog',  // or 'drawer'
    variables: {
      // Color variables
      colorPrimary: '#0055DE',
      colorBackground: '#FFFFFF',
      colorText: '#30313D',
      colorDanger: '#DF1B41',
      colorSuccess: '#00A62F',
      colorWarning: '#F5A623',
      
      // Typography
      fontFamily: 'system-ui, -apple-system, sans-serif',
      fontSizeBase: '16px',
      fontWeightNormal: '400',
      fontWeightMedium: '500',
      fontWeightBold: '700',
      
      // Spacing
      spacingUnit: '4px',
      
      // Borders and Radius
      borderRadius: '8px',
      
      // Shadows
      boxShadowFocus: '0 0 0 3px rgba(0, 85, 222, 0.2)'
    },
    rules: {
      // Advanced CSS-like rules for specific elements
      '.Label': {
        fontWeight: '500',
        marginBottom: '8px'
      },
      '.Input': {
        border: '1px solid #E3E8EE',
        padding: '12px'
      }
    }
  }
});
```

## Color Variables

### Primary Color
`colorPrimary` - Main brand color used for buttons, links, and interactive elements.

**Usage:**
- Primary action buttons
- Links
- Selected states
- Focus indicators

**Example:**
```javascript
variables: {
  colorPrimary: '#625AFA'  // Your brand color
}
```

### Background Colors
- `colorBackground` - Main background color (default: white)
- `colorBackgroundSecondary` - Secondary background for cards/panels

**Example:**
```javascript
variables: {
  colorBackground: '#FFFFFF',
  colorBackgroundSecondary: '#F8F9FA'
}
```

### Text Colors
- `colorText` - Primary text color
- `colorTextSecondary` - Secondary/muted text
- `colorTextPlaceholder` - Placeholder text in inputs

**Example:**
```javascript
variables: {
  colorText: '#1A1B1F',
  colorTextSecondary: '#6B7280',
  colorTextPlaceholder: '#9CA3AF'
}
```

### Status Colors
- `colorDanger` - Errors and destructive actions
- `colorSuccess` - Success states
- `colorWarning` - Warning states

**Example:**
```javascript
variables: {
  colorDanger: '#DC2626',
  colorSuccess: '#059669',
  colorWarning: '#D97706'
}
```

## Typography Variables

### Font Family
`fontFamily` - CSS font stack for all text.

**Best Practices:**
- Include system fonts as fallbacks
- Ensure web fonts are loaded before initializing components
- Consider performance impact of custom fonts

**Example:**
```javascript
variables: {
  fontFamily: 'Inter, system-ui, -apple-system, BlinkMacSystemFont, sans-serif'
}
```

### Font Sizes
- `fontSizeBase` - Base font size (default: 16px)
- Components scale from this value

**Example:**
```javascript
variables: {
  fontSizeBase: '14px'  // Smaller for dense UIs
}
```

### Font Weights
- `fontWeightNormal` - Regular text (400)
- `fontWeightMedium` - Medium emphasis (500)
- `fontWeightBold` - Strong emphasis (700)

**Example:**
```javascript
variables: {
  fontWeightNormal: '400',
  fontWeightMedium: '600',
  fontWeightBold: '800'
}
```

## Layout Variables

### Spacing
`spacingUnit` - Base spacing unit that scales throughout components (default: 4px)

**Usage:**
- Padding
- Margins
- Gap between elements

**Example:**
```javascript
variables: {
  spacingUnit: '6px'  // Increases overall spacing
}
```

### Border Radius
`borderRadius` - Corner rounding for buttons, inputs, and cards.

**Example:**
```javascript
variables: {
  borderRadius: '12px'  // More rounded corners
}
```

## Overlay Behavior

Controls how components display when they need to show modal/popup content.

**Options:**
- `'dialog'` - Centered modal overlay (default)
- `'drawer'` - Side panel that slides in

**Example:**
```javascript
appearance: {
  overlays: 'drawer'  // Use drawer for mobile-friendly UX
}
```

## Advanced Customization with Rules

The `rules` object allows CSS-like styling for specific component elements.

### Available Selectors

#### Form Elements
- `.Input` - Text inputs
- `.Label` - Form labels
- `.Button` - Buttons
- `.Select` - Dropdown selects
- `.Checkbox` - Checkboxes
- `.Radio` - Radio buttons

#### Layout Elements
- `.Container` - Main containers
- `.Card` - Card components
- `.Section` - Content sections
- `.Header` - Headers
- `.Footer` - Footers

#### Status Elements
- `.Error` - Error messages
- `.Success` - Success messages
- `.Warning` - Warning messages

### Example Rules

```javascript
rules: {
  '.Input': {
    border: '2px solid #E5E7EB',
    borderRadius: '8px',
    padding: '12px 16px',
    fontSize: '16px',
    transition: 'border-color 0.2s'
  },
  '.Input:focus': {
    borderColor: '#3B82F6',
    outline: 'none',
    boxShadow: '0 0 0 3px rgba(59, 130, 246, 0.1)'
  },
  '.Button': {
    borderRadius: '8px',
    padding: '12px 24px',
    fontWeight: '600',
    textTransform: 'uppercase',
    letterSpacing: '0.5px'
  },
  '.Label': {
    fontSize: '14px',
    fontWeight: '600',
    marginBottom: '8px',
    color: '#374151'
  }
}
```

## Brand Presets

### Minimal Design
```javascript
appearance: {
  variables: {
    colorPrimary: '#000000',
    colorBackground: '#FFFFFF',
    colorText: '#000000',
    fontFamily: 'system-ui, sans-serif',
    spacingUnit: '8px',
    borderRadius: '4px'
  }
}
```

### Modern SaaS
```javascript
appearance: {
  variables: {
    colorPrimary: '#6366F1',
    colorBackground: '#FFFFFF',
    colorText: '#111827',
    colorTextSecondary: '#6B7280',
    fontFamily: 'Inter, system-ui, sans-serif',
    spacingUnit: '4px',
    borderRadius: '8px'
  },
  overlays: 'dialog'
}
```

### Dark Mode
```javascript
appearance: {
  variables: {
    colorPrimary: '#60A5FA',
    colorBackground: '#1F2937',
    colorBackgroundSecondary: '#111827',
    colorText: '#F9FAFB',
    colorTextSecondary: '#9CA3AF',
    fontFamily: 'system-ui, sans-serif',
    borderRadius: '8px'
  }
}
```

### Playful/Consumer
```javascript
appearance: {
  variables: {
    colorPrimary: '#EC4899',
    colorBackground: '#FFF7ED',
    colorText: '#1F2937',
    fontFamily: 'Poppins, system-ui, sans-serif',
    spacingUnit: '6px',
    borderRadius: '16px'
  },
  overlays: 'drawer'
}
```

## Dynamic Theme Switching

You can update the appearance after initialization:

```javascript
// Initial setup
const stripeConnectInstance = loadConnectAndInitialize({
  publishableKey: 'pk_test_...',
  fetchClientSecret,
  appearance: lightTheme
});

// Switch to dark mode
function enableDarkMode() {
  stripeConnectInstance.update({
    appearance: darkTheme
  });
}

// Switch back to light mode
function enableLightMode() {
  stripeConnectInstance.update({
    appearance: lightTheme
  });
}
```

## Responsive Considerations

Components are responsive by default, but you can enhance mobile experience:

```javascript
appearance: {
  overlays: 'drawer',  // Better for mobile
  variables: {
    fontSizeBase: window.innerWidth < 768 ? '14px' : '16px',
    spacingUnit: window.innerWidth < 768 ? '3px' : '4px'
  }
}
```

## Component-Specific Customization

### Account Onboarding
The onboarding component respects all appearance settings and adjusts its multi-step flow accordingly.

**Best Practices:**
- Use clear, readable fonts
- Ensure sufficient color contrast
- Test with actual user data

### Notification Banner
Ensure the banner is visually distinct:

```javascript
rules: {
  '.NotificationBanner': {
    backgroundColor: '#FEF3C7',
    borderLeft: '4px solid #F59E0B',
    padding: '16px'
  }
}
```

### Payments List
Large data tables benefit from:
- Adequate spacing
- Clear hover states
- Readable at standard zoom levels

```javascript
rules: {
  '.Table': {
    fontSize: '14px'
  },
  '.TableRow:hover': {
    backgroundColor: '#F9FAFB'
  }
}
```

## Testing Your Customizations

### Visual Consistency Checklist
- [ ] All components use consistent colors
- [ ] Typography is readable at all sizes
- [ ] Interactive states (hover, focus, active) are clear
- [ ] Form validation errors are visible
- [ ] Success states are noticeable
- [ ] Components work on both light and dark backgrounds

### Accessibility Checklist
- [ ] Color contrast meets WCAG AA standards (4.5:1 for normal text)
- [ ] Focus indicators are visible
- [ ] Interactive elements have adequate touch targets (44x44px minimum)
- [ ] Text is readable without custom fonts loading

### Cross-Browser Testing
Test appearance in:
- Chrome/Edge
- Firefox
- Safari
- Mobile browsers (iOS Safari, Chrome Android)

## Common Pitfalls

### Avoid These Mistakes
1. **Too many custom rules** - Start with variables, use rules sparingly
2. **Overriding critical spacing** - Can break component layouts
3. **Extremely small fonts** - Below 14px causes readability issues
4. **Low contrast** - Ensure text is readable against backgrounds
5. **Inconsistent border radius** - Use the same value throughout
6. **Missing fallback fonts** - Always include system fonts

### Performance Tips
- Load web fonts asynchronously
- Use system fonts when possible for best performance
- Limit the number of custom rules
- Test with slow connections

## Examples by Use Case

### Financial Services (Conservative)
```javascript
appearance: {
  variables: {
    colorPrimary: '#003D82',
    colorBackground: '#FFFFFF',
    colorText: '#1A1A1A',
    fontFamily: 'Georgia, serif',
    borderRadius: '4px',
    spacingUnit: '4px'
  }
}
```

### E-Commerce Platform (Bold)
```javascript
appearance: {
  variables: {
    colorPrimary: '#FF6B35',
    colorBackground: '#FFFBF7',
    colorText: '#2D2D2D',
    fontFamily: 'Montserrat, sans-serif',
    borderRadius: '12px',
    spacingUnit: '5px'
  },
  overlays: 'drawer'
}
```

### Tech Startup (Modern)
```javascript
appearance: {
  variables: {
    colorPrimary: '#7C3AED',
    colorBackground: '#FAFAFA',
    colorText: '#18181B',
    fontFamily: 'Inter, system-ui, sans-serif',
    borderRadius: '8px',
    spacingUnit: '4px'
  }
}
```

## Best Practices Summary

1. **Start Simple** - Begin with color and font variables
2. **Test Thoroughly** - Verify on all target devices and browsers
3. **Maintain Consistency** - Use the same design tokens across your app
4. **Prioritize Accessibility** - Ensure all users can interact effectively
5. **Document Your Theme** - Keep appearance config in version control
6. **Update Gradually** - Test appearance changes in staging first
