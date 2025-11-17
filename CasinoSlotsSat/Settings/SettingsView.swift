import SwiftUI

struct SettingsView: View {
    @StateObject var settingsModel =  SettingsViewModel()
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
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Image(.back)
                                            .resizable()
                                            .frame(width: 41, height: 41)
                                    }
                                    .padding(.leading, 6)
                                    
                                    Spacer()
                                    
                                    Image(.settingsLabel)
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
                                    .padding(.trailing, 18)
                                    .hidden()
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
                            .fill(LinearGradient(colors: [Color(red: 40/255, green: 16/255, blue: 40/255),
                                                          Color(red: 131/255, green: 28/255, blue: 142/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(red: 255/255, green: 81/255, blue: 231/255).opacity(0.3), lineWidth: 4)
                                    .overlay {
                                        VStack(spacing: 30) {
                                            VStack {
                                                Text("Sound Settings")
                                                    .font(.custom("PaytoneOne-Regular", size: 21))
                                                    .foregroundStyle(Color(red: 255/255, green: 81/255, blue: 231/255))
                                                
                                                Text("Customize your audio experience")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(Color(red: 153/255, green: 161/255, blue: 175/255))
                                            }
                                            
                                            VStack(spacing: 20) {
                                                Rectangle()
                                                    .fill(Color(red: 255/255, green: 81/255, blue: 231/255).opacity(0.1))
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 16)
                                                            .stroke(Color(red: 255/255, green: 81/255, blue: 231/255).opacity(0.2), lineWidth: 1)
                                                            .overlay {
                                                                HStack {
                                                                    Image(.music)
                                                                        .resizable()
                                                                        .frame(width: 17, height: 17)
                                                                    
                                                                    VStack(alignment: .leading) {
                                                                        Text("Sound Effects")
                                                                            .font(.custom("PaytoneOne-Regular", size: 14))
                                                                            .foregroundStyle(Color.white)
                                                                        
                                                                        Text("Game sounds & notifications")
                                                                            .font(.custom("PaytoneOne-Regular", size: 12))
                                                                            .foregroundStyle(Color(red: 153/255, green: 161/255, blue: 175/255))
                                                                    }
                                                                    
                                                                    Spacer()
                                                                    
                                                                    Toggle("", isOn: $settingsModel.isSoundOn)
                                                                        .toggleStyle(CustomToggleStyle())
                                                                        .frame(width: 48)
                                                                }
                                                                .padding(.horizontal)
                                                            }
                                                    }
                                                    .frame(height: 50)
                                                    .cornerRadius(16)
                                                
                                                Rectangle()
                                                    .fill(Color(red: 194/255, green: 122/255, blue: 255/255).opacity(0.1))
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 16)
                                                            .stroke(Color(red: 194/255, green: 122/255, blue: 255/255).opacity(0.2), lineWidth: 1)
                                                            .overlay {
                                                                HStack {
                                                                    Image(.sound)
                                                                        .resizable()
                                                                        .frame(width: 17, height: 17)
                                                                    
                                                                    VStack(alignment: .leading) {
                                                                        Text("Background Music")
                                                                            .font(.custom("PaytoneOne-Regular", size: 14))
                                                                            .foregroundStyle(Color.white)
                                                                        
                                                                        Text("Ambient casino music")
                                                                            .font(.custom("PaytoneOne-Regular", size: 12))
                                                                            .foregroundStyle(Color(red: 153/255, green: 161/255, blue: 175/255))
                                                                    }
                                                                    
                                                                    Spacer()
                                                                    
                                                                    Toggle("", isOn: $settingsModel.isMusicOn)
                                                                        .toggleStyle(CustomToggleStyle())
                                                                        .frame(width: 48)
                                                                }
                                                                .padding(.horizontal)
                                                            }
                                                    }
                                                    .frame(height: 50)
                                                    .cornerRadius(16)
                                            }
                                        }
                                        .padding()
                                    }
                            }
                            .frame(height: 251)
                            .cornerRadius(16)
                            .padding(.horizontal, 50)
                        
                        Color.clear.frame(height: 60)
                    }
                    .padding(.top, UIScreen.main.bounds.width > 700 ? 50 : 20)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .fill(.black)
                .frame(width: 28, height: 16)
                .overlay(
                    Circle()
                        .fill(.white)
                        .frame(width: 14, height: 14)
                        .offset(x: configuration.isOn ? 5 : -5)
                        .animation(.easeInOut, value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
