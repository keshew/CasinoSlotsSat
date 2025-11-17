import SwiftUI

struct WheelView: View {
    @StateObject var viewModel =  WheelViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Image(.wheelBg)
                    .resizable()
                
                LinearGradient(colors: [Color(red: 41/255, green: 31/255, blue: 5/255),
                                        Color(red: 116/255, green: 116/255, blue: 36/255)], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.8)
                
                Color(red: 62/255, green: 49/255, blue: 14/255)
                    .frame(height: 215)
                    .cornerRadius(44)
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Image(.wheelRect)
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
                                        .fill(LinearGradient(colors: [Color(red: 152/255, green: 117/255, blue: 0/255),
                                                                      Color(red: 63/255, green: 58/255, blue: 0/255)], startPoint: .top, endPoint: .bottom))
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
                .padding(.top, UIScreen.main.bounds.width > 700 ? 50 : 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        ZStack {
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 5)
                                    .foregroundColor(Color(red: 212/255, green: 175/255, blue: 56/255))
                                
                                Circle()
                                    .stroke(lineWidth: 10)
                                    .foregroundColor(.clear)
                                
                                ForEach(viewModel.segments.indices) { i in
                                    let segmentCount = viewModel.segments.count
                                    let segmentAngle = 360.0 / Double(segmentCount)
                                    let midAngle = Double(i) * segmentAngle + segmentAngle / 2 - 90
                                    
                                    SectorShape(
                                        startAngle: Angle(degrees: Double(i) * segmentAngle),
                                        endAngle: Angle(degrees: Double(i + 1) * segmentAngle)
                                    )
                                    .fill(viewModel.segments[i].color)
                                    .shadow(color: viewModel.selectedSegmentIndex == i ? Color.yellow.opacity(0.8) : Color.clear,
                                            radius: viewModel.selectedSegmentIndex == i ? 15 : 0, x: 0, y: 0)
                                    .overlay(
                                        Text(viewModel.segments[i].title)
                                            .font(.custom("PaytoneOne-Regular", size: 16))
                                            .foregroundStyle(Color(red: 253/255, green: 255/255, blue: 193/255))
                                            .rotationEffect(Angle(degrees: midAngle + viewModel.rotationDegree))
                                            .position(
                                                x: 160 + 100 * CGFloat(cos(midAngle * .pi / 180)),
                                                y: 160 + 100 * CGFloat(sin(midAngle * .pi / 180))
                                            )
                                    )
                                    .onTapGesture {
                                        viewModel.selectedSegmentIndex = i
                                    }
                                }
                            }
                            .frame(width: 320, height: 320)
                            .rotationEffect(Angle(degrees: viewModel.rotationDegree))
                            
                            Triangle()
                                .fill(Color(red: 231/255, green: 201/255, blue: 104/255))
                                .scaleEffect(y: -1)
                                .frame(width: 30, height: 30)
                                .offset(y: -160)
                        }
                        .offset(y: -15)
                        .padding(.top, 50)
                        .alert("Attention", isPresented: $showAlert, actions: {
                            Button("OK", role: .cancel) {}
                        }, message: {
                            Text(viewModel.selectedSegmentIndex == nil ? "Please select a segment before spinning." : "Please set a valid bet amount.")
                        })
                           
                        
                        Rectangle()
                            .fill(LinearGradient(colors: [Color(red: 207/255, green: 189/255, blue: 0/255).opacity(0.2),
                                                          Color(red: 188/255, green: 148/255, blue: 1/255).opacity(0.2)], startPoint: .leading, endPoint: .trailing))
                            .overlay {
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color(red: 141/255, green: 135/255, blue: 24/255).opacity(0.5), lineWidth: 4)
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
                                                            .fill(Color(red: 207/255, green: 165/255, blue: 0/255).opacity(0.2))
                                                            .overlay {
                                                                RoundedRectangle(cornerRadius: 6)
                                                                    .stroke(Color(red: 230/255, green: 215/255, blue: 0/255).opacity(0.5), lineWidth: 2)
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
                                                        .fill(LinearGradient(colors: [Color(red: 207/255, green: 189/255, blue: 0/255),
                                                                                      Color(red: 188/255, green: 148/255, blue: 1/255)], startPoint: .leading, endPoint: .trailing))
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
                                                        if viewModel.bet <= (viewModel.coin - 5) {
                                                            viewModel.bet += 5
                                                        }
                                                    }) {
                                                        Rectangle()
                                                            .fill(Color(red: 207/255, green: 165/255, blue: 0/255).opacity(0.2))
                                                            .overlay {
                                                                RoundedRectangle(cornerRadius: 6)
                                                                    .stroke(Color(red: 230/255, green: 215/255, blue: 0/255).opacity(0.5), lineWidth: 2)
                                                                    .overlay {
                                                                        Text("+")
                                                                            .font(.custom("PaytoneOne-Regular", size: 18))
                                                                            .foregroundStyle(Color(red: 250/255, green: 224/255, blue: 153/255))
                                                                            .offset(y: -2)
                                                                    }
                                                            }
                                                            .frame(width: 37, height: 28)
                                                            .cornerRadius(6)
                                                    }
                                                }
                                                
                                                Button(action: {
                                                    withAnimation {
                                                        if viewModel.selectedSegmentIndex == nil {
                                                            showAlert = true
                                                        } else if viewModel.bet <= 0 {
                                                            showAlert = true
                                                        } else {
                                                            viewModel.spinWheel()
                                                        }
                                                    }
                                                }) {
                                                    Rectangle()
                                                        .fill(LinearGradient(colors: [Color(red: 207/255, green: 189/255, blue: 0/255),
                                                                                      Color(red: 188/255, green: 148/255, blue: 1/255)], startPoint: .leading, endPoint: .trailing))
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 6)
                                                                .stroke(Color(red: 230/255, green: 215/255, blue: 0/255).opacity(0.5), lineWidth: 2)
                                                                .overlay {
                                                                    Text(viewModel.isSpinning ? "SPINNING" : "LAUNCH")
                                                                        .font(.custom("PaytoneOne-Regular", size: 18))
                                                                        .foregroundStyle(.white)
                                                                }
                                                        }
                                                        .frame(width: 120, height: 32)
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
    WheelView()
}


struct SectorShape: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        path.addArc(center: center,
                    radius: rect.width/2,
                    startAngle: startAngle - Angle(degrees: 90),
                    endAngle: endAngle - Angle(degrees: 90),
                    clockwise: false)
        path.closeSubpath()
        return path
    }
}
