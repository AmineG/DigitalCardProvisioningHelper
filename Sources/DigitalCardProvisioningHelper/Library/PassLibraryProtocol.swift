//
//  PassLibraryProtocol.swift
//  DigitalCardProvisioningHelper
//
//  Created by amine on 26/10/2026.
//

import PassKit

public protocol PassLibraryProtocol {
    func secureElementPasses() -> [SecureElementPassInfo]
    func canAddSecureElementPass(primaryAccountIdentifier: String) -> Bool
}

extension PKPassLibrary: PassLibraryProtocol {
    public func secureElementPasses() -> [SecureElementPassInfo] {
        passes(of: .secureElement)
            .compactMap { $0 as? PKSecureElementPass }
            .map {
                SecureElementPassInfo(
                    suffix: $0.primaryAccountNumberSuffix,
                    primaryAccountIdentifier: $0.primaryAccountIdentifier,
                    isDeactivated: $0.passActivationState == .deactivated
                )
            }
    }
}
