import Foundation

var greeting = "Hello, playground"

struct Volume {
    let x: (min: Int, max: Int)
    let y: (min: Int, max: Int)
    let z: (min: Int, max: Int)
    
    var adding = [Volume]()
    // Maybe this should be only the intersections.
    // Then we could keep track of what has already been subtracted, and ignore a newly subtracted Volume if it fits entirely in an already subtracted Volume?
    
    var subtracting = [Volume]()
    
    var volume: Int {
        // For each adding volume, find the
        
        let diffX = x.max - x.min
        let diffY = y.max - y.min
        let diffZ = z.max - z.min
        
        return diffX * diffY * diffZ
    }
    
    @discardableResult
    mutating func add(_ otherVolume: Volume) -> Volume {
        adding += [otherVolume]
        return self
    }
    
    // I want to return a new volume object from this function in order to make the functions chainable.
    // But at the moment only the total volume could chain because each volume only has a concept of it's own extremities.
    // I don't know if it will work with multiple volumes.
    // I might need to chain the volumes in an array so that each is only responsible for 1 other volume being added / removed.
    // But each volume object still needs to know it's exact 3D volume to allow it to calculate accurately...
    @discardableResult
    mutating func subtract(_ otherVolume: Volume) -> Volume {
        subtracting += [otherVolume]
        return self
    }
}

extension Volume: CustomStringConvertible {
    var description: String {
        "\(volume)"
    }
}

let test = Volume(x: (10,20), y: (10,20), z: (10,20))
