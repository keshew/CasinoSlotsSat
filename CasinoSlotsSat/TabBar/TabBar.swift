import SwiftUI

struct HubTabBarView: View {
    @State private var selectedTab: CustomTabBar.TabType = .Home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                if selectedTab == .Home {
                    HomeView()
                } else if selectedTab == .Slots {
                    SlotsView()
                } else if selectedTab == .Games {
                    GamesView()
                } else if selectedTab == .Awards {
                    AwardsView()
                }
            }
            .frame(maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 0)
            }
            
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HubTabBarView()
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabType
    
    enum TabType: Int {
        case Home
        case Slots
        case Games
        case Awards
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(Color(red: 74/255, green: 37/255, blue: 116/255))
                        .frame(height: 110)
                        .edgesIgnoringSafeArea(.bottom)
                    
                    Rectangle()
                        .fill(Color(red: 100/255, green: 66/255, blue: 136/255))
                        .frame(height: 3)
                }
                .offset(y: 35)
            }
            
            HStack(spacing: 30) {
                TabBarItem(imageName: "tab1", tab: .Home, selectedTab: $selectedTab)
                TabBarItem(imageName: "tab2", tab: .Slots, selectedTab: $selectedTab)
                TabBarItem(imageName: "tab3", tab: .Games, selectedTab: $selectedTab)
                TabBarItem(imageName: "tab4", tab: .Awards, selectedTab: $selectedTab)
            }
            .padding(.top, 10)
            .frame(height: 60)
        }
    }
}

struct TabBarItem: View {
    let imageName: String
    let tab: CustomTabBar.TabType
    @Binding var selectedTab: CustomTabBar.TabType
    
    var body: some View {
        Button(action: {
            withAnimation {
                selectedTab = tab
            }
        }) {
            if selectedTab == tab {
                Rectangle()
                    .fill(LinearGradient(colors: [Color(red: 240/255, green: 177/255, blue: 0/255).opacity(0.2),
                                                  Color(red: 173/255, green: 70/255, blue: 255/255).opacity(0.2)], startPoint: .bottom, endPoint: .top))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 253/255, green: 199/255, blue: 0/255))
                            .overlay {
                                VStack(spacing: 12) {
                                    VStack {
                                        Image((selectedTab == tab ? "\(imageName)Picked" : imageName))
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .shadow(color: Color(red: 253/255, green: 199/255, blue: 2/255), radius: selectedTab == tab ? 10 : 0)
                                        
                                        Text("\(tab)")
                                            .font(.custom("PaytoneOne-Regular", size: 12))
                                            .foregroundStyle(selectedTab == tab
                                                             ? Color(red: 253/255, green: 199/255, blue: 2/255) : Color(red: 153/255, green: 161/255, blue: 175/255))
                                    }
                                }
                            }
                    }
                    .frame(width: 65, height: 68)
                    .cornerRadius(16)
            } else {
                VStack(spacing: 12) {
                    VStack {
                        Image((selectedTab == tab ? "\(imageName)Picked" : imageName))
                            .resizable()
                            .frame(width: 24, height: 24)
                            .shadow(color: Color(red: 253/255, green: 199/255, blue: 2/255), radius: selectedTab == tab ? 10 : 0)
                        
                        Text("\(tab)")
                            .font(.custom("PaytoneOne-Regular", size: 12))
                            .foregroundStyle(selectedTab == tab
                                             ? Color(red: 253/255, green: 199/255, blue: 2/255) : Color(red: 153/255, green: 161/255, blue: 175/255))
                    }
                }
                .frame(width: 65, height: 68)
            }
        }
    }
}
