//
//  TransitionProtocol.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/29/24.
//

import UIKit

protocol TransitionProtocol {
    
    var presentables: [Presentable] { get }
    
    func perform(on rootViewController: UIViewController, completion: PresentationHandler?)
}
