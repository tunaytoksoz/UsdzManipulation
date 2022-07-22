//
//  ARSCNViewController.swift
//  ARUsdzFile
//
//  Created by Tunay Toksöz on 27.06.2022.
//

import Foundation
import UIKit
import SceneKit
import ARKit
import SceneKit.ModelIO
import QuickLook


class ARSCNViewController: UIViewController, ARSCNViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate /*, QLPreviewControllerDelegate, QLPreviewControllerDataSource*/{

    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var usdzPath :URL = Bundle.main.url(forResource: "AirForce", withExtension: "usdz")!
    var tappedNodeName = ""
    var image = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(usdzPath.lastPathComponent)
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedNode(gestureRecognizer:)))
        
        sceneView.addGestureRecognizer(gestureRecognizer)
        
        
        let scene = SCNScene()

        let refNode = SCNReferenceNode(url: usdzPath)
        
        refNode?.position = SCNVector3(0, -0.1, -0.25)
        refNode?.load()
        refNode?.scale = SCNVector3(0.01, 0.01, 0.01)
        scene.rootNode.addChildNode(refNode!)
        
         
        if tappedNodeName != "" {
            refNode?.childNode(withName: tappedNodeName , recursively: true)?.geometry?.firstMaterial?.diffuse.contents = image
        }
        
        sceneView.scene = scene
        
        sceneView.delegate = self
        
        sceneView.autoenablesDefaultLighting = true
        
        sceneView.allowsCameraControl = true
        
        
  
     /*   let previewController = QLPreviewController()
        // 2
        previewController.dataSource = self
        previewController.delegate = self
        // 3
        present(previewController, animated: false)
    */
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()

        sceneView.session.run(configuration)
    
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
       sceneView.session.pause()
    }
    
    
    
   /* func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url = usdzPath
        
        return url as QLPreviewItem
    }*/
    
    @objc func tappedNode(gestureRecognizer: UITapGestureRecognizer){
        
        var location = gestureRecognizer.location(in: sceneView)
            print(location)
        
        let hits = self.sceneView.hitTest(location, options: nil)
            if let tappedNode = hits.first?.node {
            print(tappedNode.name)
                tappedNodeName = String(tappedNode.name!)
                print(tappedNodeName)
               
                let picker = UIImagePickerController()
                        
                picker.allowsEditing = true
                picker.delegate = self
                        
                present(picker, animated: true)
        }
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {return}
                
                image = selectedImage
                dismiss(animated: true)
        viewDidLoad()
    }
    
}
