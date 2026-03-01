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
    
    private let networkService: OffersNetworkServiceProtocol
    private var currentPage = 1
    private var totalPages: Int? = 1
    
    // Dependency Injection for the network service, default value provided for convenience
    public init(networkService: OffersNetworkServiceProtocol = OffersNetworkService()) {
        self.networkService = networkService
    }
    
    // Pull and refresh action to fetch the first page and reset the state
    public func fetchFirstPage() async {
        state = .loading
        currentPage = 1
        offers.removeAll()
        await fetchOffers(page: currentPage)
    }
    
    // Load more action to fetch the next page if needed
    public func loadMoreIfNeeded(currentItem item: Offer) async {
        guard let lastItem = offers.last, lastItem.id == item.id else { return }
        
        // Ensure there are more pages to fetch
        guard let totalPages = totalPages, currentPage < totalPages else { return }
        
        // Ensure we're not already fetching data to avoid duplicate requests
        guard !isFetchingMore else { return }
        
        isFetchingMore = true
        currentPage += 1
        await fetchOffers(page: currentPage)
        isFetchingMore = false
    }
    
    // The main function that communicates with the Network Layer
    private func fetchOffers(page: Int) async {
        do {
            let response = try await networkService.fetchOffers(page: page)
            
            if page == 1 {
                self.offers = response.data
            } else {
                self.offers.append(contentsOf: response.data)
                // Append the new data to the existing data
            }
            
            self.totalPages = response.totalPages
            self.state = self.offers.isEmpty ? .empty : .loaded
            
        } catch {
            if let networkError = error as? NetworkError {
                self.state = .error(networkError.customMessage)
            } else {
                self.state = .error(error.localizedDescription)
            }
        }
    }
}
