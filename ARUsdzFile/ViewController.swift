//
//  ViewController.swift
//  ARUsdzFile
//
//  Created by Tunay Toksöz on 27.06.2022.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ViewController: UIViewController, UIDocumentPickerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var label: UILabel!
    
    var path = [URL]()
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func selectPickerButton(_ sender: Any) {
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.usdz])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
       path = urls as [URL]
        let sec_path = path[0].startAccessingSecurityScopedResource()
        
        
        performSegue(withIdentifier: "toARSCNView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toARSCNView" {
            let destinationVC = segue.destination as! ARSCNViewController
            destinationVC.usdzPath = path[0]
        }
    }
    
    
    
}
