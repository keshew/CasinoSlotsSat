import SwiftUI

struct MinesView: View {
    @StateObject var viewModel =  MinesViewModel()
    @Environment(\.presentationMode) var presentationMode
    let columns = Array(repeating: GridItem(.fixed(60), spacing: 0), count: 5)
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Image(.minesBg)
                    .resizable()
                
                LinearGradient(colors: [Color(red: 6/255, green: 36/255, blue: 41/255),
                                        Color(red: 37/255, green: 104/255, blue: 116/255)], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.8)
                
                Color(red: 13/255, green: 54/255, blue: 62/255)
                    .frame(height: 215)
                    .cornerRadius(44)
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Image(.minesRect)
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
                                    .padding(.leading, 5)
                                    
                                    Spacer()
                                    
                                    Image(.gameLabel)
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
                                        .fill(LinearGradient(colors: [Color(red: 0/255, green: 15/255, blue: 152/255),
                                                                      Color(red: 0/255, green: 26/255, blue: 63/255)], startPoint: .top, endPoint: .bottom))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 24)
                                                .stroke(.white)
                                                .overlay {
                                                    Text("\(viewModel.balance)")
                                                        .font(.custom("PaytoneOne-Regular", size: 16))
                                                        .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                                        .offset(x: 7, y: -1)
                                                }
                                        }
                                        .frame(width: 90, height: 31)
                                        .cornerRadius(24)
                                    
                                    Image(.coin)
                                        .resizable()
                                        .frame(width: 42, height: 42)
                                        .offset(x: -15)
                                }
                            }
                            .offset(y: 10)
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 376, height: 130)
                        .padding(.horizontal)
                }
                .padding(.top, UIScreen.main.bounds.width > 700 ? 50 : 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        Image(.minesBack)
                            .resizable()
                            .overlay {
                                Rectangle()
                                    .fill(.black.opacity(0.3))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 17)
                                            .stroke(Color(red: 3/255, green: 143/255, blue: 223/255), lineWidth: 5)
                                            .overlay {
                                                VStack(spacing: 10) {
                                                    LazyVGrid(columns: columns, spacing: 6) {
                                                        ForEach(viewModel.cards.indices, id: \.self) { index in
                                                            let card = viewModel.cards[index]
                                                            Button(action: {
                                                                viewModel.openCard(at: index)
                                                            }) {
                                                                if card.isOpened {
                                                                    Rectangle()
                                                                        .fill(
                                                                            LinearGradient(
                                                                                colors: card.isBomb
                                                                                ? [Color.red.opacity(0.8), Color.red.opacity(0.6)]
                                                                                : [Color.green.opacity(0.7), Color.green.opacity(0.4)],
                                                                                startPoint: .topLeading,
                                                                                endPoint: .bottomTrailing
                                                                            )
                                                                        )
                                                                        .overlay {
                                                                            RoundedRectangle(cornerRadius: 14)
                                                                                .stroke(
                                                                                    card.isBomb
                                                                                    ? Color.red.opacity(0.9)
                                                                                    : Color.green.opacity(0.9),
                                                                                    lineWidth: 3
                                                                                )
                                                                                .overlay(
                                                                                    Image(card.image)
                                                                                        .resizable()
                                                                                        .aspectRatio(contentMode: .fit)
                                                                                        .frame(width: 38, height: 42)
                                                                                )
                                                                        }
                                                                        .frame(width: 50, height: 50)
                                                                        .cornerRadius(14)
                                                                        .padding(.horizontal, 5)
                                                                        .shadow(
                                                                            color: card.isBomb
                                                                            ? Color.red.opacity(0.8)
                                                                            : Color.green.opacity(0.7),
                                                                            radius: 10
                                                                        )
                                                                } else {
                                                                    Rectangle()
                                                                        .fill(
                                                                            LinearGradient(
                                                                                colors: [Color.white.opacity(0.2), Color.white.opacity(0.1)],
                                                                                startPoint: .topLeading,
                                                                                endPoint: .bottomTrailing
                                                                            )
                                                                        )
                                                                        .overlay(
                                                                            RoundedRectangle(cornerRadius: 16)
                                                                                .stroke(Color.white.opacity(0.3), lineWidth: 3)
                                                                        )
                                                                        .frame(width: 50, height: 50)
                                                                        .cornerRadius(16)
                                                                        .padding(.horizontal, 5)
                                                                }
                                                            }
                                                            .disabled(card.isOpened || !viewModel.isPlaying)
                                                        }
                                                    }
                                                    .padding()
                                                    .disabled(!viewModel.isPlaying)
                                                }
                                            }
                                    }
                                    .frame(width: 310, height: 300)
                                    .cornerRadius(17)
                            }
                            .frame(width: 380, height: 376)
                            .padding(.top)
                        
                        Rectangle()
                            .fill(LinearGradient(colors: [Color(red: 0/255, green: 138/255, blue: 207/255).opacity(0.2),
                                                          Color(red: 0/255, green: 138/255, blue: 207/255).opacity(0.2)], startPoint: .top, endPoint: .bottom))
                            .overlay {
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color(red: 2/255, green: 169/255, blue: 230/255).opacity(0.5), lineWidth: 4)
                                    .overlay {
                                        HStack(alignment: .bottom, spacing: 20) {
                                            VStack(spacing: 15) {
                                                HStack {
                                                    Text("Bet amount")
                                                        .font(.custom("PaytoneOne-Regular", size: 16))
                                                        .foregroundStyle(Color(red: 185/255, green: 240/255, blue: 248/255))
                                                }
                                                
                                                HStack(spacing: 20) {
                                                    Button(action: {
                                                        if viewModel.bet >= 5 {
                                                            viewModel.bet -= 5
                                                        }
                                                    }) {
                                                        Rectangle()
                                                            .fill(Color(red: 0/255, green: 138/255, blue: 207/255).opacity(0.2))
                                                            .overlay {
                                                                RoundedRectangle(cornerRadius: 6)
                                                                    .stroke(Color(red: 2/255, green: 169/255, blue: 230/255).opacity(0.5), lineWidth: 2)
                                                                    .overlay {
                                                                        Text("-")
                                                                            .font(.custom("PaytoneOne-Regular", size: 18))
                                                                            .foregroundStyle(Color(red: 152/255, green: 209/255, blue: 249/255))
                                                                            .offset(y: -2)
                                                                    }
                                                            }
                                                            .frame(width: 37, height: 28)
                                                            .cornerRadius(6)
                                                    }
                                                    
                                                    Rectangle()
                                                        .fill(LinearGradient(colors: [Color(red: 0/255, green: 138/255, blue: 207/255),
                                                                                      Color(red: 0/255, green: 100/255, blue: 188/255)], startPoint: .leading, endPoint: .trailing))
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 6)
                                                                .stroke(Color(red: 3/255, green: 111/255, blue: 230/255).opacity(0.5), lineWidth: 2)
                                                                .overlay {
                                                                    Text("\(viewModel.bet) coins")
                                                                        .font(.custom("PaytoneOne-Regular", size: 18))
                                                                        .foregroundStyle(.white)
                                                                }
                                                        }
                                                        .frame(width: 137, height: 28)
                                                        .cornerRadius(6)
                                                    
                                                    Button(action: {
                                                        if viewModel.bet <= (viewModel.balance - 5) {
                                                            viewModel.bet += 5
                                                        }
                                                    }) {
                                                        Rectangle()
                                                            .fill(Color(red: 0/255, green: 138/255, blue: 207/255).opacity(0.2))
                                                            .overlay {
                                                                RoundedRectangle(cornerRadius: 6)
                                                                    .stroke(Color(red: 2/255, green: 169/255, blue: 230/255).opacity(0.5), lineWidth: 2)
                                                                    .overlay {
                                                                        Text("+")
                                                                            .font(.custom("PaytoneOne-Regular", size: 18))
                                                                            .foregroundStyle(Color(red: 152/255, green: 209/255, blue: 249/255))
                                                                            .offset(y: -2)
                                                                    }
                                                            }
                                                            .frame(width: 37, height: 28)
                                                            .cornerRadius(6)
                                                    }
                                                }
                                                
                                                Button(action: {
                                                    if viewModel.isPlaying {
                                                        viewModel.getReward()
                                                    } else {
                                                        viewModel.startGame()
                                                    }
                                                }) {
                                                    Rectangle()
                                                        .fill(LinearGradient(colors: [Color(red: 0/255, green: 138/255, blue: 207/255),
                                                                                      Color(red: 0/255, green: 100/255, blue: 188/255)], startPoint: .leading, endPoint: .trailing))
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 6)
                                                                .stroke(Color(red: 3/255, green: 111/255, blue: 230/255).opacity(0.5), lineWidth: 2)
                                                                .overlay {
                                                                    Text(viewModel.isPlaying ? "CLAIM" : "LAUNCH")
                                                                        .font(.custom("PaytoneOne-Regular", size: 18))
                                                                        .foregroundStyle(.white)
                                                                }
                                                        }
                                                        .frame(width: 100, height: 32)
                                                        .cornerRadius(6)
                                                        .padding(.horizontal)
                                                }
                                            }
                                        }
                                    }
                            }
                            .frame(height: 137)
                            .cornerRadius(18)
                            .padding(.horizontal)
                        
                        
                        Color.clear.frame(height: 60)
                    }
                }
            }
        }
    }
}

#Preview {
    MinesView()
}

