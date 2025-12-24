# Stripe Connect Embedded Components - Complete Guide

This reference provides comprehensive details on all available embedded components for Stripe Connect integrations.

## Component Categories

### Onboarding and Compliance
- Account Onboarding
- Account Management
- Notification Banner

### Payments
- Payments (list view)
- Payment Details
- Disputes for a Payment
- Disputes List
- Payment Method Settings (Preview)

### Payouts
- Payouts
- Balances
- Payouts List
- Payout Details
- Instant Payouts Promotion

### Reporting
- Documents

## Account Onboarding Component

### Purpose
Collects all required information from connected accounts to enable payment processing. Handles all business types, document uploads, identity verification, and requirement validation.

### Server-Side Setup
```javascript
const accountSession = await stripe.accountSessions.create({
  account: connectedAccountId,
  components: {
    account_onboarding: {
      enabled: true,
      features: {
        external_account_collection: true,  // Default: true
        disable_stripe_user_authentication: false  // Default: false
      }
    }
  }
});
```

### Client-Side (JavaScript)
```javascript
const accountOnboarding = stripeConnectInstance.create('account-onboarding');

// Optional: Customize collection behavior
accountOnboarding.setCollectionOptions({
  fields: 'eventually_due',  // or 'currently_due'
  futureRequirements: 'include'  // or 'omit'
});

// Optional: Custom policy URLs
accountOnboarding.setFullTermsOfServiceUrl('https://yourapp.com/tos');
accountOnboarding.setRecipientTermsOfServiceUrl('https://yourapp.com/recipient-tos');
accountOnboarding.setPrivacyPolicyUrl('https://yourapp.com/privacy');

// Required: Handle exit event
accountOnboarding.setOnExit(() => {
  // Retrieve account to check status
  // Navigate user to next step
});

// Optional: Track steps
accountOnboarding.setOnStepChange(({ step }) => {
  console.log('User on step:', step);
});

container.appendChild(accountOnboarding);
```

### Client-Side (React)
```jsx
import { ConnectAccountOnboarding } from '@stripe/react-connect-js';

<ConnectAccountOnboarding
  onExit={() => handleOnboardingComplete()}
  collectionOptions={{
    fields: 'eventually_due',
    futureRequirements: 'include'
  }}
  fullTermsOfServiceUrl="https://yourapp.com/tos"
  recipientTermsOfServiceUrl="https://yourapp.com/recipient-tos"
  privacyPolicyUrl="https://yourapp.com/privacy"
  onStepChange={({ step }) => console.log(step)}
/>
```

### Key Onboarding Steps
- `business_type` - Select business type
- `business_details` - Collect business information
- `business_verification` - Upload verification documents
- `representative_details` - Account representative info
- `owners` - Beneficial owner information
- `external_account` - Bank account for payouts
- `summary` - Review and submit

## Account Management Component

### Purpose
Allows connected accounts to update their profile, business details, payout settings, and respond to compliance requirements.

### Server-Side Setup
```javascript
const accountSession = await stripe.accountSessions.create({
  account: connectedAccountId,
  components: {
    account_management: {
      enabled: true,
      features: {
        external_account_collection: true
      }
    }
  }
});
```

### Client-Side (JavaScript)
```javascript
const accountManagement = stripeConnectInstance.create('account-management');
container.appendChild(accountManagement);
```

### Client-Side (React)
```jsx
import { ConnectAccountManagement } from '@stripe/react-connect-js';

<ConnectAccountManagement />
```

## Notification Banner Component

### Purpose
Displays alerts for outstanding compliance requirements, risk interventions, and other important account updates. Only renders when there are active notifications.

### Placement
Place prominently at the top of your dashboard or main application page.

### Server-Side Setup
```javascript
const accountSession = await stripe.accountSessions.create({
  account: connectedAccountId,
  components: {
    notification_banner: {
      enabled: true,
      features: {
        external_account_collection: true
      }
    }
  }
});
```

### Client-Side (JavaScript)
```javascript
const notificationBanner = stripeConnectInstance.create('notification-banner');
container.appendChild(notificationBanner);
```

### Client-Side (React)
```jsx
import { ConnectNotificationBanner } from '@stripe/react-connect-js';

<ConnectNotificationBanner />
```

## Payments Component

### Purpose
Shows a list of all payments for the connected account with filtering, searching, and bulk export capabilities. Includes refund and dispute management if enabled.

### Server-Side Setup
```javascript
const accountSession = await stripe.accountSessions.create({
  account: connectedAccountId,
  components: {
    payments: {
      enabled: true,
      features: {
        refund_management: true,
        dispute_management: true,
        capture_payments: true,
        destination_on_behalf_of_charge_management: false
      }
    }
  }
});
```

### Client-Side (JavaScript)
```javascript
const payments = stripeConnectInstance.create('payments');

// Optional: Set default filters
payments.setDefaultFilters({
  amount: { greaterThan: 100 },
  date: { before: new Date(2024, 0, 1) },
  status: ['partially_refunded', 'refund_pending', 'refunded'],
  paymentMethod: 'card'
});

container.appendChild(payments);
```

### Client-Side (React)
```jsx
import { ConnectPayments } from '@stripe/react-connect-js';

<ConnectPayments
  defaultFilters={{
    amount: { greaterThan: 100 },
    status: ['succeeded']
  }}
/>
```

## Payment Details Component

### Purpose
Shows detailed information about a specific payment, including timeline, refund capability, and dispute information.

### Server-Side Setup
```javascript
const accountSession = await stripe.accountSessions.create({
  account: connectedAccountId,
  components: {
    payment_details: {
      enabled: true,
      features: {
        refund_management: true,
        dispute_management: true,
        capture_payments: true
      }
    }
  }
});
```

### Client-Side (JavaScript)
```javascript
const paymentDetails = stripeConnectInstance.create('payment-details', {
  payment: paymentIntentId
});
container.appendChild(paymentDetails);
```

### Client-Side (React)
```jsx
import { ConnectPaymentDetails } from '@stripe/react-connect-js';

<ConnectPaymentDetails payment={paymentIntentId} />
```

## Payouts Component

### Purpose
Displays balance information, payout history, and allows connected accounts to trigger payouts.

### Server-Side Setup
```javascript
const accountSession = await stripe.accountSessions.create({
  account: connectedAccountId,
  components: {
    payouts: {
      enabled: true,
      features: {
        instant_payouts: true,
        standard_payouts: true,
        edit_payout_schedule: true,
        external_account_collection: true
      }
    }
  }
});
```

### Client-Side (JavaScript)
```javascript
const payouts = stripeConnectInstance.create('payouts');
container.appendChild(payouts);
```

### Client-Side (React)
```jsx
import { ConnectPayouts } from '@stripe/react-connect-js';

<ConnectPayouts />
```

## Balances Component

### Purpose
Shows available balance and pending balance with ability to trigger payouts.

### Server-Side Setup
```javascript
const accountSession = await stripe.accountSessions.create({
  account: connectedAccountId,
  components: {
    balances: {
      enabled: true,
      features: {
        instant_payouts: true,
        standard_payouts: true,
        edit_payout_schedule: true,
        external_account_collection: true
      }
    }
  }
});
```

### Client-Side (JavaScript)
```javascript
const balances = stripeConnectInstance.create('balances');
container.appendChild(balances);
```

### Client-Side (React)
```jsx
import { ConnectBalances } from '@stripe/react-connect-js';

<ConnectBalances />
```

## Documents Component

### Purpose
Provides access to tax documents, invoices, and other important account documents for download.

**Required when:** Stripe collects fees directly from connected accounts.

### Server-Side Setup
```javascript
const accountSession = await stripe.accountSessions.create({
  account: connectedAccountId,
  components: {
    documents: {
      enabled: true
    }
  }
});
```

### Client-Side (JavaScript)
```javascript
const documents = stripeConnectInstance.create('documents');
container.appendChild(documents);
```

### Client-Side (React)
```jsx
import { ConnectDocuments } from '@stripe/react-connect-js';

<ConnectDocuments />
```

## Component Lifecycle

### AccountSession Expiration
- AccountSessions expire after a period of time
- The `fetchClientSecret` function is called automatically to refresh
- Ensure your endpoint can handle multiple calls

### Component Mounting/Unmounting
- Components can be mounted and unmounted dynamically
- No need to recreate the entire StripeConnectInstance
- Simply create/remove DOM elements as needed

## Best Practices

### Component Placement
1. **Notification Banner**: Top of every page (sticky header ideal)
2. **Account Onboarding**: Dedicated onboarding flow/page
3. **Account Management**: Settings or profile section
4. **Payments/Payouts**: Main dashboard or dedicated sections
5. **Documents**: Within account settings or compliance section

### Error Handling
```javascript
app.post('/account_session', async (req, res) => {
  try {
    const accountSession = await stripe.accountSessions.create({
      account: connectedAccountId,
      components: { /* ... */ }
    });
    res.json({ client_secret: accountSession.client_secret });
  } catch (error) {
    console.error('AccountSession creation failed:', error);
    res.status(500).json({ error: error.message });
  }
});
```

### Security
- Always validate the connected account ID belongs to the authenticated user
- Implement rate limiting on AccountSession endpoint
- Use HTTPS for all communication
- Consider implementing session timeouts

## Common Issues

### Component Not Rendering
- Verify AccountSession was created successfully
- Check that the component is enabled in the AccountSession
- Ensure the connected account ID is valid
- Confirm the client secret hasn't expired

### Authentication Errors
- For Custom accounts with `disable_stripe_user_authentication: true`, ensure your platform handles authentication
- For other account types, users must complete Stripe authentication

### Missing Features
- Verify features are enabled in the AccountSession creation
- Check account capabilities are active
- Ensure account has completed required onboarding steps
