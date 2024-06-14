import Foundation
import Twilio


import SwiftUI

// Make Chore identifiable and observable
struct Chore: Identifiable {
    let id = UUID()
    let name: String
    var isCompleted: Bool
}

// Convert ChoreManager to an ObservableObject
class ChoreManager: ObservableObject {
    @Published var chores: [Chore] = []
    
    func addChore(name: String) {
        let newChore = Chore(name: name, isCompleted: false)
        chores.append(newChore)
    }
    
    func markChoreAsCompleted(index: Int) {
        if index >= 0 && index < chores.count {
            chores[index].isCompleted = true
        }
    }
    // Function to send SMS notification
    func sendSMSNotification(message: String, phoneNumber: String) {
        // Use Twilio API to send SMS notification
        // Replace ACCOUNT_SID, AUTH_TOKEN, and TWILIO_PHONE_NUMBER with your own values
        let accountSid = "YOUR_TWILIO_ACCOUNT_SID"
        let authToken = "YOUR_TWILIO_AUTH_TOKEN"
        let twilioPhoneNumber = "YOUR_TWILIO_PHONE_NUMBER"
        
        let twilio = Twilio(accountSid: accountSid, authToken: authToken)
        twilio.sendSMS(to: phoneNumber, from: twilioPhoneNumber, body: message)
    }
}

// SwiftUI View for displaying and managing chores
struct ChoresView: View {
    @ObservedObject var choreManager = ChoreManager()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(choreManager.chores) { chore in
                    HStack {
                        Text(chore.name)
                        Spacer()
                        if chore.isCompleted {
                            Image(systemName: "checkmark")
                        }
                        Button(action: {
                            if let index = choreManager.chores.firstIndex(where: { $0.id == chore.id }) {
                                choreManager.markChoreAsCompleted(index: index)
                            }
                        }) {
                            Text("Complete")
                        }
                    }
                }
            }
            .navigationBarTitle("Chores")
            .navigationBarItems(trailing: Button(action: {
                // Add action to present a view or alert to add a new chore
                choreManager.addChore(name: "New Chore")
            }) {
                Image(systemName: "plus")
            })
        }
    }
}

// Preview provider for SwiftUI previews in Xcode
struct ChoresView_Previews: PreviewProvider {
    static var previews: some View {
        ChoresView()
    }

}

// Usage example
let choreManager = ChoreManager()
choreManager.addChore(name: "Wash dishes")
choreManager.addChore(name: "Take out the trash")
choreManager.markChoreAsCompleted(index: 0)
choreManager.sendSMSNotification(message: "Chores are completed!", phoneNumber: "RECIPIENT_PHONE_NUMBER")