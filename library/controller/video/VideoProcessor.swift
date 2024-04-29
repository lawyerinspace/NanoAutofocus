import UIKit

class VideoProcessor {
    var results: [CGRect] = []
    var observers: [(results: [CGRect]) -> Void] = []

    func process(image: UIImage) {
        // This method needs to be implemented by subclasses
        fatalError("Subclass must implement this method")
    }

    func onProcess(observer: @escaping ([CGRect]) -> Void) {
        observers.append(observer)
    }

    func notify() {
        for observer in observers {
            observer(results)
        }
    }
}
