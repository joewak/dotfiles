# Stripe Connect API Reference

Complete API reference for Stripe Connect integration with v1 Accounts API.

## Accounts API (v1)

### Create Connected Account

Creates a new connected account with specified configuration.

**Endpoint:** `POST /v1/accounts`

**Parameters:**
- `country` (required) - Two-letter country code (e.g., 'US', 'GB')
- `type` - Account type: 'standard', 'express', or 'custom'
- `controller` - Object defining control settings
  - `stripe_dashboard.type` - 'none' for fully embedded (no Stripe Dashboard access)
  - `requirement_collection` - 'application' or 'stripe'
  - `fees.payer` - 'application' or 'account'
  - `losses.payments` - 'application' or 'stripe'
- `capabilities` - Object with capability requests
  - `card_payments.requested` - Boolean
  - `transfers.requested` - Boolean
  - Additional payment method capabilities as needed
- `business_type` - 'company' or 'individual'
- `email` - Account email address
- `business_profile` - Object with business details
- `individual` or `company` - Prefill business/individual information
- `external_account` - Bank account or debit card for payouts

**Example:**
```javascript
const account = await stripe.accounts.create({
  country: 'US',
  controller: {
    stripe_dashboard: { type: 'none' },
    requirement_collection: 'stripe',
    fees: { payer: 'account' },
    losses: { payments: 'stripe' }
  },
  capabilities: {
    card_payments: { requested: true },
    transfers: { requested: true }
  },
  business_type: 'company',
  email: 'business@example.com',
  company: {
    name: 'Example Corp',
    tax_id: '000000000'
  }
});
```

**Response:**
```json
{
  "id": "acct_1234567890",
  "object": "account",
  "controller": {
    "type": "application",
    "is_controller": true
  },
  "charges_enabled": false,
  "payouts_enabled": false,
  "details_submitted": false,
  "type": "none"
}
```

### Retrieve Account

**Endpoint:** `GET /v1/accounts/:id`

```javascript
const account = await stripe.accounts.retrieve(connectedAccountId);
```

**Key Response Fields:**
- `details_submitted` - Boolean, true when account has submitted all info
- `charges_enabled` - Boolean, true when account can accept charges
- `payouts_enabled` - Boolean, true when account can receive payouts
- `requirements` - Object containing verification requirements
  - `currently_due` - Array of requirements needed now
  - `eventually_due` - Array of requirements needed in future
  - `past_due` - Array of overdue requirements
  - `errors` - Array of requirement errors

### Update Account

**Endpoint:** `POST /v1/accounts/:id`

```javascript
const account = await stripe.accounts.update(connectedAccountId, {
  business_profile: {
    name: 'Updated Business Name',
    url: 'https://example.com'
  }
});
```

**Restrictions:**
- Platforms with `controller.requirement_collection: 'stripe'` have limited update access after account completes onboarding
- External accounts and legal entity info can only be updated by connected account after onboarding

### Request Capabilities

**Endpoint:** `POST /v1/accounts/:id`

```javascript
const account = await stripe.accounts.update(connectedAccountId, {
  capabilities: {
    us_bank_account_ach_payments: { requested: true }
  }
});
```

Common capabilities:
- `card_payments` - Credit/debit card payments
- `transfers` - Standard payouts
- `us_bank_account_ach_payments` - ACH Direct Debit
- `sepa_debit_payments` - SEPA Direct Debit
- `affirm_payments`, `afterpay_clearpay_payments`, `klarna_payments` - BNPL methods

## Account Sessions API

### Create Account Session

Creates a short-lived session that grants temporary access to embedded components.

**Endpoint:** `POST /v1/account_sessions`

**Parameters:**
- `account` (required) - Connected account ID
- `components` (required) - Object defining which components to enable
  - Each component has `enabled: boolean` and optional `features: object`

**Example (Full Integration):**
```javascript
const accountSession = await stripe.accountSessions.create({
  account: connectedAccountId,
  components: {
    account_onboarding: {
      enabled: true,
      features: {
        external_account_collection: true,
        disable_stripe_user_authentication: false
      }
    },
    account_management: {
      enabled: true,
      features: {
        external_account_collection: true
      }
    },
    notification_banner: {
      enabled: true,
      features: {
        external_account_collection: true
      }
    },
    payments: {
      enabled: true,
      features: {
        refund_management: true,
        dispute_management: true,
        capture_payments: true,
        destination_on_behalf_of_charge_management: false
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
    payment_details: {
      enabled: true,
      features: {
        refund_management: true,
        dispute_management: true,
        capture_payments: true
      }
    },
    balances: {
      enabled: true,
      features: {
        instant_payouts: true,
        standard_payouts: true,
        external_account_collection: true
      }
    },
    documents: {
      enabled: true
    }
  }
});
```

**Response:**
```json
{
  "object": "account_session",
  "client_secret": "accsess_1234567890_secret_abcdef",
  "expires_at": 1640000000,
  "livemode": false
}
```

## Payment Intents API (Direct Charges)

### Create Payment Intent

**Endpoint:** `POST /v1/payment_intents`

**Headers:**
- `Stripe-Account: acct_connected_account_id` - Direct charge header

**Parameters:**
- `amount` (required) - Amount in smallest currency unit (cents)
- `currency` (required) - Three-letter ISO currency code
- `automatic_payment_methods` - Object with `enabled: true` (recommended)
- `application_fee_amount` - Platform fee in smallest currency unit
- `on_behalf_of` - Connected account ID (alternative to header)
- `transfer_data.destination` - Connected account ID (for destination charges)

**Example (Direct Charge with Application Fee):**
```javascript
const paymentIntent = await stripe.paymentIntents.create({
  amount: 1099,
  currency: 'usd',
  automatic_payment_methods: { enabled: true },
  application_fee_amount: 123
}, {
  stripeAccount: connectedAccountId
});
```

**Example (Manual Payment Method List):**
```javascript
const paymentIntent = await stripe.paymentIntents.create({
  amount: 1099,
  currency: 'eur',
  payment_method_types: ['card', 'sepa_debit', 'ideal'],
  application_fee_amount: 123
}, {
  stripeAccount: connectedAccountId
});
```

## Checkout Sessions API (Direct Charges)

### Create Checkout Session

**Endpoint:** `POST /v1/checkout/sessions`

**Headers:**
- `Stripe-Account: acct_connected_account_id` - Direct charge header

**Parameters:**
- `mode` (required) - 'payment', 'subscription', or 'setup'
- `line_items` (required) - Array of items to purchase
- `success_url` (required) - URL to redirect after success
- `cancel_url` - URL to redirect on cancel
- `payment_intent_data.application_fee_amount` - Platform fee
- `subscription_data.application_fee_percent` - Platform fee percentage for subscriptions

**Example:**
```javascript
const session = await stripe.checkout.sessions.create({
  mode: 'payment',
  line_items: [{
    price: 'price_1234567890',
    quantity: 1
  }],
  payment_intent_data: {
    application_fee_amount: 123
  },
  success_url: 'https://yourapp.com/success?session_id={CHECKOUT_SESSION_ID}',
  cancel_url: 'https://yourapp.com/cancel'
}, {
  stripeAccount: connectedAccountId
});
```

## Webhooks

### Setting Up Webhooks

Configure Connect webhooks in Dashboard to receive events for connected accounts.

**Important Event Types:**

#### Account Events
- `account.updated` - Account information changed
  - Check `details_submitted`, `charges_enabled`, `payouts_enabled`
- `account.application.deauthorized` - Account disconnected from platform

#### Payment Events
- `payment_intent.succeeded` - Payment completed successfully
- `payment_intent.payment_failed` - Payment failed
- `payment_intent.processing` - Payment is being processed
- `charge.succeeded` - Charge completed
- `charge.refunded` - Charge refunded
- `charge.dispute.created` - New dispute filed
- `charge.dispute.closed` - Dispute closed
- `charge.dispute.updated` - Dispute information updated

#### Checkout Events
- `checkout.session.completed` - Checkout session finished
- `checkout.session.async_payment_succeeded` - Async payment succeeded
- `checkout.session.async_payment_failed` - Async payment failed

#### Payout Events
- `payout.created` - Payout initiated
- `payout.paid` - Payout completed
- `payout.failed` - Payout failed
- `transfer.created` - Transfer to connected account created

### Webhook Handling Example

```javascript
app.post('/webhook', express.raw({type: 'application/json'}), (req, res) => {
  const sig = req.headers['stripe-signature'];
  let event;

  try {
    event = stripe.webhooks.constructEvent(
      req.body, 
      sig, 
      endpointSecret
    );
  } catch (err) {
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Handle the event
  switch (event.type) {
    case 'account.updated':
      const account = event.data.object;
      if (account.details_submitted && account.charges_enabled) {
        // Account is ready for payments
        console.log('Account ready:', account.id);
      }
      break;
    
    case 'payment_intent.succeeded':
      const paymentIntent = event.data.object;
      console.log('Payment succeeded:', paymentIntent.id);
      // Fulfill order
      break;
    
    case 'charge.dispute.created':
      const dispute = event.data.object;
      console.log('New dispute:', dispute.id);
      // Notify connected account
      break;
  }

  res.json({received: true});
});
```

## SDK Version Requirements

**Server-Side (Minimum Versions):**
- Node.js: `stripe@18.4.0` or later
- Python: `stripe@12.4.0` or later
- Ruby: `stripe@15.4.0` or later
- PHP: `stripe@17.5.0` or later
- Java: `stripe-java@29.4.0` or later
- Go: `stripe-go@82.4.0` or later
- .NET: `Stripe.net@48.4.0` or later

**Client-Side:**
- `@stripe/connect-js@3.3.27` or later
- `@stripe/react-connect-js@3.3.25` or later (for React)

## API Key Types

- **Publishable Key** (`pk_test_...` / `pk_live_...`) - Used client-side for ConnectJS
- **Secret Key** (`sk_test_...` / `sk_live_...`) - Used server-side for API calls
- Never expose secret keys client-side
- Use test keys during development, switch to live keys for production

## Rate Limits

- Account creation: 100 per rolling 10 seconds
- AccountSession creation: High limit, but implement caching where possible
- Standard API rate limits apply: https://stripe.com/docs/rate-limits

## Error Handling

Common error types:
- `invalid_request_error` - Invalid parameters
- `authentication_error` - Invalid API key
- `api_error` - Stripe server error
- `card_error` - Card declined or invalid
- `idempotency_error` - Idempotency key reused incorrectly
- `rate_limit_error` - Too many requests

```javascript
try {
  const account = await stripe.accounts.create(params);
} catch (error) {
  switch (error.type) {
    case 'StripeInvalidRequestError':
      // Invalid parameters
      console.error('Invalid request:', error.message);
      break;
    case 'StripeRateLimitError':
      // Too many requests
      console.error('Rate limit exceeded');
      break;
    default:
      console.error('Stripe error:', error.message);
  }
}
```

## Testing

**Test Cards:**
- Success: `4242 4242 4242 4242`
- Decline: `4000 0000 0000 0002`
- Authentication required: `4000 0025 0000 3155`
- Insufficient funds: `4000 0000 0000 9995`

**Test Mode:**
- All API operations work the same in test mode
- Use test API keys (`pk_test_...`, `sk_test_...`)
- No real money is processed
- Simulate various scenarios with test cards and bank accounts
