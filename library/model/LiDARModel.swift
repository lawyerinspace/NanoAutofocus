import ARKit

class LiDARModel {
    private var focalPoint: CGPoint
    private var observers: [(Double) -> Void] = []
    private var distanceUpdateTimer: Timer?
    
    init() {
        self.focalPoint = CGPoint()
        startDistanceUpdateTimer()
    }
    
    deinit {
        distanceUpdateTimer?.invalidate()
    }
    
    private func startDistanceUpdateTimer() {
        distanceUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { [weak self] _ in
            let distance = self?.getDistance() ?? 0.0
            self?.notify(distance)
        }
        distanceUpdateTimer?.tolerance = 0.02
    }
    
    // Method to set the focal point
    func setFocalPoint(x: CGFloat, y: CGFloat) {
        self.focalPoint = CGPoint(x: x, y: y)
    }
    
    // Method to get and update the distance using LiDAR sensor
    func getDistance() -> Double {
        var distance = 0.0
        
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            if let sceneDepth = ARFrame.worldDepth {
                if let newDistance = sceneDepth.distance(from: self.focalPoint, to: .camera) {
                    distance = newDistance
                    notify(distance)
                }
            }
        } else {
            print("LiDAR functionality not supported on this device.")
        }
        
        return distance
    }
    
    // Method to notify observers with the distance
    func notify(_ distance: Double) {
        for observer in observers {
            observer(distance)
        }
    }
    
    // Method to add observer lambda
    func onMeasure(_ observer: @escaping (Double) -> Void) {
        observers.append(observer)
    }
}
