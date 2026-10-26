//
//  PassLibraryProtocol.swift
//  DigitalCardProvisioningHelper
//
//  Created by amine on 25/10/2026.
//

import PassKit

/// Computes the provisioning status for cards identified by their last digits.
///
/// For each unique suffix in `lastDigits`, the function looks for a matching active card in the library. Deactivated cards are ignored.
///
/// - If no active card matches a suffix, ``ProvisioningStatus/passEntriesAvailable`` is set to `true`.
/// - If an active card matches and the library allows adding it, ``ProvisioningStatus/remotePassEntriesAvailable`` is set to `true`.
///
/// ```swift
/// let status = provisioningStatus(for: ["1234", "5678"])
/// if status.passEntriesAvailable {
///     // Able to add the card to Wallet.
/// }
/// ```
///
/// - Parameters:
///   - lastDigits: Last digits of the cards to check. Duplicates are ignored.
///   - requiresAuthentication: Copied as-is into the returned status.
///     Defaults to `false`.
///   - library: The pass library to query. Defaults to `PKPassLibrary()
/// - Returns: A ``ProvisioningStatus`` describing which entries are available.
public func provisioningStatus(
    for lastDigits: [String],
    requiresAuthentication: Bool = false,
    library: PassLibraryProtocol = PKPassLibrary()
) -> ProvisioningStatus {

    let activePasses = Dictionary(
        library.secureElementPasses()
            .filter { !$0.isDeactivated }
            .map { ($0.suffix, $0) },
        uniquingKeysWith: { first, _ in first }
    )

    var status = ProvisioningStatus(
        passEntriesAvailable: false,
        remotePassEntriesAvailable: false,
        requiresAuthentication: requiresAuthentication
    )

    for digits in Set(lastDigits) {
        guard let pass = activePasses[digits] else {
            status.passEntriesAvailable = true
            continue
        }
        if library.canAddSecureElementPass(primaryAccountIdentifier: pass.primaryAccountIdentifier) {
            status.remotePassEntriesAvailable = true
        }
    }
    return status
}
