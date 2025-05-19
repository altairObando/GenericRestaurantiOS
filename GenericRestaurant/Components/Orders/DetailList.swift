//
//  DetailList.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/19/25.
//
import SwiftUI

struct DetailList: View {
    @Binding var orderDetails: [OrderDetailsSet];
    @Binding var selection: Set<Int>;
    @Binding var loading: Bool;
    @Binding var isEditing: Bool
    var body: some View {
        List(orderDetails, id: \.id, selection: $selection){ detail in
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(detail.productName)
                        .font(.body)
                    Spacer()
                    Text("x\(detail.quantity ?? 0)")
                        .foregroundColor(.gray)
                }
                HStack {
                    Text("Unit: $\(detail.itemPrice ?? "0")")
                    Spacer()
                    Text("Total: $\(detail.total ?? "0")")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }.padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                selection.contains(detail.id)
                ? Color(.clear) // Usa un color personalizado si está seleccionado
                : Color(.systemBackground)
            )
            .listRowInsets(EdgeInsets()) // Elimina paddings innecesarios
            .listRowBackground(Color.clear) // Evita que el fondo por defecto de selección se aplique
            .disabled(loading)
        }
        .frame(maxWidth: .infinity)
        .listStyle(.plain)
        .environment(\.editMode, .constant(isEditing ? EditMode.active : EditMode.inactive))
        .animation(.spring(), value: isEditing)
    }
}
