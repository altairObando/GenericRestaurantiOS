//
//  LocationView.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/20/25.
//

import SwiftUI

struct LocationView: View {
    @Binding var restaurantId: Int;
    @Binding var openNewOrder: Bool;
    @Binding var newOrderId: Int;
    @Binding var showOrder: Bool;
    @State private var isLoading: Bool = true;
    @State private var loadingText: String = "Loading..."
    @State private var locations: [Location] = [];
    @State private var errorText: String = String()
    @State private var showError: Bool = false;
    var body: some View {
        if isLoading{
            ProgressView(loadingText);
        }
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10){
            ForEach(locations){ location in
                LocationItemView(itemId: location.id, itemName: location.location){ itemId in
                    createOrder(locationId: itemId)
                }
            }
        }.onAppear{
            getLocations()
        }
    }
    func getLocations(){
        Task{
            isLoading = true
            do{
                let locations = try await APIService.shared.getAvailableLocaitons(restaurantId);
                self.locations = locations;
            }
            DispatchQueue.main.async{
                self.isLoading = false;
            }
        }
    }
    func createOrder( locationId: Int ){
        loadingText = "Creating Order...";
        isLoading.toggle();
        Task{
            do{
                let newOrder = try await APIService.shared.createOrder(restaurant: restaurantId, location: locationId);
                newOrderId = newOrder.id;
                openNewOrder = false;
                showOrder = true;
                DispatchQueue.main.async{
                    isLoading.toggle();
                }
            }catch{
                errorText = error.localizedDescription;
                print(errorText)
                DispatchQueue.main.async{
                    showError.toggle();
                }
            }
            DispatchQueue.main.async{
                isLoading.toggle();
            }
        }
    }
}
