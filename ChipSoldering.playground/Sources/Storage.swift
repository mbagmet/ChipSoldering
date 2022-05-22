import Foundation

public class Storage {
    private var chipStorage = [Chip]()
    private let queue = DispatchQueue(label: "Storage Queue", qos: .utility, attributes: .concurrent)
    
    public var chipsInStorageQuantity: Int {
        return chipStorage.count
    }
    
    public init() {}
    
    /// Добавляем чип в хранилище
    func appendStorage(chip: Chip, completion: @escaping () -> ()) {
        queue.async(flags: .barrier) {
            self.chipStorage.append(chip)
            completion()
        }
    }
    
    /// Берем чип из хранилища
    func getFromStorage(completion: @escaping (_ lastChip: Chip) -> ()) {
        queue.sync {
            if let lastChip = self.chipStorage.popLast() {
                completion(lastChip)
            }
        }
    }
}
