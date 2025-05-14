//
//  Misc.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/13/25.
//
import SwiftUI

struct FullWidthText: View{
    var text: String;
    var body: some View{
        Text(text)
            .frame(maxWidth: .infinity, maxHeight:40)
    }
}
