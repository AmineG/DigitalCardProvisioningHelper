//
//  ProvisioningStatus.swift
//  DigitalCardProvisioningHelper
//
//  Created by amine on 26/10/2026.
//

/// An object that indicates whether there are any payment cards available to add as Wallet passes.
public struct ProvisioningStatus {
    /// A Boolean value that indicates whether a payment card is available to add to an iPhone.
    public var passEntriesAvailable: Bool
    /// A Boolean value that indicates whether a payment card is available to add to an Apple Watch.
    public var remotePassEntriesAvailable: Bool
    /// A Boolean value that indicates whether adding a card requires an authorization-user-interface extension provided by your app.
    public var requiresAuthentication: Bool
}
