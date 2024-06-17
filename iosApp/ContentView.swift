import UIKit
import SwiftUI
import FlashPaySDK

let msdk = FlashPayMSDK()
let options = SDKPaymentOptions(
    orderId: UUID().uuidString,
    projectId: "YOUR PROJECT ID",
    payment: SDKPayment(amount: 10000, currency: "KGS"),
    customer: ["id" : "1", "email" : "test@customer.me"],
    paymentData: nil
)

let params = msdk.setup(sdkPaymentOptions: options)

struct ComposeView: UIViewControllerRepresentable {
    class Callback: ResultCallback {
        @Binding var isPresented: Bool

        init(isPresented: Binding<Bool>) {
            self._isPresented = isPresented
        }
        
        func onError(error: SDKErrorResult) {
            print("Payment failed with error")
        }
        
        func onComplete(jsonResult: String) {
            print("Payment succeeded with result")
        }
        
        func onCancel() {
            print("Payment was canceled by the user.")
            isPresented = false
        }
    }
    
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        let callback = Callback(isPresented: $isPresented)
        let paymentViewController = msdk.paymentScreen(
            resultCallback: callback,
            sdkPaymentOptions: options,
            signature1: HMAC.shared.sha256(
                key: "YOUR SECRET KEY",
                message: params.paramForSignature1
            ),
            signature2: HMAC.shared.sha256(
                key: "YOUR SECRET KEY",
                message: params.paramForSignature2
            )
        )
        return paymentViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct ContentView: View {
    @State private var showComposeView = false
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                showComposeView = true
            }) {
                Text("openPaymentScreen")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .fullScreenCover(isPresented: $showComposeView) {
                ComposeView(isPresented: $showComposeView)
                    .ignoresSafeArea(.keyboard) 
            }
            Spacer()
        }
    }
}
