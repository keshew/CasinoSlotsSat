import SwiftUI

struct GamesView: View {
    @StateObject var gamesModel =  GamesViewModel()
    @State var showAlert = false
    @State var isSlot1 = false
    @State var isSlot2 = false
    @State var isSlot3 = false
    @State var coins = UserDefaultsManager.shared.coins
    @State var isProfile = false
    @State var isSet = false
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Image(.mainBg)
                    .resizable()
                
                LinearGradient(colors: [Color(red: 15/255, green: 5/255, blue: 41/255),
                                        Color(red: 74/255, green: 37/255, blue: 116/255)], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.8)
                
                Color(red: 32/255, green: 14/255, blue: 62/255)
                    .frame(height: 215)
                    .cornerRadius(44)
            }
            .ignoresSafeArea()
            
            
            VStack {
                HStack {
                    Image(.topRect)
                        .resizable()
                        .overlay {
                            VStack(spacing: 10) {
                                HStack {
                                    Button(action: {
                                        isProfile = true
                                    }) {
                                        Image(.profile)
                                            .resizable()
                                            .frame(width: 41, height: 41)
                                    }
                                    .padding(.leading, 6)
                                    Spacer()
                                    Image(.gameLabel)
                                        .resizable()
                                        .frame(width: 120, height: 42)
                                    Spacer()
                                    Button(action: {
                                        isSet = true
                                    }) {
                                        Image(.settings)
                                            .resizable()
                                            .frame(width: 41, height: 41)
                                    }
                                    .padding(.trailing, 18)
                                }
                                
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(LinearGradient(colors: [Color(red: 58/255, green: 0/255, blue: 152/255),
                                                                      Color(red: 13/255, green: 0/255, blue: 63/255)], startPoint: .top, endPoint: .bottom))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 24)
                                                .stroke(.white)
                                                .overlay {
                                                    Text("\(coins)")
                                                        .font(.custom("PaytoneOne-Regular", size: 18))
                                                        .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                                        .offset(x: 11, y: -1)
                                                }
                                        }
                                        .frame(width: 90, height: 31)
                                        .cornerRadius(24)
                                    
                                    Image(.coin)
                                        .resizable()
                                        .frame(width: 42, height: 42)
                                        .offset(x: -10)
                                }
                            }
                            .offset(y: 10)
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 376, height: 130)
                        .padding(.horizontal)
                }
                .padding(.top)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: -20) {
                        VStack(spacing: 0) {
                            HStack {
                                Button(action: {
                                    isSlot1 = true
                                }) {
                                    Image(.mini1)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 181, height: 265)
                                }
                                
                                Button(action: {
                                    isSlot2 = true
                                }) {
                                    Image(.mini2)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 181, height: 265)
                                }
                            }
                            
                            HStack {
                                Button(action: {
                                    isSlot3 = true
                                }) {
                                    Image(.mini3)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 181, height: 265)
                                }
                                
                                ZStack(alignment: .bottom) {
                                    Image(.mini4)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 181, height: 265)
                                    
                                    Button(action: {
                                        showAlert = true
                                    }) {
                                        Rectangle()
                                            .fill(.white.opacity(0.5))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(.white, lineWidth: 3)
                                                    .overlay {
                                                        VStack {
                                                            Text("Buy")
                                                                .font(.custom("PaytoneOne-Regular", size: 12))
                                                                .foregroundStyle(.white)
                                                            
                                                            Text("100000")
                                                                .font(.custom("PaytoneOne-Regular", size: 12))
                                                                .foregroundStyle(.white)
                                                        }
                                                    }
                                            }
                                            .frame(width: 109, height: 36)
                                            .cornerRadius(16)
                                    }
                                    .offset(y: -60)
                                    .alert("Not enough coins to unlock", isPresented: $showAlert) {
                                        Button("OK") {}
                                    }
                                }
                            }
                        }
                        
                        Color.clear.frame(height: 60)
                    }
                    .padding(.top, UIScreen.main.bounds.width > 700 ? 50 : 20)
                }
            }
        }
        .onAppear() {
            NotificationCenter.default.addObserver(forName: Notification.Name("UserResourcesUpdated"), object: nil, queue: .main) { _ in
                coins = UserDefaultsManager.shared.coins
            }
        }
        .fullScreenCover(isPresented: $isProfile) {
            ProfileView()
        }
        .fullScreenCover(isPresented: $isSet) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $isSlot1) {
            MinesView()
        }
        .fullScreenCover(isPresented: $isSlot2) {
            PlinkoView()
        }
        .fullScreenCover(isPresented: $isSlot3) {
            WheelView()
        }
    }
}

#Preview {
    GamesView()
}

