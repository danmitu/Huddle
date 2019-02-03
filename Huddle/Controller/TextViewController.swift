//
//  TextViewController.swift
//  Huddle
//
//  Created by Dan Mitu on 1/31/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = textView
        textView.delegate = self
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        whenDoneEditing?(textView.text ?? "")
    }
    
    // MARK: - Properties
    
    var whenDoneEditing: ((String)->())?
    
    // MARK: View
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        return textView
    }()
    
    // MARK: - Methods
    
    func setInitialText(_ text: String) {
        self.textView.text = text
    }

}
