//
//  OffersListView.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad Aboelghet on 01/03/2026.
//

import SwiftUI

// Must be public to be used outside the module
public struct OffersListView: View {
    @StateObject private var viewModel: OffersViewModel
    @State private var searchText = ""
    @State private var selectedCategory = "الكل" // All
    
    private let categories = ["الكل", "الصحة والجمال", "الإلكترونيات", "المطاعم"]
    
    // Grid configuration: 2 columns
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    public init(viewModel: OffersViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Search Bar
            searchBar
            
            // Categories
            categoriesScrollView
            
            // Content
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    if viewModel.offers.isEmpty {
                        ProgressView()
                            .scaleEffect(1.2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        offersGrid
                    }
                    
                case .error(let message):
                    errorView(message: message)
                    
                case .empty:
                    emptyView
                    
                case .loaded:
                    offersGrid
                }
            }
            .background(DSColor.secondaryBackground.opacity(0.5))
        }
        .navigationBarHidden(true)
        .task {
            if viewModel.offers.isEmpty {
                await viewModel.fetchFirstPage()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Spacer()
            Text("قسائم")
                .font(.system(size: 18, weight: .bold))
            Spacer()
            Button(action: {}) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(Color.white)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("البحث عن قسائم...", text: $searchText)
                .multilineTextAlignment(.trailing)
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(DSColor.border, lineWidth: 1)
        )
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.white)
    }
    
    private var categoriesScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Button(action: { selectedCategory = category }) {
                        Text(category)
                            .font(.system(size: 14, weight: .medium))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category ? DSColor.primary : Color.white)
                            .foregroundColor(selectedCategory == category ? .white : .black)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedCategory == category ? DSColor.primary : DSColor.border, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(Color.white)
    }
    
    private var offersGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(filteredOffers) { offer in
                    OfferCardView(offer: offer)
                        .onAppear {
                            Task { await viewModel.loadMoreIfNeeded(currentItem: offer) }
                        }
                }
                
                if viewModel.isFetchingMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .padding(16)
        }
        .refreshable {
            await viewModel.fetchFirstPage()
        }
    }
    
    private var filteredOffers: [Offer] {
        var filtered = viewModel.offers
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        return filtered
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(DSColor.primary)
            Text(message)
                .foregroundColor(.secondary)
            Button("Try Again") {
                Task { await viewModel.fetchFirstPage() }
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyView: some View {
        VStack {
            Text("No offers available.")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
