import SwiftUI
import SpriteKit
import Combine

class GameData: ObservableObject {
    @Published var reward: Double = 0.0
    @Published var bet: Int = 50

    @Published var balance: Int = UserDefaultsManager.shared.coins
    @Published var isPlayTapped: Bool = false
    @Published var labels: [String] = ["1x", "1.5x", "2x", "5x", "10x", "5x", "2x", "1.5x", "1x"]
    
    var createBallPublisher = PassthroughSubject<Void, Never>()
    
    var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: balance)) ?? "\(balance)"
    }
    
    
    func decreaseBet() {
        if bet - 5 >= 5 {
            bet -= 5
        }
    }
    func increaseBet() {
        let newBet = bet + 5
        if newBet <= balance {
            bet = newBet
        }
    }
    
    
    func dropBalls() {
        guard bet <= balance else {
            return
        }
        UserDefaultsManager.shared.incrementTotalGames()
        let _ = UserDefaultsManager.shared.removeCoins(bet)
        balance = UserDefaultsManager.shared.coins
        reward = 0.0
        isPlayTapped = true
        createBallPublisher.send(())
    }
    
    func resetGame() {
        bet = 50
        reward = 0
        isPlayTapped = false
    }
    
    func addWin(_ amount: Double) {
        reward += amount
//        UserDefaultsManager.shared.addCoins(Int(reward))
//        balance = UserDefaultsManager.shared.coins
    }
    
    func finishGame() {
        UserDefaultsManager.shared.addCoins(Int(reward))
        balance = UserDefaultsManager.shared.coins
        reward = 0
        isPlayTapped = false
    }
}

class GameSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: GameData? {
        didSet {
        }
    }
    
    let ballCategory: UInt32 = 0x1 << 0
    let obstacleCategory: UInt32 = 0x1 << 1
    let ticketCategory: UInt32 = 0x1 << 2
    
    var ballsInPlay: Int = 0
    var ballNodes: [SKSpriteNode] = []
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        size = UIScreen.main.bounds.size
        backgroundColor = .clear
        
        createObstacles()
        createTickets()
        createInitialBalls()
        
        game?.createBallPublisher.sink { [weak self] in
            self?.launchBalls()
        }.store(in: &cancellables)
    }
    
    var cancellables = Set<AnyCancellable>()
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        for (index, ball) in ballNodes.enumerated().reversed() {
            if ball.position.y < 0 || ball.position.x < 0 || ball.position.x > size.width {
                ball.removeFromParent()
                ballNodes.remove(at: index)
                ballsInPlay -= 1
                createBall(atIndex: index)
            }
        }
    }
    
    func createObstacles() {
        let startRowCount = 2
        let numberOfRows = 6
        let obstacleSize = CGSize(width: /*size.width > 1000 ? 30 : */20, height: /*size.width > 1000 ? 40 : */50)
        let horizontalSpacing: CGFloat = /*size.width > 1000 ? 90 :*/ 15
        
        for row in 0..<numberOfRows {
            let countInRow = startRowCount + row
            let totalWidth = CGFloat(countInRow) * (obstacleSize.width + horizontalSpacing) - horizontalSpacing
            let xOffset = (size.width - totalWidth) / 2 + obstacleSize.width / 2
            let yPosition = (/*UIScreen.main.bounds.width > 1000 ? size.height / 1.35 : */size.height / 1.32) - CGFloat(row) * (obstacleSize.height +/* UIScreen.main.bounds.width > 1000 ? 105 : */45)
            
            for col in 0..<countInRow {
                let obstacle = SKSpriteNode(imageNamed: "obstacle")
                obstacle.size = obstacleSize
                let xPosition = xOffset + CGFloat(col) * (obstacleSize.width + horizontalSpacing)
                obstacle.position = CGPoint(x: xPosition, y: yPosition)
                
                obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacleSize.width / 2.0)
                obstacle.physicsBody?.isDynamic = false
                obstacle.physicsBody?.categoryBitMask = obstacleCategory
                obstacle.physicsBody?.contactTestBitMask = ballCategory
                
                addChild(obstacle)
            }
        }
    }
    
    func createTickets() {
        guard let game = self.game else { return }
        let labels = game.labels
        let count = labels.count
        let ticketWidth: CGFloat = 25
        let horizontalSpacing: CGFloat = 15
        let totalWidth = CGFloat(count) * (ticketWidth + horizontalSpacing) - horizontalSpacing
        let xOffset = (size.width - totalWidth) / 2 + ticketWidth / 2
        let yPosition = size.height / 17.5

        for i in 0..<count {
            let label = SKLabelNode(text: labels[i])
            label.fontName = "PaytoneOne-Regular"
            label.fontSize = 24
            label.fontColor = UIColor(red: 253/255, green: 255/255, blue: 193/255, alpha: 1)
            label.verticalAlignmentMode = .center
            label.horizontalAlignmentMode = .center
            label.position = CGPoint(x: 0, y: 0)
            label.xScale = 0.5
            label.yScale = 1
            label.name = "ticket_\(i)"

            let colorsPattern: [UIColor] = [
                UIColor(red: 216/255, green: 151/255, blue: 0/255, alpha: 1),
                UIColor(red: 216/255, green: 151/255, blue: 0/255, alpha: 1),
                UIColor(red: 244/255, green: 94/255, blue: 1/255, alpha: 1),
                UIColor(red: 194/255, green: 0/255, blue: 6/255, alpha: 1),
                UIColor(red: 194/255, green: 0/255, blue: 6/255, alpha: 1),
                UIColor(red: 194/255, green: 0/255, blue: 6/255, alpha: 1),
                UIColor(red: 244/255, green: 94/255, blue: 1/255, alpha: 1),
                UIColor(red: 216/255, green: 151/255, blue: 0/255, alpha: 1),
                UIColor(red: 216/255, green: 151/255, blue: 0/255, alpha: 1)
            ]
            let color = colorsPattern[i % colorsPattern.count]

            let backgroundSize = CGSize(width: ticketWidth + 10, height: label.frame.height + 35)
            let backgroundNode = SKShapeNode(rectOf: backgroundSize, cornerRadius: 3)
            backgroundNode.fillColor = color
            backgroundNode.strokeColor = UIColor.clear
            backgroundNode.position = CGPoint(x: xOffset + CGFloat(i) * (ticketWidth + horizontalSpacing), y: yPosition)
            backgroundNode.zPosition = label.zPosition - 1

            backgroundNode.physicsBody = SKPhysicsBody(rectangleOf: backgroundSize)
            backgroundNode.physicsBody?.isDynamic = false
            backgroundNode.physicsBody?.categoryBitMask = ticketCategory
            backgroundNode.physicsBody?.contactTestBitMask = ballCategory

            backgroundNode.addChild(label)

            addChild(backgroundNode)
        }
    }
    
    func createInitialBalls() {
        
        ballNodes.forEach { $0.removeFromParent() }
        ballNodes.removeAll()
        ballsInPlay = 0
        
            let ball = SKSpriteNode(imageNamed: "ball")
            ball.size = CGSize(width: 12, height: 30)
            ball.position = CGPoint(x: size.width / 2,
                                    y: size.height / 1.15)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 3)
        ball.physicsBody?.restitution = 0.7
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.linearDamping = 0.2
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.collisionBitMask = obstacleCategory | ticketCategory
            
            addChild(ball)
            ballNodes.append(ball)
            ballsInPlay += 1
       
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let game = game else { return }
        
        let ballCategory = self.ballCategory
        let ticketCategory = self.ticketCategory
        
        var ballNode: SKNode?
        var ticketNode: SKNode?
        
        if contact.bodyA.categoryBitMask == ballCategory {
            ballNode = contact.bodyA.node
        } else if contact.bodyB.categoryBitMask == ballCategory {
            ballNode = contact.bodyB.node
        }
        
        if contact.bodyA.categoryBitMask == ticketCategory {
            ticketNode = contact.bodyA.node
        } else if contact.bodyB.categoryBitMask == ticketCategory {
            ticketNode = contact.bodyB.node
        }
        
        guard let ball = ballNode as? SKSpriteNode,
              let ticketBackground = ticketNode as? SKShapeNode else {
            return
        }
        
        guard let ticketLabel = ticketBackground.children.compactMap({ $0 as? SKLabelNode }).first(where: {
            $0.name?.starts(with: "ticket_") == true
        }) else {
            print("Ticket label not found as child of ticket background node")
            return
        }
        
        guard let multiplier = parseMultiplier(from: ticketLabel.text) else {
            print("Failed to parse multiplier from label \(ticketLabel.text ?? "")")
            return
        }
        
        let win = Double(game.bet) * multiplier
        game.addWin(win)
        
        ball.removeFromParent()
        if let index = ballNodes.firstIndex(of: ball) {
            ballNodes.remove(at: index)
        }
        
        ballsInPlay -= 1
        
        createBall(atIndex: 0)
        
        checkBallsStopped()
    }

    
    func createBall(atIndex index: Int) {
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: 12, height: 30)
        ball.position = CGPoint(x: size.width / 2 ,
                                y: size.height / 1.15)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 3)
        ball.physicsBody?.restitution = 0.7
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.linearDamping = 0.2
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.collisionBitMask = obstacleCategory | ticketCategory
        
        addChild(ball)
        ballNodes.append(ball)
        ballsInPlay += 1
    }
    
    func launchBalls() {
        for (_, ball) in ballNodes.enumerated() {
            ball.physicsBody?.affectedByGravity = true
            
            let randomXImpulse = CGFloat.random(in: -0.01...0.01)
            
            ball.physicsBody?.applyImpulse(CGVector(dx: randomXImpulse, dy: 0))
        }
    }
    
    private func parseMultiplier(from text: String?) -> Double? {
        guard let text = text?.lowercased().replacingOccurrences(of: "x", with: "") else { return nil }
        return Double(text)
    }
    
    private func checkBallsStopped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self, let game = self.game else { return }
            let movingBalls = self.ballNodes.filter {
                guard let body = $0.physicsBody else { return false }
                return body.velocity.dx > 5 || body.velocity.dy > 5
            }
            if movingBalls.isEmpty && game.isPlayTapped {
                game.finishGame()
            }
        }
    }
}

struct PlinkoView: View {
    @StateObject var viewModel =  PlinkoViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @StateObject var gameModel = GameData()
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Image(.plinkoBg)
                    .resizable()
                
                LinearGradient(colors: [Color(red: 41/255, green: 5/255, blue: 26/255),
                                        Color(red: 116/255, green: 37/255, blue: 88/255)], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.8)
                
                Color(red: 52/255, green: 13/255, blue: 62/255)
                    .frame(height: 215)
                    .cornerRadius(44)
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Image(.plinkoRect)
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
                                                    Text("\(gameModel.balance)")
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
                            .fill(LinearGradient(colors: [Color(red: 27/255, green: 57/255, blue: 142/255).opacity(0.4),
                                                          Color(red: 89/255, green: 22/255, blue: 139/255).opacity(0.4)], startPoint: .leading, endPoint: .trailing))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 255/255, green: 0/255, blue: 234/255), lineWidth: 4)
                                    .overlay {
                                        SpriteView(scene: viewModel.createGameScene(gameData: gameModel), options: [.allowsTransparency])
                                            .frame(width: UIScreen.main.bounds.width > 700 ? 750 : 370, height: UIScreen.main.bounds.width > 700 ? 350 : 339)
                                    }
                            }
                            .frame(width: 370, height: 339)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .padding(.top, UIScreen.main.bounds.width > 700 ? 50 : 20)
                        
                        Rectangle()
                            .fill(.black.opacity(0.3))
                            .overlay {
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color(red: 255/255, green: 0/255, blue: 234/255), lineWidth: 4)
                                    .overlay {
                                        HStack(alignment: .bottom, spacing: 20) {
                                            VStack(spacing: 15) {
                                                HStack {
                                                    Text("Cost")
                                                        .font(.custom("PaytoneOne-Regular", size: 16))
                                                        .foregroundStyle(.white)
                                                }
                                                
                                                Rectangle()
                                                    .fill(LinearGradient(colors: [Color(red: 173/255, green: 70/255, blue: 255/255).opacity(0.2),
                                                                                  Color(red: 246/255, green: 51/255, blue: 154/255).opacity(0.2)], startPoint: .leading, endPoint: .trailing))
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .stroke(Color(red: 194/255, green: 122/255, blue: 255/255).opacity(0.3), lineWidth: 3)
                                                            .overlay {
                                                                HStack(spacing: 20) {
                                                                    Button(action: {
                                                                        gameModel.decreaseBet()
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
                                                                    
                                                                    Text("Bet: \(gameModel.bet)")
                                                                        .font(.custom("PaytoneOne-Regular", size: 18))
                                                                        .foregroundStyle(.white)
                                                                    
                                                                    Button(action: {
                                                                        gameModel.increaseBet()
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
                                                
                                                Button(action: {
                                                    withAnimation {
                                                        gameModel.dropBalls()
                                                    }
                                                }) {
                                                    Rectangle()
                                                        .fill(LinearGradient(colors: [Color(red: 214/255, green: 71/255, blue: 255/255),
                                                                                      Color(red: 230/255, green: 0/255, blue: 215/255)], startPoint: .leading, endPoint: .trailing))
                                                        .overlay {
                                                            Text("Drop Ball")
                                                                .font(.custom("PaytoneOne-Regular", size: 17))
                                                                .foregroundStyle(.white)
                                                        }
                                                        .frame(height: 42)
                                                        .cornerRadius(6)
                                                        .padding(.horizontal)
                                                }
                                            }
                                        }
                                    }
                            }
                            .frame(height: 157)
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
    PlinkoView()
}

