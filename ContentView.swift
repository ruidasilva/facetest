import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @State private var isUnlocked = false
    @State private var hasError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            if isUnlocked {
                Text("Welcome! You're authenticated!")
                    .font(.title)
                    .foregroundColor(.green)
                
                Button("Lock App") {
                    isUnlocked = false
                }
                .buttonStyle(.borderedProminent)
            } else {
                Text("App is Locked")
                    .font(.title)
                    .foregroundColor(.red)
                
                Button("Authenticate with Face ID") {
                    authenticate()
                }
                .buttonStyle(.borderedProminent)
            }
            
            if hasError {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometric authentication is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Perform biometric authentication
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                 localizedReason: "Authenticate to access the app") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isUnlocked = true
                        hasError = false
                        errorMessage = ""
                    } else {
                        hasError = true
                        errorMessage = authenticationError?.localizedDescription ?? "Authentication failed"
                    }
                }
            }
        } else {
            hasError = true
            errorMessage = error?.localizedDescription ?? "Face ID not available"
        }
    }
} 