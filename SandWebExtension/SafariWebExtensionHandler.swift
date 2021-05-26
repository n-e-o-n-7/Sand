//
//  SafariWebExtensionHandler.swift
//  SandWebExtension
//
//  Created by 许滨麟 on 2021/5/23.
//

import os.log
import SafariServices

let SFExtensionMessageKey = "message"

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey]
        os_log(.default, "Received message from browser.runtime.sendNativeMessage: %@", message as! CVarArg)

        var result: String?
        if let content = message as? String, let word = Stardict.query(word: content), let data = try? JSONEncoder().encode(word) {
            result = String(data: data, encoding: .utf8)
        }

        let response = NSExtensionItem()
        response.userInfo = [SFExtensionMessageKey: result ?? ""]
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
}

// func NativeAPPToHandler(){
//    NSUserDefaults - App groups
//    NSXPCConnection
// }
