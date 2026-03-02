//
//  OffersViewModel.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad Aboelghet on 01/03/2026.
//

import Foundation

// view state contains all the possible states of the view (loading, loaded, error, empty)
public enum ViewState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
    case empty
}

@MainActor
public class OffersViewModel: ObservableObject {
    @Published public private(set) var offers: [Offer] = []
    @Published public private(set) var state: ViewState = .idle
    @Published public private(set) var isFetchingMore = false
    
    private let getOffersUseCase: GetOffersUseCaseProtocol
    private var currentPage = 1
    private var hasMorePages = true
    
    public init(getOffersUseCase: GetOffersUseCaseProtocol) {
        self.getOffersUseCase = getOffersUseCase
    }
    
    public func fetchFirstPage() async {
        state = .loading
        currentPage = 1
        offers.removeAll()
        hasMorePages = true
        await fetchOffers(page: currentPage)
    }
    
    public func loadMoreIfNeeded(currentItem item: Offer) async {
        guard let lastItem = offers.last, lastItem.id == item.id else { return }
        guard hasMorePages, !isFetchingMore else { return }
        
        isFetchingMore = true
        currentPage += 1
        await fetchOffers(page: currentPage)
        isFetchingMore = false
    }
    
    private func fetchOffers(page: Int) async {
        do {
            let newOffers = try await getOffersUseCase.execute(page: page)
            
            if newOffers.isEmpty {
                hasMorePages = false
            } else {
                if page == 1 {
                    self.offers = newOffers
                } else {
                    self.offers.append(contentsOf: newOffers)
                }
            }
            
            self.state = self.offers.isEmpty ? .empty : .loaded
            
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
}
