// AlertMessage.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Сообщение-алерт для системных уведомлений
struct AlertMessage {
    /// Заголовок
    let title: String
    /// Описание
    let description: String?
    /// Текст кнопки закрыть
    let dismissButtonText: String

    init(title: String, description: String? = nil, dismissButtonText: String = "Ok") {
        self.title = title
        self.description = description
        self.dismissButtonText = dismissButtonText
    }
}
