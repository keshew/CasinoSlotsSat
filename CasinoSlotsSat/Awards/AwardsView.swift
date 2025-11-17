import SwiftUI

struct Achiev: Identifiable, Codable {
    var id = UUID()
    var imageName: String
    var name: String
    var desc: String
    var goal: Int
    var currentGoal: Int
    var isUnlocked: Bool {
        currentGoal >= goal
    }
    var award: Int
}

struct AwardsView: View {
    @StateObject var awardsModel =  AwardsViewModel()
    @State var achiev = [Achiev(imageName: "award1", name: "Slot Explorer", desc: "Try all 4 slot machines", goal: 4, currentGoal: 0, award: 200),
                  Achiev(imageName: "award2", name: "High Roller", desc: "Win 10,000 coins in total", goal: 10000, currentGoal: 0, award: 500),
                  Achiev(imageName: "award3", name: "Lucky Streak", desc: "Win 1,000 coins in a single spin", goal: 1000, currentGoal: 0, award: 1000),
                  Achiev(imageName: "award4", name: "Dedicated Player", desc: "Play 100 games", goal: 100, currentGoal: 0, award: 300),
                  Achiev(imageName: "award5", name: "Spin Master", desc: "Make 500 spins", goal: 500, currentGoal: 0, award: 500)]
    @State var coins = UserDefaultsManager.shared.coins
    @State var isProfile = false
    @State var isSet = false
    
    func updateAchievementsProgress() {
        achiev[0].currentGoal = UserDefaultsManager.shared.allFourGamesPlayed ? 4 : 0
        achiev[1].currentGoal = min(UserDefaultsManager.shared.totalWins, 10000)
        achiev[2].currentGoal = UserDefaultsManager.shared.hasWon1000Once ? 1000 : 0
        achiev[3].currentGoal = min(UserDefaultsManager.shared.totalGames, 100)
        achiev[4].currentGoal = min(UserDefaultsManager.shared.totalSpins, 500)
        coins = UserDefaultsManager.shared.coins
    }
    
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
                    VStack(spacing: 20) {
                        ForEach(achiev, id: \.id) { index in
                            Rectangle()
                                .fill(.white.opacity(0.05))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white.opacity(0.2), lineWidth: 4)
                                        .overlay {
                                            HStack {
                                                Image(index.imageName)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 32, height: 32)
                                                
                                                VStack(alignment: .leading, spacing: 6) {
                                                    HStack {
                                                        Text(index.name)
                                                            .font(.custom("PaytoneOne-Regular", size: 16))
                                                            .foregroundStyle(.white)
                                                        
                                                        Spacer()
                                                    }
                                                    
                                                    Text(index.desc)
                                                        .font(.custom("PaytoneOne-Regular", size: 12))
                                                        .foregroundStyle(Color(red: 215/255, green: 211/255, blue: 222/255))
                                                    
                                                    VStack {
                                                        HStack {
                                                            Text("Progress: \(index.currentGoal)/\(index.goal)")
                                                                .font(.custom("PaytoneOne-Regular", size: 10))
                                                                .foregroundStyle(Color(red: 215/255, green: 211/255, blue: 222/255))

                                                            Spacer()
                                                            
                                                            let progressPercent = index.goal != 0 ? Int(Double(index.currentGoal) / Double(index.goal) * 100) : 0
                                                            Text("\(progressPercent)%")
                                                                .font(.custom("PaytoneOne-Regular", size: 12))
                                                                .foregroundStyle(Color(red: 215/255, green: 211/255, blue: 222/255))
                                                        }

                                                    }
                                                    .padding(.top, 5)
                                                    
                                                    GeometryReader { geometry in
                                                        ZStack(alignment: .leading) {
                                                            Rectangle()
                                                                .fill(.white.opacity(0.1))
                                                                .frame(width: geometry.size.width, height: 8)
                                                                .cornerRadius(10)
                                                            
                                                            Rectangle()
                                                                .fill(LinearGradient(colors: [Color(red: 81/255, green: 161/255, blue: 255/255),
                                                                                             Color(red: 195/255, green: 122/255, blue: 255/255)], startPoint: .leading, endPoint: .trailing))
                                                                .frame(width: geometry.size.width * min(CGFloat(index.currentGoal) / CGFloat(index.goal), 1.0), height: 8)
                                                                .cornerRadius(10)
                                                        }
                                                    }
                                                    
                                                    HStack(spacing: 5) {
                                                        Image(.coin)
                                                            .resizable()
                                                            .frame(width: 25, height: 25)
                                                        
                                                        Text("Reward: \(index.award) coins")
                                                            .font(.custom("PaytoneOne-Regular", size: 12))
                                                            .foregroundStyle(Color(red: 253/255, green: 198/255, blue: 0/255))
                                                    }
                                                    .padding(.top, 10)
                                                }
                                                .padding(.horizontal, 5)

                                                
                                                Spacer()
                                            }
                                            .padding()
                                        }
                                }
                                .frame(height: 136)
                                .cornerRadius(16)
                                .padding(.horizontal)
                        }
                        
                        Color.clear.frame(height: 60)
                    }
                    .padding(.top, UIScreen.main.bounds.width > 700 ? 50 : 20)
                }
            }
        }
        .onAppear {
              updateAchievementsProgress()
          }
        .fullScreenCover(isPresented: $isProfile) {
            ProfileView()
        }
        .fullScreenCover(isPresented: $isSet) {
            SettingsView()
        }
    }
}

#Preview {
    AwardsView()
}

