//
//  SocketsProvider.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 22/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import SocketIO

protocol SocketsProvider {
    
    init(environment: SocketsEnvironment)
    
    func connect(toSocket socket: Socket,
                 withHandler handler: @escaping (Socket) -> Void)
    
    func disconnect(fromSocket socket: Socket,
                    withHandler handler: @escaping (Socket) -> Void)
    
    func listen(socket: Socket,
                forEvent event: SocketForeignEvent,
                withHandler handler: @escaping ([String: Any]) -> Void)
    
    func send(event: SocketEvent,
              withSocket socket: Socket,
              withCompletion handler: @escaping () -> Void)
}
