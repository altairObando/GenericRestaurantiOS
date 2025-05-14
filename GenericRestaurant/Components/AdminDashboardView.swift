//
//  AdminDashboardView.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/14/25.
//


import SwiftUI
import SwiftData

struct AdminDashboardView: View {
    @Binding var isLoggedIn: Bool;
    var body: some View {
        VStack {
            Text("Panel de Administración")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
    }
}
