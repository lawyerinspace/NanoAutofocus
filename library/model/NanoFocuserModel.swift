import UIKit
import CoreMotion
import CoreLocation

// Model
struct DistanceData {
    var distance: Double
}

protocol NanoFocuserModelDelegate: AnyObject {
    func distanceDidChange(newDistance: Double)
}

class NanoFocuserModel {
    var currentDistance: DistanceData
    var locationManager: CLLocationManager
    weak var delegate: NanoFocuserModelDelegate?

    init() {
        currentDistance = DistanceData(distance: 0.0)
        locationManager = CLLocationManager()
        setUpLocationManager()
    }

    deinit {
        locationManager.stopUpdatingHeading()
    }

    // Method to set up Core Location Manager and start LiDAR updates
    private func setUpLocationManager() {
        guard CLLocationManager.isRangingAvailable() else {
            print("LiDAR sensor not available on this device")
            return
        }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
        locationManager.delegate = self
    }

    // Method to calculate distance using LiDAR sensor
    private func calculateDistanceFromLiDAR(at point: CGPoint) -> Double {
        let pointCoordinates = CLLocation(latitude: CLLocationDegrees(point.y), longitude: CLLocationDegrees(point.x))
        let distance = locationManager.rangedLiDARDistances.filter { $0.azimuth == 0.0 }.first?.distance ?? -1.0 // Assuming azimuth 0 for demonstration
        return distance
    }
    

    // Method to update the current distance and notify the controller
    private func updateDistance(_ newDistance: Double) {
        currentDistance.distance = newDistance
        delegate?.distanceDidChange(newDistance)
    }
}

// Extension to NanoFocuserModel to conform to CLLocationManagerDelegate for LiDAR updates
extension NanoFocuserModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let distance = calculateDistanceFromLiDAR(at: CGPoint(x: 0, y: 0)) // Assuming the focus point at the center for demonstration
        updateDistance(distance)
    }
}
