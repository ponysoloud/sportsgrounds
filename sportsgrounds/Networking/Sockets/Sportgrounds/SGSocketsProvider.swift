//
//  SGSocketsProvider.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 22/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import SocketIO

class SGSocketsProvider: SocketsProvider {
    
    let manager: SocketManager
    
    required init(environment: SocketsEnvironment) {
        self.manager = SocketManager(socketURL: environment.host, config: environment.parameters)
    }
    
    func connect(toSocket socket: Socket, withHandler handler: @escaping (Socket) -> Void) {
        self.manager.socket(forNamespace: socket.namespace).off(clientEvent: .connect)
        self.manager.socket(forNamespace: socket.namespace).on(clientEvent: .connect) {
            (data, ack) in
            handler(socket)
        }
        
        self.manager.socket(forNamespace: socket.namespace).connect()
    }
    
    func disconnect(fromSocket socket: Socket, withHandler handler: @escaping (Socket) -> Void) {
        self.manager.socket(forNamespace: socket.namespace).off(clientEvent: .disconnect)
        self.manager.socket(forNamespace: socket.namespace).on(clientEvent: .disconnect) {
            (data, ack) in
            handler(socket)
        }
        
        self.manager.socket(forNamespace: socket.namespace).disconnect()
    }
    
    func listen(socket: Socket, forEvent event: SocketForeignEvent, withHandler handler: @escaping ([String: Any]) -> Void) {
        self.client(forSocket: socket).off(event.name)
        self.client(forSocket: socket).on(event.name) { (data, ark) in
            if let response = data.first as? [String: Any] {
                handler(response)
            } else {
                handler([:])
            }
        }
    }
    
    func send(event: SocketEvent, withSocket socket: Socket, withCompletion handler: @escaping () -> Void) {
        self.client(forSocket: socket).emit(event.name, event.dictionary, completion: handler)
    }
    
    private func client(forSocket socket: Socket) -> SocketIOClient {
        return self.manager.socket(forNamespace: socket.namespace)
    }
}
