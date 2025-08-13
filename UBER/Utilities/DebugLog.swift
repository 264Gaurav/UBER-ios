import Foundation


func Log(_ message: String) {
    #if DEBUG
    print(message)
    #endif
}
