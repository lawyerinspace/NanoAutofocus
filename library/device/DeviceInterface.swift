import Foundation

// Abstract class DeviceInterface with abstract methods
class DeviceInterface {

    typealias ResponseHandler = (String) -> Void
    private var responseHandlers: [ResponseHandler] = []

    // Abstract method for connecting to the device
    func connect() {
        fatalError("Subclasses must implement the connect method")
    }
    
    // Abstract method for disconnecting from the device
    func disconnect() {
        fatalError("Subclasses must implement the disconnect method")
    }
    
    // Abstract method for getting data from the device
    func get() -> String {
        fatalError("Subclasses must implement the get method")
    }
    
    // Abstract method for sending data to the device
    func send(data: String) {
        fatalError("Subclasses must implement the send method")
    }

    // Method to attach an observer to handle responses
    func onResponse(_ handler: @escaping ResponseHandler) {
        responseHandlers.append(handler)
    }
    
    // Method to notify all observers with a string message
    func notify(_ message: String) {
        responseHandlers.forEach { $0(message) }
    }
}
