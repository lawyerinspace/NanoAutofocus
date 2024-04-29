import UIKit

class NanoFocuserController {
    private let model: LiDARModel
    private let view: NanoFocuserView
    private let videoCapture: VideoCapture
    private let faceProcessor: FaceProcessor
    private var objects: [(rectangle: CGRect, id: String)] = []
    private var trackedObjectIndex: Int?
    
    init(model: LiDARModel, view: NanoFocuserView) {
        self.model = model
        self.view = view
        self.videoCapture = VideoCapture()
        self.faceProcessor = FaceProcessor()
        
        bindModel()
        bindView()
        bindVideoCapture()
        bindFaceProcessor()
    }
    
    private func bindModel() {
        model.onMeasure { [weak self] distance in
            self?.view.displayDistance(distance)
        }
    }
    
    private func bindView() {
        view.onTap { [weak self] tapLocation in
            self?.handleTapGesture(at: tapLocation)
        }
    }
    
    private func bindVideoCapture() {
        videoCapture.onCapture { [weak self] (videoCapture, capturedImage) in
            self.faceProcessor.process(image: capturedImage)
        }
    }
    
    private func bindFaceProcessor() {
        faceProcessor.onProcess { [weak self] processedResults in
            var updatedObjects: [(rectangle: CGRect, id: String, selected: Bool)] = []
            for (index, (rectangle, id)) in processedResults.enumerated() {
                let selected = index == self.trackedObjectIndex
                updatedObjects.append((rectangle, id, selected))
            }
            
            self.objects = processedResults
            self.view.updateObjects(updatedObjects)
        }
    }
    
    private func handleTapGesture(at tapLocation: CGPoint) {
        if let trackedIndex = trackedObjectIndex {
            if let tappedIndex = objects.firstIndex(where: { $0.rectangle.contains(tapLocation) }) {
                if tappedIndex != trackedIndex {
                    trackedObjectIndex = tappedIndex
                } else {
                    trackedObjectIndex = nil
                }
            } else {
                trackedObjectIndex = nil
            }
        } else {
            trackedObjectIndex = objects.firstIndex(where: { $0.rectangle.contains(tapLocation) })
        }
        updateViewWithTrackedObject()
    }
    
    private func updateViewWithTrackedObject() {
        var updatedObjects: [(rectangle: CGRect, id: String, selected: Bool)] = []
        for (index, object) in objects.enumerated() {
            let selected = index == trackedObjectIndex
            updatedObjects.append((object.rectangle, object.id, selected))
        }
        view.updateObjects(updatedObjects)
    }
}
