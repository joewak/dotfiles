---
name: stripe-connect
description: Expert knowledge for integrating Stripe Connect API with embedded components in custom applications. Use when adding or modifying Stripe API calls, implementing account onboarding, account management, payment processing, or payout workflows. Always uses v1 of the Stripe Accounts API. Focuses on embedded stripe controls within custom applications (never redirects to Stripe-hosted pages).
---

# Stripe Connect - Embedded Components Integration

Expert guidance for integrating Stripe Connect API with fully embedded components in custom applications.

## Core Principles

### Always Keep Users In-App
- NEVER redirect users to stripe.com or Stripe-hosted pages
- ALL workflows use embedded Stripe components within your application
- Users interact with Stripe functionality through your custom interface

### V1 Accounts API
- Always use v1 of the Stripe Accounts API (`/v1/accounts`)
- For SDK versions: Use `.v1` method variants (e.g., `client.v1.accounts.create()`)
- Never use v2 endpoints unless explicitly specified

### Account Session Pattern
All embedded components follow this pattern:
1. Create an AccountSession server-side with components enabled
2. Initialize ConnectJS client-side with publishable key and client secret fetcher
3. Render the embedded component in your UI

## Required Components for Full Integration

Your integration MUST include these components:
- **Account Onboarding**: Collect requirements for new accounts
- **Account Management**: Allow account updates and compliance responses
- **Notification Banner**: Alert users to outstanding requirements
- **Documents**: Access to tax documents (when Stripe collects fees from accounts)
- **Dispute handling**: Via Payments, Payment Details, or Disputes components

## Creating Connected Accounts

Create accounts with embedded components and no Stripe Dashboard access:

```javascript
const account = await stripe.accounts.create({
  country: 'US',
  controller: {
    stripe_dashboard: {
      type: 'none'  // No Stripe Dashboard access
    }
  },
  capabilities: {
    card_payments: { requested: true },
    transfers: { requested: true }
  }
});
```

## Account Sessions

Create server-side endpoint to generate AccountSession with enabled components:

```javascript
app.post('/account_session', async (req, res) => {
  const accountSession = await stripe.accountSessions.create({
    account: connectedAccountId,
    components: {
      account_onboarding: { enabled: true },
      account_management: {
        enabled: true,
        features: { external_account_collection: true }
      },
      notification_banner: {
        enabled: true,
        features: { external_account_collection: true }
      },
      payments: {
        enabled: true,
        features: {
          refund_management: true,
          dispute_management: true,
          capture_payments: true
        }
      },
      payouts: {
        enabled: true,
        features: {
          instant_payouts: true,
          standard_payouts: true,
          edit_payout_schedule: true,
          external_account_collection: true
        }
      },
      documents: { enabled: true }
    }
  });
  
  res.json({ client_secret: accountSession.client_secret });
});
```

## Client-Side Integration

### Initialize Connect.js

```javascript
import { loadConnectAndInitialize } from '@stripe/connect-js';

const fetchClientSecret = async () => {
  const response = await fetch('/account_session', { method: 'POST' });
  const { client_secret } = await response.json();
  return client_secret;
};

const stripeConnectInstance = loadConnectAndInitialize({
  publishableKey: 'pk_test_...',
  fetchClientSecret,
  appearance: {
    overlays: 'dialog',
    variables: {
      colorPrimary: '#625afa'  // Customize to match your brand
    }
  }
});
```

### React Integration

```javascript
import { ConnectComponentsProvider } from '@stripe/react-connect-js';

function App() {
  return (
    <ConnectComponentsProvider connectInstance={stripeConnectInstance}>
      {/* Your embedded components here */}
    </ConnectComponentsProvider>
  );
}
```

## Component Implementation

### Account Onboarding

**JavaScript:**
```javascript
const accountOnboarding = stripeConnectInstance.create('account-onboarding');
accountOnboarding.setOnExit(() => {
  // Check account status after onboarding
  // Verify details_submitted, charges_enabled, payouts_enabled
});
container.appendChild(accountOnboarding);
```

**React:**
```jsx
import { ConnectAccountOnboarding } from '@stripe/react-connect-js';

<ConnectAccountOnboarding
  onExit={() => {
    console.log('Onboarding complete');
  }}
/>
```

### Account Management

**JavaScript:**
```javascript
const accountManagement = stripeConnectInstance.create('account-management');
container.appendChild(accountManagement);
```

**React:**
```jsx
import { ConnectAccountManagement } from '@stripe/react-connect-js';

<ConnectAccountManagement />
```

### Notification Banner

Display prominently (e.g., top of dashboard) to show outstanding requirements:

**JavaScript:**
```javascript
const notificationBanner = stripeConnectInstance.create('notification-banner');
container.appendChild(notificationBanner);
```

**React:**
```jsx
import { ConnectNotificationBanner } from '@stripe/react-connect-js';

<ConnectNotificationBanner />
```

### Payments

**JavaScript:**
```javascript
const payments = stripeConnectInstance.create('payments');
container.appendChild(payments);
```

**React:**
```jsx
import { ConnectPayments } from '@stripe/react-connect-js';

<ConnectPayments />
```

### Payment Details

For individual payment detail views:

**JavaScript:**
```javascript
const paymentDetails = stripeConnectInstance.create('payment-details', {
  payment: paymentIntentId
});
container.appendChild(paymentDetails);
```

**React:**
```jsx
import { ConnectPaymentDetails } from '@stripe/react-connect-js';

<ConnectPaymentDetails payment={paymentIntentId} />
```

### Payouts

**JavaScript:**
```javascript
const payouts = stripeConnectInstance.create('payouts');
container.appendChild(payouts);
```

**React:**
```jsx
import { ConnectPayouts } from '@stripe/react-connect-js';

<ConnectPayouts />
```

### Balances

**JavaScript:**
```javascript
const balances = stripeConnectInstance.create('balances');
container.appendChild(balances);
```

**React:**
```jsx
import { ConnectBalances } from '@stripe/react-connect-js';

<ConnectBalances />
```

### Documents

**JavaScript:**
```javascript
const documents = stripeConnectInstance.create('documents');
container.appendChild(documents);
```

**React:**
```jsx
import { ConnectDocuments } from '@stripe/react-connect-js';

<ConnectDocuments />
```

## Accepting Payments (Direct Charges)

Always use Direct Charges pattern with application fees:

```javascript
// Create Checkout Session
const session = await stripe.checkout.sessions.create({
  mode: 'payment',
  line_items: [{
    price: priceId,
    quantity: 1
  }],
  payment_intent_data: {
    application_fee_amount: 123  // Your platform fee in cents
  },
  success_url: 'https://yourapp.com/success'
}, {
  stripeAccount: connectedAccountId  // Direct charge to connected account
});
```

## Customizing Component Appearance

Customize embedded components to match your brand:

```javascript
const stripeConnectInstance = loadConnectAndInitialize({
  publishableKey: 'pk_test_...',
  fetchClientSecret,
  appearance: {
    overlays: 'dialog',  // or 'drawer'
    variables: {
      colorPrimary: '#yourBrandColor',
      colorBackground: '#ffffff',
      colorText: '#333333',
      colorDanger: '#df1b41',
      fontFamily: 'Your Font, system-ui, sans-serif',
      spacingUnit: '4px',
      borderRadius: '8px'
    }
  }
});
```

## Webhooks & Event Handling

Listen for key events to manage account lifecycle:

```javascript
// account.updated - Check for details_submitted, charges_enabled
// payment_intent.succeeded - Payment completed
// checkout.session.completed - Checkout flow completed
// payout.created - Payout initiated
// charge.dispute.created - New dispute requires attention
```

## Email Communications Setup

Configure redirect URLs in Stripe Dashboard for email links:
1. Go to Dashboard > Connect Settings > Site Links
2. Set URLs for each embedded component page in your app
3. Stripe appends `stripe_account_id` parameter to identify the account

## Best Practices

### Authentication
- Implement strong authentication (2FA recommended) for sensitive actions
- Account management and payout changes require extra security

### Prefilling Information
- Prefill as much account information as possible to streamline onboarding
- Use the required verification info tool to know what to collect

### User Experience
- Place notification banner prominently
- Guide users through onboarding step-by-step
- Provide clear feedback on compliance status

### Error Handling
- Always handle AccountSession creation errors
- Check account status after onboarding completion
- Monitor webhook events for asynchronous updates

## Testing

Use test mode accounts and test cards:
- Test card: 4242 4242 4242 4242
- Test onboarding flow with different business types
- Verify all embedded components render correctly
- Test payment flow end-to-end

## Common Patterns

### Check Account Status After Onboarding
```javascript
accountOnboarding.setOnExit(async () => {
  const account = await stripe.accounts.retrieve(connectedAccountId);
  if (account.details_submitted && account.charges_enabled) {
    // Account ready for payments
  }
});
```

### Handle Multiple Components on Same Page
```javascript
// Notification banner at top
const banner = stripeConnectInstance.create('notification-banner');
headerContainer.appendChild(banner);

// Main content component
const payments = stripeConnectInstance.create('payments');
mainContainer.appendChild(payments);
```

## Required NPM Packages

```json
{
  "dependencies": {
    "@stripe/connect-js": "3.3.27",
    "@stripe/react-connect-js": "3.3.25",
    "stripe": "18.4.0"
  }
}
```

## Important Reminders

1. NEVER redirect to Stripe-hosted pages - always use embedded components
2. Use v1 Accounts API endpoints
3. Create AccountSession for each component session
4. Always include required components (onboarding, management, notification, documents)
5. Customize appearance to match your brand seamlessly
6. Implement proper authentication and security
7. Test thoroughly with test mode before going live

## Additional Resources

For detailed documentation and API reference, see:
- `references/components-guide.md` - Complete component integration guide
- `references/api-reference.md` - Stripe API methods and parameters
- `references/customization.md` - Appearance customization options
