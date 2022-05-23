import Foundation

public let condition = NSCondition()

public class WorkingThread: Thread {
    private var counter = 0
    private var storage = Storage()
    
    public init(storage: Storage) {
        self.storage = storage
    }
    
    public override func main() {

        if storage.isWaitingForNewChips {
            condition.lock()
            
            // Ждем, пока на складе появится хотя бы один чип
            while storage.chipsInStorageQuantity <= 0 {
                condition.wait()
            }
                
            while storage.chipsInStorageQuantity > 0 {
                var chipForsoldering: Chip?
                
                // Берем чип со склада
                storage.getFromStorage() { chip in
                    chipForsoldering = chip
                    self.stageNumberCount()
                    self.printReport(chip: chip, type: .getFromStorage)
                }
                
                // Распаиваем чип
                if let chip = chipForsoldering {
                    chip.sodering()
                    printReport(chip: chip, type: .soldering)
                }
            }
                
            condition.unlock()
            
            // Дожидаемся новой партии чипов
            main()
        } else {
            printResultsReport()
        }
        
    }
}

// MARK: - Вывод отчетов
extension WorkingThread {
    private func stageNumberCount() {
        counter += 1
    }
    
    private func printReport(chip: Chip?, type: OperationType) {
        if let chip = chip {
            print("#\(counter) - \(type.rawValue)")
            
            switch type {
            case .getFromStorage:
                print("Чип \"\(chip.chipType)\" взяли со склада.")
            case .soldering:
                print("Чип \"\(chip.chipType)\" распаян.")
            }
            
            print("Количество чипов на складе — \(self.storage.chipsInStorageQuantity)")
            print("\n")
        }
    }
    
    private enum OperationType: String {
        case getFromStorage = "выдача со склада"
        case soldering = "пайка"
    }
    
    private func printResultsReport() {
        print("Работа закончена. Распаяно за смену — \(counter) чипов.")
        print("\n")
    }
}
