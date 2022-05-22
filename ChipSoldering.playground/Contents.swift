import Foundation

// MARK: - Склад чипов
let storage = Storage()

// MARK: - Очередь генерации чипов
let generationThread = GenerationThread(storage: storage)
generationThread.start()

// MARK: - Рабочая очередь, которая запускает пайку
let workingThread = WorkingThread(storage: storage)
workingThread.start()
