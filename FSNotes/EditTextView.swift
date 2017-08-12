//
//  EditTextView.swift
//  FSNotes
//
//  Created by Oleksandr Glushchenko on 8/11/17.
//  Copyright © 2017 Oleksandr Glushchenko. All rights reserved.
//

import Cocoa

class EditTextView: NSTextView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
        
    func fill(note: Note) {
        let attributedString = createAttributedString(note: note)
        self.textStorage?.setAttributedString(attributedString)
        self.textStorage?.font = NSFont(name: UserDefaultsManagement.fontName, size: 13.0)
    }
    
    func save(note: Note) -> Bool {
        let fileUrl = note.url!
        let fileExtension = fileUrl.pathExtension
        
        do {
            let documentAttributes = DocumentAttributes.getDocumentAttributes(fileExtension: fileExtension)
            let range = NSRange(0..<textStorage!.length)
            let text = try textStorage?.fileWrapper(from: range, documentAttributes: documentAttributes)
            
            try text?.write(to: fileUrl, options: FileWrapper.WritingOptions.atomic, originalContentsURL: nil)
            
            return true
        } catch {
            NSLog("Note write error: " + fileUrl.path)
        }
        
        return false
    }
    
    func createAttributedString(note: Note) -> NSAttributedString {
        let url = note.url!
        let fileExtension = url.pathExtension
        let options = DocumentAttributes.getDocumentAttributes(fileExtension: fileExtension)
        var attributedString = NSAttributedString()
        
        do {
            attributedString = try NSAttributedString(url: url, options: options, documentAttributes: nil)
        } catch {
            NSLog("No text content found!")
        }
        
        return attributedString
    }
}