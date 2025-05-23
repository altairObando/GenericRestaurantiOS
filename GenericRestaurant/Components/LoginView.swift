//
//  LoginView.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/13/25.
//

import SwiftUI
import SwiftData
struct LoginView: View {
    @Environment(\.modelContext) private var modelContext;
    @FocusState private var focusedField: Field?
    @State private var username : String = String();
    @State private var password : String = String();
    @State private var isLoggin : Bool = false;
    @State private var showError: Bool = false;
    @State private var errorText: String = String();
    @Binding var isLoggedIn: Bool;
    var body: some View {
        VStack( alignment: .center ){
            Label("Login", systemImage: "person.crop.circle.badge.plus" )
                .font(.title)
            TextField("User Name", text: $username)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .submitLabel(.next)
                .focused($focusedField, equals: .username)
                .onSubmit {
                    focusedField = .password
                }
                
            SecureField("Password",  text: $password)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .submitLabel(.go)
                .focused($focusedField, equals: .password)
                .onSubmit{ doLogin() }
            Button(action: doLogin ){
                if(isLoggin){
                    ProgressView()
                        .tint(Color.white)
                        .frame(maxWidth: .infinity, maxHeight:40)
                }else {
                    FullWidthText(text: "Login")
                }
            }.buttonStyle(.borderedProminent)
            .disabled(isLoggin)
            Button{ print("f") } label:{
                FullWidthText(text: "Forgot password?")
            }.buttonStyle(.borderless)
        }.padding()
            .alert(Text("Loggin Error"), isPresented: $showError){
                Button("OK"){
                    showError = false;
                }
            } message: {
                Text(errorText)
            }
    }
    func doLogin(){
        isLoggin = true;
        APIService.shared.login(username: username, password: password){ result in
            isLoggin = false
            switch result {
                case .success(let authResponse):
                    handleLogin(response: authResponse, context: modelContext)
                case .failure(let error):
                    if let apiError = error as? APIErrorResponse {
                        errorText = apiError.error;
                    } else {
                        errorText = error.localizedDescription;
                    }
                    showError = true;
                }
        }
    }
    func handleLogin(response: AuthResponse, context: ModelContext) {
        let userModel = UserModel(
            username: response.user.username ?? "",
            email: response.user.email ?? "",
            isSuperuser: response.user.isSuperuser ?? false,
            groups: response.user.groups ?? []
        )
        let contactModel = ContactModel(
            name: response.profile.contact?.name,
            phoneNumber: response.profile.contact?.phoneNumber,
            address: response.profile.contact?.address,
            email: response.profile.contact?.email,
            middleName: response.profile.contact?.middleName,
            lastName: response.profile.contact?.lastName,
            gender: response.profile.contact?.gender
        )
        let profileModel = ProfileModel(
            role: response.profile.role,
            activeLocation: response.profile.activeLocation,
            contact: contactModel
        )
        let session = SessionModel(user: userModel, profile: profileModel)
        context.insert(session);
        isLoggedIn.toggle()
    }

}
#Preview {
    LoginView(isLoggedIn: .constant(false))
}

enum Field: Hashable {
    case username
    case password
}
