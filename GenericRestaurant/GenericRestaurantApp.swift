//
//  GenericRestaurantApp.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 4/15/25.
//

import SwiftUI
import SwiftData

@main
struct GenericRestaurantApp: App {    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ContactModel.self,
            ProfileModel.self,
            UserModel.self,
            SessionModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

func formatDate(_ isoString: String) -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

    guard let date = formatter.date(from: isoString) else {
        return isoString
    }

    let displayFormatter = DateFormatter()
    displayFormatter.dateStyle = .medium   // usa estilo del sistema para la fecha
    displayFormatter.timeStyle = .short    // usa estilo del sistema para la hora
    displayFormatter.locale = .current     // respeta configuración regional
    displayFormatter.timeZone = .current   // usa zona horaria del dispositivo

    return displayFormatter.string(from: date)
}

