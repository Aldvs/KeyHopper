//
//  InitialViewController.swift
//  KeyHopper
//
//  Created by admin on 20.10.2023.
//

import SwiftUI

class InitialViewController: UIHostingController<InitialView> {

    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: InitialView());
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
