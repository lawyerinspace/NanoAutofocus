import AVFoundation

class VideoCapture: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var captureObservers: [(UIImage) -> Void] = []

    override init() {
        super.init()

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            fatalError("Unable to access the rear camera.")
        }

        do {
            let input = try AVCaptureDeviceInput(device: camera)

            let session = AVCaptureSession()
            session.sessionPreset = .photo

            if session.canAddInput(input) {
                session.addInput(input)
            }

            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            if session.canAddOutput(output) {
                session.addOutput(output)
            }

            session.startRunning()
        } catch {
            fatalError("Error setting up camera input: \(error.localizedDescription)")
        }
    }

    func onCapture(observer: @escaping (VideoCapture, UIImage) -> Void) {
        captureObservers.append(observer)
    }

    func notify(image: UIImage) {
        for observer in captureObservers {
            observer(image)
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let ciContext = CIContext()
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        
        if let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            notify(image: uiImage)
        }
    }
}
