import Foundation

var greeting = "Hello, playground"

let exampleXArea: ClosedRange<CGFloat> = 20...30
let exampleYArea: ClosedRange<CGFloat> = ClosedRange(uncheckedBounds: (lower: -10, upper: -5))

struct Probe {
    var position: CGPoint = .zero
    var velocity: CGVector
}

struct TargetArea {
    let xArea: ClosedRange<CGFloat>
    let yArea: ClosedRange<CGFloat>
}

enum Launcher {
    enum ProbeTrajectory {
        case approachingTargetArea
        case insideTargetArea
        case overshotTargetArea
    }
    
    static func trajectoryOf(probe: Probe, towards targetArea: TargetArea) -> ProbeTrajectory {
        if probe.position.y < targetArea.yArea.lowerBound {
            // Probe is lower than the target area
            return .overshotTargetArea
        } else if probe.position.x > targetArea.xArea.upperBound && probe.velocity.dx >= 0 {
            // Probe is further right than the target area and travelling right or stopped
            return .overshotTargetArea
        } else if probe.position.x < targetArea.xArea.lowerBound && probe.velocity.dx <= 0 {
            // Probe is further left than the target area and travelling left or stopped
            return .overshotTargetArea
        } else if targetArea.xArea ~= probe.position.x && targetArea.yArea ~= probe.position.y {
            return .insideTargetArea
        } else {
            return .approachingTargetArea
        }
    }
    
    /**
     - returns: If the probe was inside the `TargetArea` after some amount of steps
     */
    static func launchProbeWith(velocity: CGVector, towards targetArea: TargetArea) -> Bool {
        var probe = Probe(velocity: velocity)
        
        var latestTrajectory = trajectoryOf(probe: probe, towards: targetArea)
        
        while latestTrajectory == .approachingTargetArea {
            probe.position.x += probe.velocity.dx
            probe.position.y += probe.velocity.dy
            
            if probe.velocity.dx > 0 {
                probe.velocity.dx -= 1
            } else if probe.velocity.dx < 0 {
                probe.velocity.dx += 1
            }
            
            probe.velocity.dy -= 1
            
            latestTrajectory = trajectoryOf(probe: probe, towards: targetArea)
        }
        
        return latestTrajectory == .insideTargetArea
    }
}

let exampleTargetArea = TargetArea(xArea: exampleXArea, yArea: exampleYArea)

Launcher.launchProbeWith(velocity: CGVector(dx: 7, dy: 2), towards: exampleTargetArea) // true (correct)
Launcher.launchProbeWith(velocity: CGVector(dx: 6, dy: 3), towards: exampleTargetArea) // true (correct)
Launcher.launchProbeWith(velocity: CGVector(dx: 9, dy: 0), towards: exampleTargetArea) // true (correct)
Launcher.launchProbeWith(velocity: CGVector(dx: 17, dy: -4), towards: exampleTargetArea) // false (correct)


