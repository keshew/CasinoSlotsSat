import SwiftUI

struct EgyptSlotsView: View {
    @StateObject var viewModel =  EgyptSlotsViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Image(.bgEgypt)
                    .resizable()
                
                LinearGradient(colors: [Color(red: 36/255, green: 41/255, blue: 5/255),
                                        Color(red: 114/255, green: 116/255, blue: 37/255)], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.8)
                
                Color(red: 104/255, green: 59/255, blue: 8/255)
                    .frame(height: 215)
                    .cornerRadius(44)
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Image(.egRect)
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
                                    .padding(.leading, 5)
                                    
                                    Spacer()
                                    
                                    Image(.slotsLabel)
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
                                        .fill(LinearGradient(colors: [Color(red: 152/255, green: 124/255, blue: 1/255),
                                                                      Color(red: 64/255, green: 55/255, blue: 0/255)], startPoint: .top, endPoint: .bottom))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 24)
                                                .stroke(.white)
                                                .overlay {
                                                    Text("\(viewModel.coin)")
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
                .padding(.top)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        Rectangle()
                            .fill(LinearGradient(colors: [Color(red: 118/255, green: 139/255, blue: 21/255).opacity(0.7),
                                                          Color(red: 154/255, green: 154/255, blue: 23/255).opacity(0.6),
                                                          Color(red: 133/255, green: 127/255, blue: 44/255).opacity(0.7)], startPoint: .top, endPoint: .bottom))
                            .overlay {
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.4), lineWidth: 3)
                                    .overlay {
                                        VStack(spacing: 20) {
                                            ForEach(0..<3, id: \.self) { row in
                                                HStack(spacing: 0) {
                                                    ForEach(0..<5, id: \.self) { col in
                                                        Rectangle()
                                                            .fill(
                                                                LinearGradient(
                                                                    colors: [Color.black.opacity(0.2)],
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing
                                                                )
                                                            )
                                                            .overlay {
                                                                RoundedRectangle(cornerRadius: 14)
                                                                    .stroke(Color.white.opacity(0.3), lineWidth: 3)
                                                                    .overlay(
                                                                        Image(viewModel.slots[row][col])
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fit)
                                                                            .frame(width: 46, height: 46)
                                                                    )
                                                            }
                                                            .frame(width: 57, height: 58)
                                                            .cornerRadius(14)
                                                            .padding(.horizontal, 5)
                                                            .shadow(
                                                                color: viewModel.winningPositions.contains(where: { $0.row == row && $0.col == col }) ? Color.yellow : .clear,
                                                                radius: viewModel.isSpinning ? 0 : 25
                                                            )
                                                    }
                                                }
                                            }
                                        }
                                    }
                            }
                            .frame(height: 276)
                            .cornerRadius(18)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        Rectangle()
                            .fill(LinearGradient(colors: [Color(red: 22/255, green: 26/255, blue: 40/255).opacity(0.7),
                                                          Color(red: 30/255, green: 41/255, blue: 57/255).opacity(0.7)], startPoint: .top, endPoint: .bottom))
                            .overlay {
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color(red: 253/255, green: 89/255, blue: 0/255).opacity(0.5), lineWidth: 4)
                                    .overlay {
                                        HStack(alignment: .bottom, spacing: 20) {
                                            VStack(spacing: 5) {
                                                HStack {
                                                    Text("Cost")
                                                        .font(.custom("PaytoneOne-Regular", size: 16))
                                                        .foregroundStyle(.white)
                                                }
                                                
                                                Rectangle()
                                                    .fill(LinearGradient(colors: [Color(red: 207/255, green: 255/255, blue: 71/255).opacity(0.2),
                                                                                  Color(red: 246/255, green: 175/255, blue: 51/255).opacity(0.2)], startPoint: .leading, endPoint: .trailing))
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .stroke(Color(red: 255/255, green: 173/255, blue: 122/255).opacity(0.3), lineWidth: 3)
                                                            .overlay {
                                                                HStack(spacing: 20) {
                                                                    Button(action: {
                                                                        if viewModel.bet >= 5 {
                                                                            viewModel.bet -= 5
                                                                        }
                                                                    }) {
                                                                        Rectangle()
                                                                            .fill(.red.opacity(0.2))
                                                                            .overlay {
                                                                                RoundedRectangle(cornerRadius: 6)
                                                                                    .stroke(Color(red: 145/255, green: 255/255, blue: 100/255))
                                                                                    .overlay {
                                                                                        Text("- 5")
                                                                                            .font(.custom("PaytoneOne-Regular", size: 18))
                                                                                            .foregroundStyle(Color(red: 255/255, green: 162/255, blue: 162/255))
                                                                                    }
                                                                            }
                                                                            .frame(width: 37, height: 28)
                                                                            .cornerRadius(6)
                                                                    }
                                                                    
                                                                    Text("Bet: \(viewModel.bet)")
                                                                        .font(.custom("PaytoneOne-Regular", size: 18))
                                                                        .foregroundStyle(.white)
                                                                    
                                                                    Button(action: {
                                                                        if viewModel.bet <= (viewModel.coin - 5) {
                                                                            viewModel.bet += 5
                                                                        }
                                                                    }) {
                                                                        Rectangle()
                                                                            .fill(.green.opacity(0.2))
                                                                            .overlay {
                                                                                RoundedRectangle(cornerRadius: 6)
                                                                                    .stroke(Color(red: 145/255, green: 255/255, blue: 100/255))
                                                                                    .overlay {
                                                                                        Text("+ 5")
                                                                                            .font(.custom("PaytoneOne-Regular", size: 18))
                                                                                            .foregroundStyle(Color(red: 123/255, green: 241/255, blue: 168/255))
                                                                                    }
                                                                            }
                                                                            .frame(width: 37, height: 28)
                                                                            .cornerRadius(6)
                                                                    }
                                                                }
                                                            }
                                                    }
                                                    .frame( height: 37)
                                                    .cornerRadius(12)
                                                    .padding(.horizontal)
                                            }
                                        }
                                    }
                            }
                            .frame(height: 77)
                            .cornerRadius(18)
                            .padding(.horizontal)
                        
                        Button(action: {
                            if viewModel.coin >= viewModel.bet {
                                viewModel.spin()
                            }
                        }) {
                            Rectangle()
                                .fill(Color(red: 255/255, green: 123/255, blue: 1/255))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color(red: 253/255, green: 199/255, blue: 0/255), lineWidth: 3)
                                        .overlay {
                                            Text("EGYPT SPIN")
                                                .font(.custom("PaytoneOne-Regular", size: 18))
                                                .foregroundStyle(Color(red: 253/255, green: 249/255, blue: 0/255))
                                        }
                                }
                                .frame(height: 32)
                                .cornerRadius(6)
                                .padding(.horizontal)
                        }
                        .disabled(viewModel.isSpinning)
                        
                        Image(.egPayTab)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 370, height: 176)
                        
                        Color.clear.frame(height: 60)
                    }
                }
            }
            
            if viewModel.win >= 2000 {
                LinearGradient(colors: [Color(red: 36/255, green: 41/255, blue: 5/255),
                                        Color(red: 114/255, green: 116/255, blue: 37/255)], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.8).ignoresSafeArea()
                
                Image(.coins)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 100) {
                    Image(.winEg)
                        .resizable()
                        .frame(width: 340, height: 120)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(LinearGradient(colors: [Color(red: 152/255, green: 124/255, blue: 1/255),
                                                          Color(red: 64/255, green: 55/255, blue: 0/255)], startPoint: .top, endPoint: .bottom))
                            .overlay {
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(.white)
                                    .overlay {
                                        Text("+\(viewModel.win)")
                                            .font(.custom("PaytoneOne-Regular", size: 45))
                                            .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                            .offset(x: 7)
                                    }
                            }
                            .frame(width: 200, height: 50)
                            .cornerRadius(24)
                        
                        Image(.coin)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .offset(x: -15)
                    }
                    
                    Button(action: {
                        viewModel.win = 0
                    }) {
                        Rectangle()
                            .fill(Color(red: 255/255, green: 123/255, blue: 1/255))
                            .overlay {
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color(red: 253/255, green: 199/255, blue: 0/255), lineWidth: 4)
                                    .overlay {
                                        Text("CLAIM")
                                            .font(.custom("PaytoneOne-Regular", size: 40))
                                            .foregroundStyle(Color(red: 253/255, green: 249/255, blue: 0/255))
                                    }
                            }
                            .frame(width: 300, height: 70)
                            .cornerRadius(30)
                    }
                }
            }
        }
    }
}

#Preview {
    EgyptSlotsView()
}

