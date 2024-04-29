import UIKit
import Vision

class FaceProcessor: VideoProcessor {
    override func process(image: UIImage) {
        guard let ciImage = CIImage(image: image) else { return }

        let faceDetectionRequest = VNDetectFaceRectanglesRequest { request, error in
            guard let results = request.results as? [VNFaceObservation] else { return }
            
            let faceIDResults = results.enumerated().map { (index, faceObservation) in
                return (faceObservation.boundingBox, "Face \(index+1)")
            }
            
            self.results = faceIDResults
            self.notify()
        }

        let faceDetectionRequestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: CGImagePropertyOrientation.up, options: [:])

        do {
            try faceDetectionRequestHandler.perform([faceDetectionRequest])
        } catch {
            print("Error performing face detection: \(error.localizedDescription)")
        }
    }
}
