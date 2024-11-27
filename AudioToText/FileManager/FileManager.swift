//
//  FileManager.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 06/10/24.
//

import FileProvider

init?(itemIdentifier: NSFileProviderItemIdentifier) {
  guard itemIdentifier != .rootContainer else {
    self.init(urlRepresentation: URL(string: "itemReference:///")!)
    return
  }
  
  guard
    let data = Data(base64Encoded: itemIdentifier.rawValue),
    let url = URL(dataRepresentation: data, relativeTo: nil)
    else {
      return nil
  }
  
  self.init(urlRepresentation: url)
}

