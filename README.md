![Cocoapods](https://img.shields.io/cocoapods/v/FlashPaySDK)


# FlashPay MSDK

To open the payment form:
1. Create the `FlashPayMSDK` object.

2. Create the `SDKPaymentOptions` object.

This object must contain the following required parameters:

- `projectId`  (String) — a project identifier 
- `orderId`  (String) — a payment identifier unique within the project
- `currency`  (String) — the payment currency code in the ISO 4217 alpha-3 format
- `amount`  (int) — the payment amount in the smallest currency units
- `currency`  (String) — a customer's identifier within the project

```
let options = SDKPaymentOptions(
    orderId: UUID().uuidString,
    projectId: "YOUR PROJECT ID",
    payment: SDKPayment(amount: 10000, currency: "KGS"),
    customer: ["id" : "1", "email" : "test@customer.me"],
    paymentData: nil
)
```
3. Call setup method of `FlashPayMSDK` object
```
let params = msdk.setup(sdkPaymentOptions: options)
```

4. Calculate `signature1` and `signature2`.
```
signature1: HMAC.shared.sha256(
    key: "YOUR SECRET KEY",
    message: params.paramForSignature1
),
signature2: HMAC.shared.sha256(
    key: "YOUR SECRET KEY",
    message: params.paramForSignature2
)
```

5. Open the payment form and handle result.

```
let paymentViewController = msdk.paymentScreen(
    resultCallback: callback,
    sdkPaymentOptions: options,
    signature1: HMAC.shared.sha256(
        key: "YOUR SECRET KEY",
        message: params.paramForSignature1
    ),
    signature2: HMAC.shared.sha256(
        key: "YOUR SECRET KEY",
        message: params.paramForSignature2
    )
)

self.presentViewController(paymentViewController, animated: true, completion: nil)
```
