//
//  HomeView.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/13/25.
//

import SwiftUI
import SwiftData
struct HomeView: View {
    @Environment(\.modelContext) private var context
    @State private var authResponse: AuthResponse? = nil;
    @State private var isLoading = false
    @State private var errorMessage: String = String()
    @State private var showErrormsg: Bool = false
    @Binding var isLoggedIn: Bool;
    @State private var appConfig: InitialConfig? = nil;
    @State private var showRoleSheet: Bool = false;
    @State private var selectedRestaurant: Restaurant? = nil
    @State private var navigateToAdmin = false
    @State private var navigateToUser = false
    
    var body: some View {
        NavigationStack{
            VStack{
                if let auth = authResponse {
                    Text("Hi, \(auth.profile.contact?.name ?? "user")")
                        .font(.title)
                }
                if isLoading {
                    ProgressView("Loading...")
                }
                ScrollView{
                    if appConfig != nil {
                        Text("Please select a workspace")
                            .font(.subheadline)
                        LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())], spacing: 16){
                            ForEach(appConfig?.restaurants ?? []){ restaurant in
                                RestaurantCardView(restaurant: restaurant){ selected in
                                    selectedRestaurant = selected;
                                    if let auth = authResponse {
                                        if (auth.user.isSuperuser ?? false) || ((auth.user.groups ?? []).contains("admin")){
                                            showRoleSheet.toggle()
                                        }else{
                                            navigateToUser.toggle()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationDestination( isPresented: $navigateToAdmin){
                AdminDashboardView(isLoggedIn: $isLoggedIn)
            }
            .navigationDestination(isPresented: $navigateToUser){
                UserOrderView(isLoggedIn: $isLoggedIn)
            }
        }
        .onAppear{
            fetchUserData();
        }.sheet(isPresented: $showRoleSheet){
            VStack(spacing: 20){
                Text("Select your work mode")
                    .font(.headline)
                Button("Admin"){
                    showRoleSheet.toggle()
                    navigateToAdmin.toggle()
                }
                Divider()
                Button("User"){
                    showRoleSheet.toggle()
                    navigateToUser.toggle()
                }
            }.padding()
            .presentationDetents([.fraction(0.25), .medium]) // ✅ bottom sheet height
            .presentationDragIndicator(.visible)
        }
        // Error Alert
        .alert(Text("Conection Error"), isPresented: $showErrormsg){
            Button("Ok") {
                showErrormsg.toggle()
            }
        } message: {
            Text(errorMessage)
        }
    }
    func fetchUserData(){
        guard !isLoading else { return }
        let url = APIService.shared.apiURL.appendingPathComponent("auth/me/")
        isLoading = true
        APIService.shared.request(url: url){ (result: Result<AuthResponse, Error>) in
            isLoading = false
            switch result {
            case .success(let authResponse):
                self.authResponse = authResponse
                let session = SessionModel(from: authResponse)
                session.user = UserModel(from: authResponse.user)
                session.profile = ProfileModel(from: authResponse.profile)
                context.insert(session)
                fetchAppConfig()
                
            case .failure(let error):
                    errorMessage = error.localizedDescription;
                    APIService.shared.clearTokens()
                    isLoggedIn.toggle()
                    showErrormsg.toggle()
            }
        }
        
    }
    func fetchAppConfig(){
        APIService.shared
            .getInitialConfig { (result: Result<InitialConfig, Error>) in
            switch result {
                case .success(let appConfigResult):
                    appConfig = appConfigResult
                case .failure(let errorResult):
                    appConfig = nil;
                    errorMessage = errorResult.localizedDescription;
                    showErrormsg.toggle()
                }
                isLoading = false;
        }
    }
}

#Preview {
    HomeView(isLoggedIn: .constant(true))
}




