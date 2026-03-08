import SwiftUI

public struct OffersListView: View {
    @StateObject private var viewModel: OffersViewModel
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    
    private let categories = ["All", "Electronics", "Fashion", "Grocery"]
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    public init(viewModel: OffersViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            DSColor.secondaryBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navbar
                headerView
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Search Section
                        searchBar
                        
                        // Promotional Banner (Mock)
                        bannerView
                        
                        // Categories
                        categoriesScrollView
                        
                        // Offers Content
                        contentView
                    }
                    .padding(.vertical, 16)
                }
                .refreshable {
                    await viewModel.fetchFirstPage()
                }
            }
        }
        #if os(iOS)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        #endif
        .task {
            if viewModel.offers.isEmpty {
                await viewModel.fetchFirstPage()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Explore Offers")
                    .font(DSTypography.title())
                    .foregroundColor(DSColor.textPrimary)
                Text("Find your favorite rewards")
                    .font(DSTypography.caption())
                    .foregroundColor(DSColor.textSecondary)
            }
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell.badge")
                    .font(.title3)
                    .foregroundColor(DSColor.textPrimary)
                    .padding(10)
                    .background(DSColor.surface)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.05), radius: 5)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(DSColor.surface)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(DSColor.textSecondary)
            TextField("Search for brands or items...", text: $searchText)
                .font(DSTypography.body())
        }
        .padding(14)
        .background(DSColor.surface)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.03), radius: 5)
        .padding(.horizontal)
    }
    
    private var bannerView: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(colors: [DSColor.primary, DSColor.primary.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Summer Deals!")
                        .font(DSTypography.subtitle())
                        .foregroundColor(.white)
                    Text("Get up to 50% discount on electronics items.")
                        .font(DSTypography.caption())
                        .foregroundColor(.white.opacity(0.9))
                }
                Spacer()
                Image(systemName: "bag.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(20)
        }
        .frame(height: 100)
        .padding(.horizontal)
    }
    
    private var categoriesScrollView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
                .font(DSTypography.subtitle())
                .foregroundColor(DSColor.textPrimary)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: { selectedCategory = category }) {
                            Text(category)
                                .font(DSTypography.caption().bold())
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(selectedCategory == category ? DSColor.primary : DSColor.surface)
                                .foregroundColor(selectedCategory == category ? .white : DSColor.textPrimary)
                                .cornerRadius(25)
                                .shadow(color: Color.black.opacity(selectedCategory == category ? 0.1 : 0.02), radius: 5)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Popular Offers")
                    .font(DSTypography.subtitle())
                    .foregroundColor(DSColor.textPrimary)
                Spacer()
                Button("See All") { 
                    // Action
                }
                .font(DSTypography.caption().bold())
                .foregroundColor(DSColor.primary)
            }
            .padding(.horizontal)
            
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    if viewModel.offers.isEmpty {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else {
                        offersGrid
                    }
                case .error(let message):
                    VStack(spacing: 12) {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.largeTitle)
                        Text(message)
                            .font(DSTypography.body())
                        Button("Retry") { 
                            Task { await viewModel.fetchFirstPage() }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(DSColor.primary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .foregroundColor(DSColor.textSecondary)
                case .empty:
                    Text("No offers found.")
                        .font(DSTypography.body())
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .foregroundColor(DSColor.textSecondary)
                case .loaded:
                    offersGrid
                }
            }
        }
    }
    
    private var offersGrid: some View {
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
        .padding(.horizontal)
    }
    
    private var filteredOffers: [Offer] {
        var filtered = viewModel.offers
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        return filtered
    }
}
