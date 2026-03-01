//
//  OffersListView.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad Aboelghet on 01/03/2026.
//

import SwiftUI

// Must be public to be used outside the module
public struct OffersListView: View {
    @StateObject private var viewModel = OffersViewModel()
    @State private var searchText = ""
    
    // Public Initializer
    public init() {}
    
    public var body: some View {
        NavigationView {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("Loading offers...")
                        .scaleEffect(1.2)
                    
                case .error(let message):
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text("Oops! Something went wrong.")
                            .font(.headline)
                        Text(message)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Try Again") {
                            Task { await viewModel.fetchFirstPage() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                case .empty:
                    VStack {
                        Image(systemName: "tray")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No offers available right now.")
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    }
                    
                case .loaded:
                    List {
                        ForEach(filteredOffers) { offer in
                            OfferRowView(offer: offer)
                                .onAppear {
                                    // Enable infinite scrolling by loading more offers when the last item appears
                                    Task { await viewModel.loadMoreIfNeeded(currentItem: offer) }
                                }
                        }
                        
                        // Show a loading indicator at the end of the list when fetching more data
                        if viewModel.isFetchingMore {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    // Enable pull-to-refresh functionality
                    .refreshable {
                        await viewModel.fetchFirstPage()
                    }
                    // Enable search functionality
                    .searchable(text: $searchText, prompt: "Search offers...")
                }
            }
            .navigationTitle("Exclusive Offers")
            // Fetch the first page of offers when the view appears
            .task {
                if viewModel.offers.isEmpty {
                    await viewModel.fetchFirstPage()
                }
            }
        }
    }
    
    // Filter offers based on the search text
    private var filteredOffers: [Offer] {
        if searchText.isEmpty { return viewModel.offers }
        return viewModel.offers.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
}
