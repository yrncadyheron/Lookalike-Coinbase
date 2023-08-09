import SwiftUI
extension Color {
    static let tenBlack = Color(red: 0.043, green: 10/255, blue: 0.047)
    static let greay = Color(red: 138/255, green: 144/255, blue: 157/255)
    static let cusBlu = Color(red: 55/255, green: 114/255, blue: 244/255)
    static let blee = Color(red: 35/255, green: 35/255, blue: 35/255)
    static let graa = Color(red: 120/255, green: 125/255, blue: 140/255)
    static let bacBlu = Color(red: 21/255, green: 82/255, blue: 240/255)
}
extension Font {
    static func system(
        size: CGFloat,
        weight: Font.Weight,
        width: Font.Design
    ) -> Font {
        let uiFontWeight: UIFont.Weight
        switch weight {
        case .regular:
            uiFontWeight = .regular
        case .medium:
            uiFontWeight = .medium
        case .semibold:
            uiFontWeight = .semibold
        case .bold:
            uiFontWeight = .bold
        case .heavy:
            uiFontWeight = .heavy
        case .black:
            uiFontWeight = .black
        default:
            uiFontWeight = .regular
        }
        return Font.custom(
            UIFont.systemFont(ofSize: size, weight: uiFontWeight).fontName,
            size: size
        )
    }
}
struct Cryptocurrency: Identifiable {
    let id = UUID()
    var name: String
    var value: Double
    var constantNumber: Double
    var minValue: Double
    var maxValue: Double
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: [CGSize] = []
    static func reduce(value: inout [CGSize], nextValue: () -> [CGSize]) {
        value.append(contentsOf: nextValue())
    }
}
struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.bacBlu
                .ignoresSafeArea()
            VStack {
                Image("Image 5")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 750, height: 750)
                    .position(x: 205, y: 420)
            }
        }
    }
}

@main
struct Coinbase: App {
    @State private var showLoadingScreen = true

    var body: some Scene {
        WindowGroup {
            if showLoadingScreen {
                LoadingView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showLoadingScreen = false
                        }
                    }
            } else {
                ContentView()
            }
        }
    }
}

struct ContentView: View {
    @State private var selectedButton: Int = 0 // Keep track of the selected button index
    @State private var numbersWithDollarSigns: [Double] = [0.0, 0.0, 0.0, 1000.0, 0.0]
    @State private var growthRates: [Double] = [0.1, -0.1, 0.1, -0.1, 0.1]
    @State private var totalAmount: Double = 1000000.00 // Total amount placeholder
    @State private var totalAmountFormatted: String = "0.00" // Initialize the formatted total amount
    @State private var heightFromText: CGFloat = 0
    @State private var cryptocurrencies: [Cryptocurrency] = [
        Cryptocurrency(name: "Ethereum ", value: 124706.47, constantNumber: 68.0475, minValue: 100000.00, maxValue: 200000.0),
        Cryptocurrency(name: "Bitcoin   ", value: 86156.39, constantNumber: 2.931, minValue: 80000.0, maxValue: 90000.0),
        Cryptocurrency(name: "Solana    ", value: 33919.95, constantNumber: 1453.92, minValue: 20000.0, maxValue: 50000.0),
        Cryptocurrency(name: "USD Coin   ", value: 1204.43, constantNumber: 1204.43, minValue: 1000.0, maxValue: 2000.0),
        Cryptocurrency(name: "Dogecoin     ", value: 213.43, constantNumber: 2853.3422, minValue: 100.0, maxValue: 500.0)
    ]
    
    @State private var slowmoRotationAngle: Double = 0
    @State private var timer: Timer?
    
    let symbols = ["plus", "minus", "arrow.up", "arrow.down", "ellipsis"]
    let texting = ["Buy", "Sell", "Send", "Receive", "More"]
    let titles = ["Crypto", "NFTs", "DeFi"]
    let imageNames = ["Image", "Image 1", "Image 2", "Image 3", "Image 4"]
    
    var body: some View {
        ZStack {
            Color.tenBlack
                .ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Rectangle()
                            .foregroundColor(.graa)
                            .frame(width: 410, height: 3)
                            .position(x: 210, y: 870)
                            .opacity( 0.5)
                        
                        HStack(spacing: 10) {
                            ForEach(0..<titles.count) { index in // Use ForEach to create buttons dynamically
                                Button(action: {
                                    selectedButton = index // Update the selectedButton when a button is pressed
                                    showNotifications()
                                }) {
                                    Text(titles[index])
                                        .foregroundColor(selectedButton == index ? .cusBlu : .white) // Change the text color based on selection
                                        .padding(.horizontal, 20)
                                        .padding(.top, -15)
                                        .font(.system(size: 24, weight: .bold))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50, style: .circular)
                                                .frame(width: 75, height: 3)
                                                .foregroundColor(selectedButton == index ? .cusBlu : .clear)
                                                .offset(y: 10)
                                        )
                                }                            .offset(x:-55, y: 400)
                            }
                        }
                        .padding(.top, -15)
                        .alignmentGuide(.top) { _ in 30 }
                        .frame(height: 100)
                        
                        VStack(spacing: 0) {
                            Text("$\(totalAmountFormatted)")
                                .foregroundColor(.white)
                                .font(.system(size: 50, weight: .medium, design: .default))
                                .onAppear {
                                    // Calculate the initial total( sum)-redundant but need on appearance
                                    updateTotalAmount()
                                    // Starts s the timer to update the cryptocurrency values and total sum every 3 seconds
                                    Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                                        updateCryptocurrencyValues()
                                        updateTotalAmount()
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .position(x: 227.5, y: -40)
                            
                            Text("My balance")
                                .foregroundColor(.greay)
                                .font(.system(size: 25, weight: .medium, design: .default))
                                .padding(.bottom, 40)
                                .position(x: 86, y: -140)
                            
                            Image(systemName: "bell")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .position(x: 380, y: -315)
                                .bold()
                            
                            Image(systemName: "circle.grid.3x3.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .bold()
                                .padding(.bottom, 50)
                                .position(x: 40, y: -315)
                            
                            Image(systemName: "7.circle.fill")
                                .foregroundColor(.red)
                                .bold()
                                .position(x: 385, y: -426)
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .padding(.bottom, 50)
                                .offset(y: -565)
                                .position(x: 115, y: 160)
                            
                            Text("Search for an asset ")
                                .foregroundColor(.white)
                                .padding()
                                .font(.system(size: 16, weight: .thin, design: .default))
                                .offset(y: -525)
                            
                            RoundedRectangle(cornerRadius: 15, style: .circular)
                                .fill(Color.blee)
                                .opacity(0.75)
                                .offset(y: -565)
                                .frame(width: 250, height: 26)
                            
                            Image(systemName: "slowmo")
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(slowmoRotationAngle))
                                .position(x: 215, y: -725)
                            Capsule()
                                .fill(Color.graa)
                                .frame(height: 44)
                                .overlay(Text("Add more assets").bold())
                                .opacity(0.75)
                                .frame(width: 300, height: 26)
                                .position(x: 215, y: 300)
                        }
                        .offset(y: 125)
                        
                        
                        createCircles()
                        
                        if selectedButton == 0 {
                            
                            VStack(spacing: 10) {
                                
                                ForEach(cryptocurrencies) { cryptocurrency in
                                    VStack {
                                        Text("\(cryptocurrency.name)      $\(formatNumberWithCommas(cryptocurrency.value))")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20, weight: .semibold, design: .monospaced))
                                            .padding(.top, 20)
                                            .offset(x:25, y: -127.5)
                                        
                                        HStack {
                                            Spacer()
                                            Text("\(formatNumberWithCommas(cryptocurrency.constantNumber, showTwoDecimalPlaces: false)) \(getCurrencyAbbreviation(cryptocurrency.name)) ")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                                .offset(x:-25, y:-127.5)
                                        }
                                        
                                    }
                                }
                            }
                            
                            .onAppear {
                                // Start the timer to update the cryptocurrency values every 3 seconds
                                Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                                    updateCryptocurrencyValues()
                                }
                                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                                        withAnimation {
                                            slowmoRotationAngle += 345 // Rotate by 90 degrees every 3 seconds
                                        }
                                    }
                            }
                            
                            Image("Image")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .position(x: 40, y: -232)
                            Image("Image 1")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .position(x: 40, y: -430)
                            Image("Image 2")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .position(x: 40, y: -550)
                            Image("Image 3")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .position(x: 40, y: -308)
                            Image("Image 4")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .position(x: 40, y: -505)
                            
                        }
                        else {
                            Text("Nothing to find here...")
                                .foregroundColor(.white)
                                .padding()
                                .position(x: 215, y: 0)
                        }
                    }
                }
            }
        }
        private func updateNumbersWithDollarSigns() {
            for i in 0..<numbersWithDollarSigns.count {
                let growthRate = Double.random(in: -0.05...0.05)
                let newNumber = numbersWithDollarSigns[i] * (1.0 + growthRate)
                numbersWithDollarSigns[i] = newNumber
            }
            
            // Calculate the new total amount as the sum of the updated numbers
            totalAmount = numbersWithDollarSigns.reduce(0, +)
        }
        
        func getCurrencyAbbreviation(_ name: String) -> String {
            
            switch name {
            case "Ethereum ":
                return "ETH"
            case "Bitcoin   ":
                return "BTC"
            case "Solana    ":
                return "SOL"
            case "USD Coin   ":
                return "USDC"
            default:
                return "DOGE"
            }
        }
        func showNotifications() {
            // Request permission for notifications
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if granted {
                    print("Notification permission granted")
                    
                    let content1 = UNMutableNotificationContent()
                    content1.title = ""
                    content1.body = "📈 Bitcoin (BTC) +2.2% (17,479.92) in the last 23 mins"
                    content1.sound = UNNotificationSound.default
                    
                    let trigger1 = UNTimeIntervalNotificationTrigger(timeInterval: 61, repeats: true)
                    
                    let request1 = UNNotificationRequest(identifier: "Notification1", content: content1, trigger: trigger1)
                    
                    UNUserNotificationCenter.current().add(request1) { (error) in
                        if let error = error {
                            print("Error presenting Notification 1: \(error.localizedDescription)")
                        } else {
                            print("Notification 1 presented successfully")
                        }
                    }
                    
                    let content2 = UNMutableNotificationContent()
                    content2.title = "Signature requested"
                    content2.body = "Uniswap wants you to confirm a transaction"
                    content2.sound = UNNotificationSound.default
                    
                    let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: 180, repeats: true)
                    
                    let request2 = UNNotificationRequest(identifier: "Notification2", content: content2, trigger: trigger2)
                    
                    UNUserNotificationCenter.current().add(request2) { (error) in
                        if let error = error {
                            print("Error presenting Notification 2: \(error.localizedDescription)")
                        } else {
                            print("Notification 2 presented successfully")
                        }
                    }
                    
                    let content3 = UNMutableNotificationContent()
                    content3.title = "Coinbase"
                    content3.body = "You just received 0.92503 BTC from User..."
                    content3.sound = UNNotificationSound.default
                    
                    let trigger3 = UNTimeIntervalNotificationTrigger(timeInterval: 191, repeats: true)
                    
                    let request3 = UNNotificationRequest(identifier: "Notification3", content: content3, trigger: trigger3)
                    
                    UNUserNotificationCenter.current().add(request3) { (error) in
                        if let error = error {
                            print("Error presenting Notification 3: \(error.localizedDescription)")
                        } else {
                            print("Notification 3 presented successfully")
                        }
                    }
                }
            }
        }
        func formatNumberWithCommas(_ number: Double, showTwoDecimalPlaces: Bool = true) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            if showTwoDecimalPlaces {
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 2
            }
            return formatter.string(from: NSNumber(value: number)) ?? "0.00"
        }
        
        func updateCryptocurrencyValues() {
            for index in 0..<cryptocurrencies.count {
                var cryptocurrency = cryptocurrencies[index]
                let growthRate = Double.random(in: -0.03...0.03)
                var newValue = cryptocurrency.value * (1.0 + growthRate)
                
                if newValue < cryptocurrency.minValue {
                    newValue = cryptocurrency.minValue
                } else if newValue > cryptocurrency.maxValue {
                    newValue = cryptocurrency.maxValue
                }
                
                cryptocurrencies[index].value = max(newValue, cryptocurrency.minValue) // Ensure the value doesn't go below minValue
            }
        }
        
        private func updateTotalAmount() {
            totalAmount = cryptocurrencies.reduce(0) { $0 + $1.value }
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            totalAmountFormatted = formatter.string(from: NSNumber(value: totalAmount)) ?? "0.00"
        }
        func createCircles() -> some View {
            let circleSpacing: CGFloat = 80
            
            return ZStack {
                ForEach(0..<symbols.count) { index in
                    Circle()
                        .foregroundColor(.cusBlu)
                        .frame(width: 54, height: 54)
                        .position(x: 50 + CGFloat(index) * circleSpacing, y: 200)
                    Image(systemName: symbols[index])
                        .foregroundColor(.tenBlack)
                        .font(.system(size: 20))
                        .bold()
                        .position(x: 50 + CGFloat(index) * circleSpacing, y: 200)
                    Text(texting[index])
                        .foregroundColor(.greay)
                        .position(x: 50 + CGFloat(index) * circleSpacing, y: 255)
                }
            }                                            .offset(y: -450)
            
            
        }
    }
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }}
