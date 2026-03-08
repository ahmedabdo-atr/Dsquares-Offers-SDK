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
                // Custom Navbar with Glassmorphism
                headerView
                    .zIndex(10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Search Section
                        searchBar
                        
                        // Promotional Banner (Mock)
                        bannerView
                        
                        // Categories
                        categoriesScrollView
                        
                        // Offers Content
                        contentView
                    }
                    .padding(.vertical, 20)
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
            VStack(alignment: .leading, spacing: 4) {
                Text("Dsquares")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(DSColor.primary)
                Text("Exclusive Rewards")
                    .font(DSTypography.caption())
                    .foregroundColor(DSColor.textSecondary)
            }
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {}) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(DSColor.textPrimary)
                }
                
                Button(action: {}) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(DSColor.textPrimary)
                        
                        Circle()
                            .fill(DSColor.primary)
                            .frame(width: 8, height: 8)
                            .offset(x: 2, y: -2)
                    }
                }
                .padding(10)
                .background(DSColor.surface)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.05), radius: 5)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 15)
        .background(
            Rectangle()
                .fill(DSColor.surface.opacity(0.8))
                .background(.ultraThinMaterial)
                .ignoresSafeArea(edges: .top)
        )
        .overlay(
            Divider().opacity(0.5), alignment: .bottom
        )
    }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .font(.title3)
                .foregroundColor(DSColor.primary)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(DSColor.textSecondary)
                TextField("Search brands...", text: $searchText)
                    .font(DSTypography.body())
            }
            .padding(14)
            .background(DSColor.surface)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
        }
        .padding(.horizontal)
    }
    
    private var bannerView: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [DSColor.primary, Color(hex: "FF4D67")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: DSColor.primary.opacity(0.3), radius: 15, x: 0, y: 10)
            
            // Decorative shapes
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 150)
                .offset(x: 200, y: -40)
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Summer Rewards")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Redeem your points for \nexclusive gift cards!")
                        .font(DSTypography.caption())
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                    
                    Button(action: {}) {
                        Text("Explore Now")
                            .font(.system(size: 12, weight: .bold))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .foregroundColor(DSColor.primary)
                            .cornerRadius(20)
                    }
                    .padding(.top, 4)
                }
                Spacer()
                Image(systemName: "gift.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.25))
                    .rotationEffect(.degrees(-15))
            }
            .padding(24)
        }
        .frame(height: 160)
        .padding(.horizontal)
    }
    
    private var categoriesScrollView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Categories")
                    .font(DSTypography.subtitle())
                    .foregroundColor(DSColor.textPrimary)
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: { 
                            withAnimation(.spring()) {
                                selectedCategory = category
                            }
                        }) {
                            Text(category)
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .padding(.horizontal, 22)
                                .padding(.vertical, 12)
                                .background(
                                    ZStack {
                                        if selectedCategory == category {
                                            DSColor.primary
                                                .matchedGeometryEffect(id: "cat", in: catNamespace)
                                        } else {
                                            DSColor.surface
                                        }
                                    }
                                )
                                .foregroundColor(selectedCategory == category ? .white : DSColor.textPrimary)
                                .cornerRadius(30)
                                .shadow(color: Color.black.opacity(selectedCategory == category ? 0.2 : 0.03), radius: 8, x: 0, y: 4)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
            }
        }
    }
    @Namespace private var catNamespace
    
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
