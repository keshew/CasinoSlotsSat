import SwiftUI

struct ProfileView: View {
    @StateObject var profileModel =  ProfileViewModel()
    @State var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    @State var coins = UserDefaultsManager.shared.coins
    
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
                                        NotificationCenter.default.post(name: Notification.Name("UserResourcesUpdated"), object: nil)
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Image(.back)
                                            .resizable()
                                            .frame(width: 41, height: 41)
                                    }
                                    .padding(.leading, 6)
                                    
                                    Spacer()
                                    
                                    Image(.profileLabel)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 120, height: 42)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                    }) {
                                        Image(.settings)
                                            .resizable()
                                            .frame(width: 41, height: 41)
                                    }
                                    .hidden()
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
                    VStack(spacing: 20) {
                        Rectangle()
                            .fill(.white.opacity(0.05))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.white.opacity(0.2), lineWidth: 4)
                                    .overlay {
                                        VStack(spacing: 6) {
                                            VStack {
                                                ZStack {
                                                    Circle()
                                                        .foregroundStyle(Color(red: 206/255, green: 102/255, blue: 231/255))
                                                        .frame(width: 80, height: 80)
                                                    
                                                    Circle()
                                                        .foregroundStyle(LinearGradient(colors: [Color(red: 173/255, green: 70/255, blue: 255/255),
                                                                                                 Color(red: 246/255, green: 51/255, blue: 154/255)], startPoint: .top, endPoint: .bottom))
                                                        .frame(width: 75, height: 75)
                                                }
                                                
                                                Text("Player")
                                                    .font(.custom("PaytoneOne-Regular", size: 16))
                                                    .foregroundStyle(.white)
                                            }
                                            
                                            HStack {
                                                Image(systemName: "star")
                                                    .foregroundStyle(Color(red: 253/255, green: 198/255, blue: 0/255))
                                                
                                                let level = UserDefaultsManager.shared.totalGames / 10 + 1
                                                Text("Level \(level)")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(.white)
                                            }
                                            
                                            VStack(spacing: 10) {
                                                GeometryReader { geometry in
                                                    let currentProgress = UserDefaultsManager.shared.totalGames % 10
                                                    let barWidth = geometry.size.width * CGFloat(currentProgress) / 10.0
                                                    
                                                    ZStack(alignment: .leading) {
                                                        Rectangle()
                                                            .fill(.white.opacity(0.1))
                                                            .frame(width: geometry.size.width, height: 8)
                                                            .cornerRadius(10)
                                                        
                                                        Rectangle()
                                                            .fill(LinearGradient(colors: [Color(red: 253/255, green: 199/255, blue: 0/255),
                                                                                         Color(red: 255/255, green: 137/255, blue: 2/255)], startPoint: .leading, endPoint: .trailing))
                                                            .frame(width: barWidth, height: 8)
                                                            .cornerRadius(10)
                                                    }
                                                }
                                                .frame(height: 8)
                                                
                                                let currentProgressText = UserDefaultsManager.shared.totalGames % 10
                                                Text("\(currentProgressText)/10 games to next level")
                                                    .font(.custom("PaytoneOne-Regular", size: 10))
                                                    .foregroundStyle(Color(red: 215/255, green: 211/255, blue: 222/255))
                                            }
                                            .padding(.top, 10)
                                        }
                                        .padding()
                                    }
                            }
                            .frame(height: 215)
                            .cornerRadius(16)
                            .padding(.horizontal)
                        
                        HStack(spacing: 15) {
                            Rectangle()
                                .fill(.white.opacity(0.05))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white.opacity(0.2), lineWidth: 4)
                                        .overlay {
                                            VStack(spacing: 0) {
                                                Image(.profil1)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 38, height: 40)
                                                
                                                Text("\(UserDefaultsManager.shared.totalWins)")
                                                    .font(.custom("PaytoneOne-Regular", size: 24))
                                                    .foregroundStyle(Color(red: 0/255, green: 223/255, blue: 114/255))
                                                
                                                Text("Total Winnings")
                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                    .foregroundStyle(.white.opacity(0.8))
                                                
                                            }
                                        }
                                }
                                .frame(height: 110)
                                .cornerRadius(16)
                            
                            Rectangle()
                                .fill(.white.opacity(0.05))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white.opacity(0.2), lineWidth: 4)
                                        .overlay {
                                            VStack(spacing: 0) {
                                                Image(.profil2)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 38, height: 40)
                                                
                                                Text("\(UserDefaultsManager.shared.totalGames)")
                                                    .font(.custom("PaytoneOne-Regular", size: 24))
                                                    .foregroundStyle(Color(red: 81/255, green: 161/255, blue: 255/255))
                                                
                                                Text("Games Played")
                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                    .foregroundStyle(.white.opacity(0.8))
                                                
                                            }
                                        }
                                }
                                .frame(height: 110)
                                .cornerRadius(16)
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 15) {
                            Rectangle()
                                .fill(.white.opacity(0.05))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white.opacity(0.2), lineWidth: 4)
                                        .overlay {
                                            VStack(spacing: 0) {
                                                Image(.profil3)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 38, height: 40)
                                                
                                                Text("\(UserDefaultsManager.shared.maxSingleWin)")
                                                    .font(.custom("PaytoneOne-Regular", size: 24))
                                                    .foregroundStyle(Color(red: 194/255, green: 122/255, blue: 255/255))
                                                
                                                Text("Biggest Win")
                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                    .foregroundStyle(.white.opacity(0.8))
                                                
                                            }
                                        }
                                }
                                .frame(height: 110)
                                .cornerRadius(16)
                            
                            Rectangle()
                                .fill(.white.opacity(0.05))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white.opacity(0.2), lineWidth: 4)
                                        .overlay {
                                            VStack(spacing: 0) {
                                                Image(.profil4)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 38, height: 40)
                                                
                                                Text("\(UserDefaultsManager.shared.totalSpins)")
                                                    .font(.custom("PaytoneOne-Regular", size: 24))
                                                    .foregroundStyle(Color(red: 255/255, green: 136/255, blue: 2/255))
                                                
                                                Text("Total Spins")
                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                    .foregroundStyle(.white.opacity(0.8))
                                                
                                            }
                                        }
                                }
                                .frame(height: 110)
                                .cornerRadius(16)
                        }
                        .padding(.horizontal)
                        
                        
                        Button(action: {
                            showAlert = true
                        }) {
                            Rectangle()
                                .fill(Color(red: 228/255, green: 14/255, blue: 22/255))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color(red: 246/255, green: 69/255, blue: 75/255), lineWidth: 3)
                                        .overlay {
                                            HStack(spacing: 10) {
                                                Image(systemName: "arrow.clockwise")
                                                    .foregroundStyle(.white)
                                                
                                                Text("Reset Progress")
                                                    .font(.custom("PaytoneOne-Regular", size: 18))
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                }
                                .frame(height: 60)
                                .cornerRadius(14)
                                .padding(.horizontal)
                        }
                        .alert("Attention", isPresented: $showAlert) {
                            Button("OK") {
                                UserDefaultsManager.shared.resetAllData()
                            }
                            Button("Cancel", role: .cancel) {
                                
                            }
                        } message: {
                            Text("This action can't be undone")
                        }
                        Color.clear.frame(height: 60)
                    }
                    .padding(.top, UIScreen.main.bounds.width > 700 ? 50 : 20)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}

