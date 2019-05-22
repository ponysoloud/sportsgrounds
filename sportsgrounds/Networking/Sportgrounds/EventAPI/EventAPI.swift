//
//  EventAPI.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

struct EventAPI: NetworkService {

    private let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }
    
    func getEvents(withToken token: String,
                   page: Int? = nil,
                   groundId: Int? = nil,
                   status: SGEventStatus? = nil,
                   type: SGEventType? = nil,
                   activity: SGActivity? = nil,
                   ownerId: Int? = nil,
                   participantId: Int? = nil) -> Promise<SGEventsPaginationResponse> {
        return Promise { seal in
            let request = EventRequest.getEvents(token: token,
                                                 page: page,
                                                 groundId: groundId,
                                                 status: status?.rawValue,
                                                 type: type?.rawValue,
                                                 activity: activity?.rawValue,
                                                 ownerId: ownerId,
                                                 participantId: participantId)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    let success: (SGEventsPaginationResponse) -> Void = { s in
                        seal.fulfill(s)
                    }
                    
                    let failure: (SGBasicResponse) -> Void = { f in
                        let error = SportsgroundsResponseError.serverFailureResponse(message: f.message)
                        seal.reject(error)
                    }
                    
                    do {
                        try response.extractResult(success: success, failure: failure)
                    } catch let error {
                        seal.reject(error)
                    }
                case .error(let error):
                    seal.reject(error)
                }
            }.catch {
                error in
                seal.reject(error)
            }
        }
    }
    
    func createEvent(withToken token: String,
                     groundId: Int,
                     type: SGEventType,
                     title: String,
                     description: String,
                     activity: SGActivity,
                     participantsLevel: SGParticipantsLevel,
                     participantsAgeFrom: Int,
                     participantsAgeTo: Int,
                     beginAt: Date,
                     endAt: Date,
                     participantsCount: Int?,
                     teamsCount: Int?,
                     teamsSize: Int?) -> Promise<SGEvent> {
        
        return Promise { seal in
            let request = EventRequest.createEvent(token: token,
                                                   type: type.rawValue,
                                                   title: title,
                                                   description: description,
                                                   activity: activity.rawValue,
                                                   participantsLevel: participantsLevel.rawValue,
                                                   participantsAgeFrom: participantsAgeFrom,
                                                   participantsAgeTo: participantsAgeTo,
                                                   beginAt: beginAt.iso8601,
                                                   endAt: endAt.iso8601,
                                                   groundId: groundId,
                                                   participantsCount: participantsCount,
                                                   teamsCount: teamsCount,
                                                   teamsSize: teamsSize)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    let success: (SGEventResponse) -> Void = { s in
                        seal.fulfill(s.event)
                    }
                    
                    let failure: (SGBasicResponse) -> Void = { f in
                        let error = SportsgroundsResponseError.serverFailureResponse(message: f.message)
                        seal.reject(error)
                    }
                    
                    do {
                        try response.extractResult(success: success, failure: failure)
                    } catch let error {
                        seal.reject(error)
                    }
                case .error(let error):
                    seal.reject(error)
                }
            }.catch {
                error in
                seal.reject(error)
            }
        }
    }
    
    func getEvent(withToken token: String, eventId: Int) -> Promise<SGEvent> {
        return Promise { seal in
            let request = EventRequest.getEvent(token: token, eventId: eventId)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    let success: (SGEventResponse) -> Void = { s in
                        seal.fulfill(s.event)
                    }
                    
                    let failure: (SGBasicResponse) -> Void = { f in
                        let error = SportsgroundsResponseError.serverFailureResponse(message: f.message)
                        seal.reject(error)
                    }
                    
                    do {
                        try response.extractResult(success: success, failure: failure)
                    } catch let error {
                        seal.reject(error)
                    }
                case .error(let error):
                    seal.reject(error)
                }
                }.catch {
                    error in
                    seal.reject(error)
            }
        }
    }
    
    func joinToEvent(withToken token: String, eventId: Int, teamId: Int) -> Promise<SGEvent> {
        return Promise { seal in
            let request = EventRequest.joinToEvent(token: token, eventId: eventId, teamId: teamId)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    let success: (SGEventResponse) -> Void = { s in
                        seal.fulfill(s.event)
                    }
                    
                    let failure: (SGBasicResponse) -> Void = { f in
                        let error = SportsgroundsResponseError.serverFailureResponse(message: f.message)
                        seal.reject(error)
                    }
                    
                    do {
                        try response.extractResult(success: success, failure: failure)
                    } catch let error {
                        seal.reject(error)
                    }
                case .error(let error):
                    seal.reject(error)
                }
            }.catch {
                error in
                seal.reject(error)
            }
        }
    }
    
    func leaveFromEvent(withToken token: String, eventId: Int) -> Promise<SGEvent> {
        return Promise { seal in
            let request = EventRequest.leaveFromEvent(token: token, eventId: eventId)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    let success: (SGEventResponse) -> Void = { s in
                        seal.fulfill(s.event)
                    }
                    
                    let failure: (SGBasicResponse) -> Void = { f in
                        let error = SportsgroundsResponseError.serverFailureResponse(message: f.message)
                        seal.reject(error)
                    }
                    
                    do {
                        try response.extractResult(success: success, failure: failure)
                    } catch let error {
                        seal.reject(error)
                    }
                case .error(let error):
                    seal.reject(error)
                }
            }.catch {
                error in
                seal.reject(error)
            }
        }
    }
    
    func getEventMessages(withToken token: String, skip: Int, count: Int? = nil, eventId: Int) -> Promise<SGMessagesPaginationResponse> {
        return Promise { seal in
            let request = EventRequest.getEventMessages(token: token, skip: skip, count: count, eventId: eventId)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    let success: (SGMessagesPaginationResponse) -> Void = { s in
                        seal.fulfill(s)
                    }
                    
                    let failure: (SGBasicResponse) -> Void = { f in
                        let error = SportsgroundsResponseError.serverFailureResponse(message: f.message)
                        seal.reject(error)
                    }
                    
                    do {
                        try response.extractResult(success: success, failure: failure)
                    } catch let error {
                        seal.reject(error)
                    }
                case .error(let error):
                    seal.reject(error)
                }
                }.catch {
                    error in
                    seal.reject(error)
            }
        }
    }
    
    func sendEventMessage(withToken token: String, eventId: Int, text: String) -> Promise<SGMessage> {
        return Promise { seal in
            let request = EventRequest.sendEventMessage(token: token, eventId: eventId, text: text)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    let success: (SGMessageResponse) -> Void = { s in
                        seal.fulfill(s.newMessage)
                    }
                    
                    let failure: (SGBasicResponse) -> Void = { f in
                        let error = SportsgroundsResponseError.serverFailureResponse(message: f.message)
                        seal.reject(error)
                    }
                    
                    do {
                        try response.extractResult(success: success, failure: failure)
                    } catch let error {
                        seal.reject(error)
                    }
                case .error(let error):
                    seal.reject(error)
                }
                }.catch {
                    error in
                    seal.reject(error)
            }
        }
    }
    
//    func getUserInfo(token: String, coin: CoinType?) -> Promise<User> {
//        return Promise { seal in
//            let request = UserRequest.userInfo(token: token, coin: coin?.rawValue)
//            provider.execute(request).done {
//                response in
//
//                switch response {
//                case .data(_):
//
//                    let success: (CodableUserInfoResponse) -> Void = { s in
//                        do {
//                            let user = try User(codable: s.data)
//                            seal.fulfill(user)
//                        } catch let error {
//                            seal.reject(error)
//                        }
//                    }
//
//                    let failure: (CodableWalletFailure) -> Void = { f in
//                        guard f.errors.count > 0 else {
//                            let error = WalletResponseError.undefinedServerFailureResponse
//                            seal.reject(error)
//                            return
//                        }
//
//                        let error = WalletResponseError.serverFailureResponse(errors: f.errors)
//                        seal.reject(error)
//                    }
//
//                    do {
//                        try response.extractResult(success: success, failure: failure)
//                    } catch let error {
//                        seal.reject(error)
//                    }
//                case .error(let error):
//                    seal.reject(error)
//                }
//            }.catch {
//                error in
//                seal.reject(error)
//            }
//        }
//    }
//
//    func createWallet(token: String, coin: CoinType, walletName: String?) -> Promise<Wallet> {
//        return Promise { seal in
//            let request = UserRequest.createWallet(token: token, coin: coin.rawValue, walletName: walletName)
//            provider.execute(request).done {
//                response in
//                switch response {
//                case .data(_):
//
//                    let success: (CodableWalletResponse) -> Void = { s in
//                        do {
//                            let wallet = try Wallet(codable: s.data.wallet)
//                            seal.fulfill(wallet)
//                        } catch let e {
//                            seal.reject(e)
//                        }
//                    }
//
//                    let failure: (CodableWalletFailure) -> Void = { f in
//                        guard f.errors.count > 0 else {
//                            let error = WalletResponseError.undefinedServerFailureResponse
//                            seal.reject(error)
//                            return
//                        }
//
//                        let error = WalletResponseError.serverFailureResponse(errors: f.errors)
//                        seal.reject(error)
//                    }
//
//                    do {
//                        try response.extractResult(success: success, failure: failure)
//                    } catch let error {
//                        seal.reject(error)
//                    }
//                case .error(let error):
//                    seal.reject(error)
//                }
//            }.catch {
//                error in
//                seal.reject(error)
//            }
//        }
//    }
//
//    /**
//     Get users wallets list.
//
//     - parameter token: Current session's token.
//     - parameter coin: Filter receiving wallets list by coin.
//     - parameter id: Filter receiving wallets list by wallet id.
//     - parameter page: Link on specific page of list.
//     - parameter count: Count of wallets per page.
//
//     - returns: Array of wallets data structures.
//     */
//    func getWallets(token: String, coin: CoinType? = nil, id: String? = nil, page: String? = nil, count: Int? = nil) -> Promise<[Wallet]> {
//        return Promise { seal in
//            let request = UserRequest.getUserWallets(token: token, coin: coin?.rawValue, walletId: id, page: page, count: count)
//            provider.execute(request).done {
//                response in
//
//                switch response {
//                case .data(_):
//
//                    let success: (CodableWalletsPageResponse) -> Void = { s in
//                        let wallets = s.data.wallets.compactMap {
//                            return try? Wallet(codable: $0)
//                        }
//
//                        seal.fulfill(wallets)
//                    }
//
//                    let failure: (CodableWalletFailure) -> Void = { f in
//                        guard f.errors.count > 0 else {
//                            let error = WalletResponseError.undefinedServerFailureResponse
//                            seal.reject(error)
//                            return
//                        }
//
//                        let error = WalletResponseError.serverFailureResponse(errors: f.errors)
//                        seal.reject(error)
//                    }
//
//                    do {
//                        try response.extractResult(success: success, failure: failure)
//                    } catch let error {
//                        seal.reject(error)
//                    }
//                case .error(let error):
//                    seal.reject(error)
//                }
//            }.catch {
//                error in
//                seal.reject(error)
//            }
//        }
//    }
//
//    /**
//     Get wallet's info by id.
//
//     - parameter token: Current session's token.
//     - parameter walletId: Wallet's id.
//
//     - returns: Wallet's data.
//     */
//    func getWalletInfo(token: String, walletId: String) -> Promise<Wallet> {
//        return Promise { seal in
//            let request = UserRequest.getUserWalletInfo(token: token, walletId: walletId)
//            provider.execute(request).done {
//                response in
//
//                switch response {
//                case .data(_):
//
//                    let success: (CodableWalletResponse) -> Void = { s in
//                        do {
//                            let wallet = try Wallet(codable: s.data.wallet)
//                            seal.fulfill(wallet)
//                        } catch let e {
//                            seal.reject(e)
//                        }
//                    }
//
//                    let failure: (CodableWalletFailure) -> Void = { f in
//                        guard f.errors.count > 0 else {
//                            let error = WalletResponseError.undefinedServerFailureResponse
//                            seal.reject(error)
//                            return
//                        }
//
//                        let error = WalletResponseError.serverFailureResponse(errors: f.errors)
//                        seal.reject(error)
//                    }
//
//                    do {
//                        try response.extractResult(success: success, failure: failure)
//                    } catch let error {
//                        seal.reject(error)
//                    }
//                case .error(let error):
//                    seal.reject(error)
//                }
//            }.catch {
//                error in
//                seal.reject(error)
//            }
//        }
//    }
//
//    /**
//     Send money from specific wallet.
//
//     - parameter token: Current session's token.
//     - parameter walletId: Source wallet's id.
//     - parameter recipient: Recipient's phone or wallet address.
//     - parameter amount: Amount of crypto.
//
//     - returns: Information about sended transaction.
//     */
//    func sendTransaction(token: String, walletId: String, recipient: String, amount: Decimal) -> Promise<Transaction>  {
//        return Promise { seal in
//            let request = UserRequest.sendTransaction(token: token, walletId: walletId, recipient: recipient, amount: amount)
//            provider.execute(request).done {
//                response in
//
//                switch response {
//                case .data(_):
//
//                    let success: (CodableTransactionResponse) -> Void = { s in
//                        do {
//                            let transaction = try Transaction(codable: s.data.transaction)
//                            seal.fulfill(transaction)
//                        } catch let error {
//                            seal.reject(error)
//                        }
//                    }
//
//                    let failure: (CodableWalletFailure) -> Void = { f in
//                        guard f.errors.count > 0 else {
//                            let error = WalletResponseError.undefinedServerFailureResponse
//                            seal.reject(error)
//                            return
//                        }
//
//                        let error = WalletResponseError.serverFailureResponse(errors: f.errors)
//                        seal.reject(error)
//                    }
//
//                    do {
//                        try response.extractResult(success: success, failure: failure)
//                    } catch let error {
//                        seal.reject(error)
//                    }
//                case .error(let error):
//                    seal.reject(error)
//                }
//            }.catch {
//                error in
//                seal.reject(error)
//            }
//        }
//    }
//
//    /**
//     Get list of user's incoming and outgoing transactions.
//
//     - parameter token: Current session's token.
//     - parameter filter: List filter properties.
//     - parameter phoneNumberFormatter: Phone numbers formatter for converting transactions recipients phones to inner system format.
//     - parameter localContacts: List of users contacts for replacing transactions phone numbers with appropriated contacts names.
//
//     - returns: Page of grouped by time interval transactions.
//     */
//    func getTransactions(token: String, filter: TransactionsFilterProperties = TransactionsFilterProperties(), phoneNumberFormatter: PhoneNumberFormatter? = nil, localContacts: [Contact]? = nil) -> Promise<TransactionsPage>  {
//
//        // Get timezone
//        let timezoneOffset = Float(TimeZone.current.secondsFromGMT()) / 3600.0
//        let timezoneOffsetString = NumberFormatter.output.string(from: NSNumber(value: timezoneOffset))
//
//        let request = UserRequest.getTransactions(token: token,
//                                                  coin: filter.coin?.rawValue,
//                                                  walletId: filter.walletId,
//                                                  recipient: filter.recipient,
//                                                  direction: filter.direction?.rawValue,
//                                                  fromTime: filter.fromTime,
//                                                  untilTime: filter.untilTime,
//                                                  timezone: timezoneOffsetString,
//                                                  page: filter.page,
//                                                  count: filter.count,
//                                                  group: filter.group.rawValue)
//
//        return Promise { seal in
//            provider.execute(request).done {
//                response in
//
//                switch response {
//                case .data(_):
//
//                    let success: (CodableGroupedTransactionsPageResponse) -> Void = { s in
//                        do {
//                            let page = try TransactionsPage(codable: s.data)
//
//                            guard let phoneNumberFormatter = phoneNumberFormatter else {
//                                seal.fulfill(page)
//                                return
//                            }
//
//                            DispatchQueue.global(qos: .default).async {
//
//                                let input: [[String]] = page.transactions.map {
//                                    group in
//                                    group.transactions.map {
//                                        $0.participant
//                                    }
//                                }
//
//                                phoneNumberFormatter.getCompleted(from: input) {
//                                    parsed in
//
//                                    var newGroups: [TransactionsGroup] = []
//
//                                    for (i, phones) in parsed.enumerated() {
//
//                                        var newTransactions: [Transaction] = []
//
//                                        for (j, phone) in phones.enumerated() {
//                                            var newTransaction = page.transactions[i].transactions[j]
//                                            newTransaction.participantPhoneNumber = phone
//
//                                            if let phone = phone,
//                                                let contacts = localContacts,
//                                                let phoneContact = contacts.first(where: {
//                                                    $0.phoneNumbers.contains(phone.numberString)
//                                                }) {
//                                                newTransaction.contact = phoneContact
//                                            }
//
//                                            newTransactions.append(newTransaction)
//                                        }
//
//                                        let newGroup = TransactionsGroup(dateInterval: page.transactions[i].dateInterval,
//                                                                             amount: page.transactions[i].amount,
//                                                                             transactions: newTransactions)
//                                        newGroups.append(newGroup)
//                                    }
//
//                                    let newPage = TransactionsPage(next: page.next, transactions: newGroups)
//
//                                    DispatchQueue.main.async {
//                                        seal.fulfill(newPage)
//                                    }
//                                }
//                            }
//                        } catch let error {
//                            seal.reject(error)
//                        }
//                    }
//
//                    let failure: (CodableWalletFailure) -> Void = { f in
//                        guard f.errors.count > 0 else {
//                            let error = WalletResponseError.undefinedServerFailureResponse
//                            seal.reject(error)
//                            return
//                        }
//
//                        let error = WalletResponseError.serverFailureResponse(errors: f.errors)
//                        seal.reject(error)
//                    }
//
//                    do {
//                        try response.extractResult(success: success, failure: failure)
//                    } catch let error {
//                        seal.reject(error)
//                    }
//                case .error(let error):
//                    seal.reject(error)
//                }
//            }.catch {
//                error in
//                seal.reject(error)
//            }
//        }
//    }
//
//    /**
//     Get KYC personal info progress information.
//
//     - parameter token: Current session's token.
//
//     - returns: Approving status and sended data if it was.
//     */
//    func getKYCPersonalInfo(token: String) -> Promise<KYCPersonalInfo> {
//        return Promise { seal in
//            let request = UserRequest.getKYCPersonalInfo(token: token)
//            provider.execute(request).done {
//                response in
//
//                switch response {
//                case .data(_):
//
//                    let success: (CodableKYCPersonalInfoResponse) -> Void = { s in
//                        do {
//                            let info = try KYCPersonalInfo(codable: s.data)
//                            seal.fulfill(info)
//                        } catch let e {
//                            seal.reject(e)
//                        }
//                    }
//
//                    let failure: (CodableWalletFailure) -> Void = { f in
//                        guard f.errors.count > 0 else {
//                            let error = WalletResponseError.undefinedServerFailureResponse
//                            seal.reject(error)
//                            return
//                        }
//
//                        let error = WalletResponseError.serverFailureResponse(errors: f.errors)
//                        seal.reject(error)
//                    }
//
//                    do {
//                        try response.extractResult(success: success, failure: failure)
//                    } catch let error {
//                        seal.reject(error)
//                    }
//                case .error(let error):
//                    seal.reject(error)
//                }
//            }.catch {
//                error in
//                seal.reject(error)
//            }
//        }
//    }
//
//    /**
//     Send KYC personal info data.
//
//     - parameter token: Current session's token.
//     - parameter personalData: All personal info properties.
//     */
//    func sendKYCPersonalInfo(token: String, personalData: KYCPersonaInfoProperties) -> Promise<Void> {
//        return self.sendKYCPersonalInfo(token: token,
//                                        email: personalData.email,
//                                        firstName: personalData.firstName,
//                                        lastName: personalData.lastName,
//                                        birthDate: personalData.birthDate,
//                                        gender: personalData.gender,
//                                        country: personalData.country,
//                                        city: personalData.city,
//                                        region: personalData.region,
//                                        street: personalData.street,
//                                        house: personalData.house,
//                                        postalCode: personalData.postalCode)
//    }
//
//    func sendKYCPersonalInfo(token: String, email: String, firstName: String, lastName: String, birthDate: Date, gender: GenderType, country: String, city: String, region: String, street: String, house: String, postalCode: Int) -> Promise<Void> {
//        return Promise { seal in
//            let request = UserRequest.sendKYCPersonalInfo(token: token,
//                                                          email: email,
//                                                          firstName: firstName,
//                                                          lastName: lastName,
//                                                          birthDate: String(Int(birthDate.unixTimestamp)),
//                                                          sex: gender.rawValue,
//                                                          country: country,
//                                                          city: city,
//                                                          region: region,
//                                                          street: street,
//                                                          house: house,
//                                                          postalCode: postalCode)
//            provider.execute(request).done {
//                response in
//                switch response {
//                case .data(_):
//
//                    let success: (CodableEmptyResponse) -> Void = { s in
//                        seal.fulfill(())
//                    }
//
//                    let failure: (CodableWalletFailure) -> Void = { f in
//                        guard f.errors.count > 0 else {
//                            let error = WalletResponseError.undefinedServerFailureResponse
//                            seal.reject(error)
//                            return
//                        }
//
//                        let error = WalletResponseError.serverFailureResponse(errors: f.errors)
//                        seal.reject(error)
//                    }
//
//                    do {
//                        try response.extractResult(success: success, failure: failure)
//                    } catch let error {
//                        seal.reject(error)
//                    }
//                case .error(let error):
//                    seal.reject(error)
//                }
//            }.catch {
//                error in
//                seal.reject(error)
//            }
//        }
//    }
//
//    func cancelTasks() {
//        provider.cancelAllTasks()
//    }
}
