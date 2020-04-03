//
//  String.swift
//  TestShareRH
//
//  Created by Victor B D Almeida on 02/04/20.
//  Copyright © 2020 Victor B D Almeida. All rights reserved.
//

import Foundation

extension String {

    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
