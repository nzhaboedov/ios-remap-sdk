//
//  Extensions.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 11.11.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

func newDocumentUrl(type: MSObjectType) -> MSApiRequest? {
    switch type {
    case MSObjectType.customerorder: return MSApiRequest.customerOrderNew
    case MSObjectType.demand: return MSApiRequest.demandNew
    case MSObjectType.invoiceout: return MSApiRequest.invoiceOutNew
    case MSObjectType.paymentin: return MSApiRequest.paymentInNew
    case MSObjectType.paymentout: return MSApiRequest.paymentOutNew
    case MSObjectType.cashin: return MSApiRequest.cashInNew
    case MSObjectType.cashout: return MSApiRequest.cashOutNew
    case MSObjectType.supply: return MSApiRequest.supplyNew
    case MSObjectType.invoicein: return MSApiRequest.invoiceInNew
    case MSObjectType.purchaseorder: return MSApiRequest.purchaseOrderNew
    case MSObjectType.move: return MSApiRequest.moveNew
    case MSObjectType.inventory: return MSApiRequest.inventoryNew
    default: return nil
    }
}

func createdDocumentError(type: MSObjectType) -> MSError {
    switch type {
    case MSObjectType.customerorder: return MSError.genericError(errorText: LocalizedStrings.incorrectCustomerOrderTemplateResponse.value)
    case MSObjectType.demand: return MSError.genericError(errorText: LocalizedStrings.incorrectDemandTemplateResponse.value)
    case MSObjectType.invoiceout: return MSError.genericError(errorText: LocalizedStrings.incorrectInvoiceOutTemplateResponse.value)
    case MSObjectType.invoicein: return MSError.genericError(errorText: LocalizedStrings.incorrectInvoiceInTemplateResponse.value)
    case MSObjectType.purchaseorder: return MSError.genericError(errorText: LocalizedStrings.incorrectPurchaseOrderTemplateResponse.value)
    default: return MSError.genericError(errorText: LocalizedStrings.genericDeserializationError.value)
    }
}

func emptyMeta(type: MSObjectType) -> MSMeta {
    return MSMeta(name: "", href: "", type: type)
}

public extension MSMeta {
    func dictionaryForTemplate() -> Dictionary<String, Any> {
        return ["template": ["meta": ["href":href, "mediaType":mediaType, "type":type.rawValue]]]
    }
}

func emptyDocumentPositionMeta(type: MSObjectType) -> MSMeta {
    switch type {
    case MSObjectType.customerorder: return MSMeta(name: "", href: "", type: .customerorderposition)
    case MSObjectType.demand: return MSMeta(name: "", href: "", type: .demandposition)
    case MSObjectType.invoiceout: return MSMeta(name: "", href: "", type: .invoiceposition)
    default: return MSMeta(name: "", href: "", type: .customerorderposition)
    }
}

extension Array {
    func toDictionary(_ key: (Element) -> String) -> [String: Element] {
        var dict = [String: Element]()
        forEach { dict[key($0)] = $0 }
        return dict
    }
    
    func toDictionary<TKey, TElement>(key: (Element) -> TKey, element: (Element) -> TElement) -> [TKey: TElement] {
        var dict = [TKey: TElement]()
        forEach { dict[key($0)] = element($0) }
        return dict
    }
}

extension Dictionary {
    subscript(jsonKey key: Key) -> [String:Any]? {
        get {
            return self[key] as? [String:Any]
        }
        set {
            self[key] = newValue as? Value
        }
    }
    
    subscript(jsonArrayKey key: Key) -> [Any]? {
        get {
            return self[key] as? [Any]
        }
        set {
            self[key] = newValue as? Value
        }
    }
    
    subscript(jsonString key: Key) -> String? {
        return self[key] as? String
    }
}

extension Dictionary where Key == String, Value == Any {
    func toJSONType() -> JSONType {
        return .dictionary(self)
    }
}

extension Array where Element == [String: Any] {
    func toJSONType() -> JSONType {
        return .array(self)
    }
}

extension MSAgent: MSRequestEntity {
    public func requestUrl() -> MSApiRequest? {
        if meta.type == .counterparty {
            return MSApiRequest.counterparty
        } else {
            return MSApiRequest.organization
        }
    }
    
    public func deserializationError() -> MSError {
        switch meta.type {
        case MSObjectType.organization: return MSError.genericError(errorText: LocalizedStrings.incorrectOrganizationResponse.value)
        case MSObjectType.counterparty: return MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartyResponse.value)
        default: return MSError.genericError(errorText: LocalizedStrings.genericDeserializationError.value)
        }
    }
    
    public func pathComponents() -> [String] {
        return []
    }
}

extension MSStore: MSRequestEntity {
    public func requestUrl() -> MSApiRequest? {
        return .store
    }
    
    public func deserializationError() -> MSError {
        return MSError.genericError(errorText: LocalizedStrings.incorrectStoreResponse.value)
    }
    
    public func pathComponents() -> [String] {
        return []
    }
}

extension MSTask: MSRequestEntity {
    public func requestUrl() -> MSApiRequest? {
        return MSApiRequest.task
    }
    
    public func deserializationError() -> MSError {
        return MSError.genericError(errorText: LocalizedStrings.incorrectTasksResponse.value)
    }
    
    public func pathComponents() -> [String] {
        return []
    }
}

extension MSEmployee: MSRequestEntity {
    public func requestUrl() -> MSApiRequest? {
        return MSApiRequest.employee
    }
    
    public func deserializationError() -> MSError {
        return MSError.genericError(errorText: LocalizedStrings.incorrectEmployeeResponse.value)
    }
    
    public func pathComponents() -> [String] {
        return []
    }
}

extension MSCustomEntity: MSRequestEntity {
    public func requestUrl() -> MSApiRequest? {
        return MSApiRequest.customEntity
    }
    
    public func deserializationError() -> MSError {
        return MSError.genericError(errorText: LocalizedStrings.incorrectCustomEntityResponse.value)
    }
    
    public func pathComponents() -> [String] {
        return [parentId]
    }
}

extension MSContract: MSRequestEntity {
    public func requestUrl() -> MSApiRequest? {
        return .contract
    }
    
    public func deserializationError() -> MSError {
        return MSError.genericError(errorText: LocalizedStrings.incorrectContractResponse.value)
    }
    
    public func pathComponents() -> [String] {
        return []
    }
}

extension MSProject: MSRequestEntity {
    public func requestUrl() -> MSApiRequest? {
        return .project
    }
    
    public func deserializationError() -> MSError {
        return MSError.genericError(errorText: LocalizedStrings.incorrectProjectResponse.value)
    }
    
    public func pathComponents() -> [String] {
        return []
    }
}

extension UserDefaults {
    var moySkladHost: String {
        get {
            guard let host = string(forKey: "moySkladHost") else {
                return "online.moysklad.ru"
            }
            return host
        }
        set {
            set(newValue, forKey: "moySkladHost")
        }
    }
}

public protocol OptionalType {
    associatedtype Wrapped
    func map<U>(_ f: (Wrapped) throws -> U) rethrows -> U?
}

extension Optional: OptionalType {}

public extension Sequence where Iterator.Element: OptionalType {
    func removeNils() -> [Iterator.Element.Wrapped] {
        var result: [Iterator.Element.Wrapped] = []
        for element in self {
            if let element = element.map({ $0 }) {
                result.append(element)
            }
        }
        return result
    }
}

public extension Dictionary {
    mutating func merge<S>(_ other: S)
        where S: Sequence, S.Iterator.Element == (key: Key, value: Value) {
            for (k, v) in other {
                self[k] = v
            }
    }
    
    func merged<S>(_ other: S) -> Dictionary<Key, Value>
        where S: Sequence, S.Iterator.Element == (key: Key, value: Value) {
            var new = self
            new.merge(other)
            return new
    }
}

public extension Date {
    static func lastPeriodFrom(date1: Date, date2: Date) -> (bottom: Date, top: Date) {
        let daysInterval = Calendar.current.dateComponents([.day], from: date1, to: date2).day ?? 0
        let lastTop = Calendar.current.date(byAdding: .day, value: -1, to: date1) ?? Date()
        let lastBottom = Calendar.current.date(byAdding: .day, value: -daysInterval, to: lastTop) ?? Date()
        return (lastBottom, lastTop)
    }
    
    func daysTo(date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: date).day ?? 0
    }
    
    func isWithinWeekRange(with date: Date) -> Bool {
        return daysTo(date: date) <= 6
    }
    
    func isInSameDay(as other: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: other)
    }
    
    func isCurrentYear() -> Bool {
        return Calendar.current.component(.year, from: Date()) == Calendar.current.component(.year, from: self)
    }
    
    func toLongDateName() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
    
    func toLongDate() -> String {
        return Date.msDateFormatter.string(from: self)
    }
    
    func toShortDate() -> String {
        return Date.msShortDateFormatter.string(from: self)
    }
    
    func toShortTime() -> String {
        return Date.msHourAndMinuteFormatter.string(from: self)
    }
    
    func toShortTimeLetters(_ doesRelative: Bool) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = doesRelative
        return formatter.string(from: self)
    }
    
    static var msShortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    static var msHourAndMinuteFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    static var msStringToDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    static var msDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        return formatter
    }()
    
    static func fromMSString(_ value: String) -> Date? {
        guard value.count > 0 else {
            return nil
        }
        return Date.msStringToDateFormatter.date(from: value)
    }
    
    static func fromMSDate(_ value: String) -> Date? {
        guard value.count > 0 else {
            return nil
        }
        return Date.msDateFormatter.date(from: value)
    }
    
    static var msLongDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    /// Date format: dd MMMM yyyy HH:mm
    func toMSLongDateTime() -> String {
        return Date.msLongDateTimeFormatter.string(from: self)
    }
    
    func toMSLongDate() -> String {
        return Date.msLongDateFormatter.string(from: self)
    }
    
    static var msLongDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    static var msCalendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2
        return cal
    }()
    
    func startOfWeek() -> Date {
        let date = Date.msCalendar.date(from: Date.msCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        let dslTimeOffset = TimeZone(identifier: "Europe/Moscow")!.daylightSavingTimeOffset(for: date)
        return date.addingTimeInterval(dslTimeOffset)
    }
    
    func endOfWeek() -> Date {
        return Date.msCalendar.date(byAdding: .second, value: 604799, to: self.startOfWeek())!
    }
    
    func startOfLastWeek() -> Date {
        return Date.msCalendar.date(byAdding: .second, value: -604799, to: self.startOfWeek())!
    }
    
    func endOfLastWeek() -> Date {
        return Date.msCalendar.date(byAdding: .second, value: 604799, to: self.startOfLastWeek().addingTimeInterval(-1))!
    }
    
    func startOfMonth() -> Date {
        let components = Date.msCalendar.dateComponents([.year, .month], from: self)
        return Date.msCalendar.date(from: components)!
    }
    
    func endOfLastMonth() -> Date {
        var comps2 = DateComponents()
        comps2.second = -1
        return Date.msCalendar.date(byAdding: comps2, to: startOfMonth())!
    }
    
    func endOfMonth() -> Date {
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.second = -1
        return Date.msCalendar.date(byAdding: comps2, to: startOfMonth())!
    }
    
    func startOfLastMonth() -> Date {
        var comps2 = DateComponents()
        comps2.month = -1
        return Date.msCalendar.date(byAdding: comps2, to: startOfMonth())!
    }
    
    func beginningOfDay() -> Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    func endOfDay() -> Date {
        return Date.msCalendar.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
    
    func beginningOfLastDay() -> Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self.addingTimeInterval(-(24*60*60)))!
    }
    
    func endOfLastDay() -> Date {
        return Date.msCalendar.date(bySettingHour: 23, minute: 59, second: 59, of: self.addingTimeInterval(-(24*60*60)))!
    }
    
    static var msStatisticsFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    func toDayAndTime() -> String {
        return Date.msStatisticsFormatter.string(from: self)
    }
    
    func shiftOpenedInterval(closedDate closed: Date) -> String {
        
        let difference = Calendar.current.dateComponents([.day, .hour, .minute], from: self, to: closed)
        
        guard let hours = difference.hour, let days = difference.day, let minutes = difference.minute else { return "0 \(LocalizedStrings.minutePlu.value)" }
        
        let declinedDay = declineNoun(count: days, nounVariants: (nom: LocalizedStrings.formatedDay1.value, gen: LocalizedStrings.formatedDay2.value, plu: LocalizedStrings.formatedDay3.value))
        let declinedHour = declineNoun(count: hours, nounVariants: (nom: LocalizedStrings.formatedHour1.value, gen: LocalizedStrings.formatedHour2.value, plu: LocalizedStrings.formatedHour3.value))
        let declinedMinute = declineNoun(count: minutes, nounVariants: (nom: LocalizedStrings.minuteNom.value, gen: LocalizedStrings.minuteGen.value, plu: LocalizedStrings.minutePlu.value))
        
        if days > 0 {
            return "\(days) \(declinedDay) \(hours) \(declinedHour)"
        } else if hours > 0 {
            return "\(hours) \(declinedHour) \(minutes) \(declinedMinute)"
        } else {
            return "\(minutes) \(declinedMinute)"
        }
    }
}

public extension NSDecimalNumber {
    func toMoneyString(showPositiveSign: Bool = false) -> String {
        guard showPositiveSign, !self.isEqual(to: 0) else {
            return NSDecimalNumber.msMoneyNumberFormatter.string(from: self) ?? "0"
        }
        
        return NSDecimalNumber.msMoneyNumberFormatterWithPositiveSign.string(from: self) ?? "0"
    }
    
    @nonobjc static var msMoneyNumberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.groupingSeparator = " "
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        nf.negativePrefix = "- "
        return nf
    }()
    
    @nonobjc static var msMoneyNumberFormatterWithPositiveSign: NumberFormatter = {
        let nf = NumberFormatter()
        nf.groupingSeparator = " "
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        nf.positivePrefix = "+ "
        nf.negativePrefix = "- "
        return nf
    }()
    
}

public extension Double {
    func toMoney() -> Money {
        let rounding = NSDecimalNumberHandler(roundingMode: .down, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let decimal = NSDecimalNumber(value: self).rounding(accordingToBehavior: rounding)
        return Money(minorUnits: decimal.intValue)
    }
    
    func toMSDoubleString(showPositiveSign: Bool = false) -> String {
        guard showPositiveSign, self != 0 else {
            return Double.msDoubleFormatter.string(from: NSNumber(floatLiteral: self)) ?? "0"
        }
        
        return Double.msDoubleFormatterWithPositiveSign.string(from: NSNumber(floatLiteral: self)) ?? "0"
    }
    
    @nonobjc static var msDoubleFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.groupingSeparator = " "
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 4
        return nf
    }()
    
    @nonobjc static var msDoubleFormatterWithPositiveSign: NumberFormatter = {
        let nf = NumberFormatter()
        nf.groupingSeparator = " "
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 4
        nf.positivePrefix = nf.plusSign
        return nf
    }()
}

// MARK: current TimeZone Extension
public extension Date {
    
    static var msRfc5322Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    static var msCurrentLocaleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    func toRfc5322() -> String {
        return Date.msRfc5322Formatter.string(from: self)
    }
    
    func toCurrentLocaleLongDate() -> String {
        return Date.msCurrentLocaleDateFormatter.string(from: self)
    }
}
