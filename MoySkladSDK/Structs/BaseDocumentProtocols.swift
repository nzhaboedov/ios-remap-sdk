//
//  BaseDocumentProtocols.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 24.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public protocol MSBaseDocumentType : class, Metable, MSRequestEntity {
    var id : MSID { get }
    var meta : MSMeta { get }
    var info : MSInfo { get set }
    var agent : MSEntity<MSAgent>? { get set }
    var contract : MSEntity<MSContract>? { get set }
    var sum : Money { get set }
    var vatSum : Money { get set }
    var payedSum: Money { get set}
    var rate : MSRate? { get set }
    var moment : Date { get set }
    var project : MSEntity<MSProject>? { get set }
    var organization : MSEntity<MSAgent>? { get set }
    var owner : MSEntity<MSEmployee>? { get set }
    var group : MSEntity<MSGroup> { get set }
    var shared : Bool  { get set }
    var applicable : Bool { get set }
    var state : MSEntity<MSState>? { get set }
    var attributes : [MSEntity<MSAttribute>]? { get set }
    var originalApplicable: Bool { get }
    var stateContractId: String? { get set }
    
    func copyDocument() -> MSDocument
    func dictionary(metaOnly: Bool) -> [String: Any]
}

public extension MSBaseDocumentType {
    public func requestUrl() -> MSApiRequest? {
        switch meta.type {
        case .customerorder: return .customerorder
        case .demand: return .demand
        case .invoiceout: return .invoiceOut
        case .cashin: return .cashIn
        case .cashout: return .cashOut
        case .paymentin: return .paymentIn
        case .paymentout: return .paymentOut
        default: return nil
        }
    }
    
    public func deserializationError() -> MSError {
        switch meta.type {
        case .customerorder: return MSError.genericError(errorText: LocalizedStrings.incorrectCustomerOrdersResponse.value)
        case .demand: return MSError.genericError(errorText: LocalizedStrings.incorrectDemandsResponse.value)
        case .invoiceout: return MSError.genericError(errorText: LocalizedStrings.incorrectCustomerOrdersResponse.value)
        case .cashin: return MSError.genericError(errorText: LocalizedStrings.incorrectCashInResponse.value)
        case .cashout: return MSError.genericError(errorText: LocalizedStrings.incorrectCashOutResponse.value)
        case .paymentin: return MSError.genericError(errorText: LocalizedStrings.incorrectPaymentInResponse.value)
        case .paymentout: return MSError.genericError(errorText: LocalizedStrings.incorrectPaymentOutResponse.value)
        default: return MSError.genericError(errorText: LocalizedStrings.genericDeserializationError.value)
        }
    }
}

/**
 Represents generalized document (CustomerOrder, Demand or OnvoiceOut).
 For more information see API reference for [ customer order](https://online.moysklad.ru/api/remap/1.1/doc/index.html#документ-заказ-покупателя), [ demand](https://online.moysklad.ru/api/remap/1.1/doc/index.html#документ-отгрузка) and [ invoice out](https://online.moysklad.ru/api/remap/1.1/doc/index.html#документ-счёт-покупателю)
 */
public protocol MSGeneralDocument : class, MSBaseDocumentType {
    var agentAccount : MSEntity<MSAccount>? { get set }
    var organizationAccount : MSEntity<MSAccount>? { get set }
    var vatIncluded : Bool { get set }
    var vatEnabled : Bool { get set }
    var store : MSEntity<MSStore>? { get set }
    var originalStoreId: UUID? { get }
    var positions : [MSEntity<MSPosition>] { get set }
    var stock : [MSEntity<MSDocumentStock>] { get set }
}
