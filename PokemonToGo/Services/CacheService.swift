import Foundation
import UIKit

final class CacheService {
    static let shared = CacheService()
    private let cache = NSCache<NSString, AnyObject>()
    
    private init() {}
    
    func setObject(_ object: AnyObject, forKey key: String) {
        cache.setObject(object, forKey: NSString(string: key))
    }
    
    func object(forKey key: String) -> AnyObject? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func removeObject(forKey key: String) {
        cache.removeObject(forKey: NSString(string: key))
    }
}
