//
//  ViewController.swift
//  Step1ARKit
//
//  Created by Mariano on 30/09/2019.
//  Copyright © 2019 Mariano Gelsomino. All rights reserved.


import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate
{


    @IBOutlet weak var sceneView: ARSCNView!
    
    /* --SCNScene-- is A container for the node hierarchy and global properties that together form a displayable 3D scene.
            https://developer.apple.com/documentation/scenekit/scnscene
    */
    
    //MARK: ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // .delegate è un oggetto fornito per mediare la sincronizzazione delle informazioni sulla scena AR della vista con il contenuto di SceneKit.
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        let circleNode = createSphereNode(with: 0.2, color: .blue)//creazione sfera
        circleNode.position = SCNVector3(0,0,-1)//posizionamento oggetto ad un metro di distanza
        sceneView.scene.rootNode.addChildNode(circleNode)//aggiunta della sfera creata (circleNode) alla scena, ricordando che la scena è composta da un insieme di nodi
    }

    /* MARK:viewWillAppear
    questo metodo Notifica al controller di visualizzazione che la sua vista sta per essere aggiunta a una gerarchia di viste.*/
    override func viewWillAppear(_ animated: Bool)
    {
        //CREAZIONE SESSIONE DI SCANSIONE AR
        
        // ARCoachingOverlayView è Una vista che presenta istruzioni visive che guidano l'utente durante l'inizializzazione della sessione e in situazioni di tracciamento limitat
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.session = sceneView.session
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        coachingOverlay.activatesAutomatically = true
        coachingOverlay.goal = .horizontalPlane //in questo caso sto richiedendo che venga identificato un piano orizzontale per l'utilizzo dell'AR
        sceneView.addSubview(coachingOverlay)//visualizza nella scena l'ARCoachingOverlayView creato
        //Vincoli di Layout
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        //CREAZIONE DELLA SCANSIONE DEL MONDO IN AR
        
        /* ARWorldTrackingConfiguration is A configuration that monitors the iOS device's position and orientation while enabling you to augment the environment that's in front of the user.
         https://developer.apple.com/documentation/arkit/arworldtrackingconfiguration
        */
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]//tra parentesi quadre potrei passare come posizioni un array di valori
        sceneView.session.run(configuration)
    }

    //MARK: viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    //MARK: -CREAZIONE DELLA SFERA
    //ritorna un oggetto SCNNode (una sfera) che verra posizionato nella sceneView (scena) in AR
    
    //with è un identificatore di parametro esterno. praticamente abbiamo una funzione già definita che usa un parametro esterno creando un sovraccarico
    //SCNNode https://developer.apple.com/documentation/scenekit/scnnode
    func createSphereNode(with radius: CGFloat,color: UIColor) -> SCNNode
    {
        let geometry = SCNSphere(radius: radius)
        geometry.firstMaterial?.diffuse.contents = color
        let sphereNode = SCNNode(geometry: geometry)
        return sphereNode
    }
    
}

