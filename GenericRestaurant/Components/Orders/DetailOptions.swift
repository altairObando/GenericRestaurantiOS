//
//  DetailOptions.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/19/25.
//

import SwiftUI

struct DetailOptions: View {
    @Binding var showPayments: Bool;
    var body: some View {
        HStack(spacing: 16){
            Button{
                print("Cancel")
            } label:{
                FullWidthText(text: "CANCEL")
            }.buttonStyle(.borderedProminent)
                .tint(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Button{
                showPayments = true;
            } label:{
                FullWidthText(text: "PAY")
            }.buttonStyle(.borderedProminent)
                .tint(Color.green)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }.padding(.horizontal)
    }
}
