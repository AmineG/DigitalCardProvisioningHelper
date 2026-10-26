//
//  SecureElementPassInfo.swift
//  DigitalCardProvisioningHelper
//
//  Created by amine on 26/10/2026.
//

public struct SecureElementPassInfo: Equatable {
    public let suffix: String
    public let primaryAccountIdentifier: String
    public let isDeactivated: Bool

    public init(suffix: String, primaryAccountIdentifier: String, isDeactivated: Bool) {
        self.suffix = suffix
        self.primaryAccountIdentifier = primaryAccountIdentifier
        self.isDeactivated = isDeactivated
    }
}
