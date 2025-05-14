//
//  ContentView.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 4/15/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isLogged: Bool = false;
    @State private var checkingLoggin: Bool = true;
    var body: some View {
        VStack(alignment: .center, spacing: 10 ) {
            if(checkingLoggin){
                ProgressView()
                    .transition(.opacity)
            }else {
                if( !isLogged ){
                    LoginView(isLoggedIn: $isLogged)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }else{
                    HomeView(isLoggedIn: $isLogged)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: checkingLoggin)
        .animation(.easeInOut(duration: 0.4), value: isLogged)
        .onAppear(perform: checkLogin)
    }    
    func checkLogin(){
        // Check if already saved a token
        APIService.shared.refreshAccessToken{ result in
            DispatchQueue.main.async {
                withAnimation{
                    isLogged = result
                    // Clear previous data
                    let sessions = try? modelContext.fetch(FetchDescriptor<SessionModel>())
                    sessions?.forEach { modelContext.delete($0) }
                    if !result {
                        APIService.shared.logout(context: modelContext)
                    }
                    checkingLoggin = false
                }
            }
        }
    }
}
