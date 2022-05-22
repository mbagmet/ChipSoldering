import Foundation

public class GenerationThread: Thread {
    private var timer: Timer?
    private var counter = 0    
    private var storage = Storage()
    
    public init(storage: Storage) {
        self.storage = storage
    }
    
    public override func main() {
        timer = Timer.scheduledTimer(timeInterval: 2,
                                         target: self,
                                         selector: #selector(startGeneration),
                                         userInfo: nil,
                                         repeats: true)
        
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .common)
            RunLoop.current.run(until: .now + 20)
        }
    }
    
    /// Создаем чип и добавляем его в хранилище
    @objc func startGeneration() {
        let chip = Chip.make()
        storage.appendStorage(chip: chip) {
            self.printReport(chip: chip)
            self.signal()
        }
    }
    
    /// Даем сигнал WorkingThread, что чипов на скалде уже больше одного
    private func signal() {
        if self.storage.chipsInStorageQuantity > 0 {
            condition.signal()
        }
    }
}

// MARK: - Вывод отчетов
extension GenerationThread {
    private func printReport(chip: Chip) {
        counter += 1
        print("#\(counter) - генерация")
        print("Добавлен на склад чип типа \"\(chip.chipType)\"")
        print("Количество чипов на складе — \(self.storage.chipsInStorageQuantity)")
        print("\n")
    }
}
