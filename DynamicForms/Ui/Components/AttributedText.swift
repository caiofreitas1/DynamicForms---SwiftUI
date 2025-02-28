//
//  AttributedText.swift
//  DynamicForms
//
//  Created by Caio Cesar Franco Fausto de Freitas on 27/02/25.
//

import Foundation
import SwiftUI

struct AttributedText: View {
    let html: String
    
    var body: some View {
        Text(attributedString)
    }
    
    private var attributedString: AttributedString {
        do {
            if let data = html.data(using: .utf8) {
                let attributedString = try NSAttributedString(
                    data: data,
                    options: [.documentType: NSAttributedString.DocumentType.html],
                    documentAttributes: nil
                )
                return AttributedString(attributedString)
            }
        } catch {
            print("Error converting HTML to AttributedString: \(error)")
        }
        return AttributedString(html)
    }
}
