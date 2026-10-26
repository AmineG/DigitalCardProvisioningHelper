# DigitalCardProvisioningHelper
Swift package that computes the `PKIssuerProvisioningExtensionStatus` values for a Wallet issuer extension, based on the cards already present in Wallet.

## Requirements

- iOS 15+
- Swift 5.9+

## Installation

Add the package in Xcode (**File > Add Package Dependencies…**) or in `Package.swift`:

```swift
.package(url: "https://github.com/AmineG/DigitalCardProvisioningHelper.git", branch: "main")
```

Then add `DigitalCardProvisioningHelper` to your **Issuer Extension** target.

## Usage

Call `provisioningStatus(for:requiresAuthentication:library:)` with the last digits of the user's cards, then map the result in your `PKIssuerProvisioningExtensionHandler`.

```swift
import PassKit
import DigitalCardProvisioningHelper

final class IssuerExtensionHandler: PKIssuerProvisioningExtensionHandler {

    override func status(completion: @escaping (PKIssuerProvisioningExtensionStatus) -> Void) {
        let lastDigits = ["1234", "5678"] // Load from your app's storage.
        let result = provisioningStatus(for: lastDigits, requiresAuthentication: true)

        let status = PKIssuerProvisioningExtensionStatus()
        status.passEntriesAvailable = result.passEntriesAvailable
        status.remotePassEntriesAvailable = result.remotePassEntriesAvailable
        status.requiresAuthentication = result.requiresAuthentication
        completion(status)
    }
...
}
```

