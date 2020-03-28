//
//  ViewController.swift
//  imageRecognization
//
//  Created by Sambit Das on 26/03/20.
//  Copyright © 2020 Sambit Das. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Social

class ViewController: UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate	{
    @IBOutlet weak var imageView: UIImageView!
    var classificationResults : [VNClassificationObservation] = []
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
         imagePicker.delegate = self
    }
    
    func detect(image: CIImage) {
           
           
           guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
               fatalError("can't load ML model")
           }
           
           let request = VNCoreMLRequest(model: model) { request, error in
               guard let results = request.results as? [VNClassificationObservation],
                   let topResult = results.first
                   else {
                       fatalError("unexpected result type from VNCoreMLRequest")
               }
            
            
            let name = topResult.identifier
           // print(name)
            DispatchQueue.main.async {
                        self.navigationItem.title = name
                        self.navigationController?.navigationBar.barTintColor = UIColor.systemPink
                        self.navigationController?.navigationBar.isTranslucent = false
            }
            
           }
           
           let handler = VNImageRequestHandler(ciImage: image)
           
           do {
               try handler.perform([request])
           }
           catch {
               print(error)
           }
       }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           if let image = info[.originalImage] as? UIImage {
               
               imageView.image = image
               imagePicker.dismiss(animated: true, completion: nil)
               guard let ciImage = CIImage(image: image) else {
                   fatalError("couldn't convert uiimage to CIImage")
               }
               detect(image: ciImage)
           }
       }

    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
}

