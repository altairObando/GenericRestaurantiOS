//
//  PricingList.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/19/25.
//

import SwiftUI
import Combine

struct PricingList: View {
    @StateObject private var viewModel: PricingListViewModel

    init(restaurantId: Int) {
        _viewModel = StateObject(wrappedValue: PricingListViewModel(restaurantId: restaurantId))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.pricing.indices, id: \.self) { index in
                    let price = viewModel.pricing[index]
                    HStack {
                        Label(price.productName, systemImage: "folder.badge.plus.fill")
                        Spacer()
                        Label(price.price, systemImage: "dollarsign")
                    }
                    .font(.subheadline)
                    .padding()
                    .onAppear {
                        viewModel.fetchNextIfNeeded(currentIndex: index)
                    }
                }
            }

            if viewModel.isFetching {
                ProgressView("Searching Products")
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search Products")
        .navigationTitle("Product Pricing")
    }
}

class PricingListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var pricing: [Pricing] = []
    @Published var isFetching: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private var nextPricingItems: String?
    private let restaurantId: Int

    init(restaurantId: Int) {
        self.restaurantId = restaurantId
        setupDebounce()
        fetchPricing() // Primera carga
    }

    private func setupDebounce() {
        $searchText
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.fetchPricing()
            }
            .store(in: &cancellables)
    }

    func fetchPricing() {
        Task {
            await MainActor.run { self.isFetching = true }
            do {
                let response = try await APIService.shared.getProductPricingAsync(
                    restaurantId,
                    onlyValid: 1,
                    productName: searchText
                )
                await MainActor.run {
                    self.pricing = response.results
                    self.nextPricingItems = response.next
                    self.isFetching = false
                }
            } catch {
                print("Error fetching pricing:", error)
                await MainActor.run { self.isFetching = false }
            }
        }
    }

    func fetchNextIfNeeded(currentIndex: Int) {
        guard currentIndex == pricing.count - 1, let next = nextPricingItems, !isFetching else { return }
        Task {
            await MainActor.run { self.isFetching = true }
            do {
                let response: PaginatedResult<[Pricing]> = try await APIService.shared.requestAsync(url: URL(string: next)!)
                await MainActor.run {
                    self.pricing.append(contentsOf: response.results)
                    self.nextPricingItems = response.next
                    self.isFetching = false
                }
            } catch {
                print("Error fetching next page:", error)
                await MainActor.run { self.isFetching = false }
            }
        }
    }
}

