import Network

class ESP32C6Interface: DeviceInterface {
    private var connection: NWConnection?
    
    override func connect(to ipAddress: String) {
        // Configure parameters for connecting to ESP32 device
        let params = NWParameters.tcp
        let host = NWEndpoint.Host(ipAddress) // Use the provided IP address
        let port = NWEndpoint.Port(integerLiteral: 1234) // Replace with desired port number
        
        // Create a connection to the ESP32 device
        connection = NWConnection(host: host, port: port, using: params)
        
        // Start the connection
        connection?.start(queue: .global())
    }
    
    override func disconnect() {
        connection?.cancel()
    }
    
    override func get() -> String {
        // Simulated implementation - replace with actual logic to query ESP32
        return "QueryResponse"
    }
    
    override func send(data: String) {
        let commandData = data.data(using: .utf8)
        
        connection?.send(content: commandData, completion: .contentProcessed { error in
            if let error = error {
                let errorMessage = "Error sending command: \(error)"
                notify(errorMessage)
            } else {
                let successMessage = "Command sent successfully: \(data)"
                notify(successMessage)
            }
        })
    }
}
