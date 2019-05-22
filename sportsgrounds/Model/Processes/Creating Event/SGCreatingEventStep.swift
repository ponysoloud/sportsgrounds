//
//  SGCreatingEventStep.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 17/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

enum SGCreatingEventStep: CaseIterable {
    case general
    case activityDetails
    case participantsDetails
    case dateDetails
    
    
    var title: String {
        return "Создание события"
    }
    
    var subtitle: String {
        switch self {
        case .general:
            return "Начните планировать событие с указания его названия и описания"
        case .activityDetails:
            return "Укажите вид спорта, тип проводимого события и максимальное количество участников"
        case .participantsDetails:
            return "Установите уровень умений участников и допустимый возраст, чтобы обезопасить занятия"
        case .dateDetails:
            return "И финальный штрих! Введите дату и время"
        }
    }
}
