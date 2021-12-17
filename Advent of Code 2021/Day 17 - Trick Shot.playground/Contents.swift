import Foundation

var greeting = "Hello, playground"

let exampleXArea: ClosedRange<CGFloat> = 20...30
let exampleYArea: ClosedRange<CGFloat> = ClosedRange(uncheckedBounds: (lower: -10, upper: -5))

struct Probe {
    var position: CGPoint = .zero
    var velocity: CGVector
}

extension Probe {
    mutating func step() {
        position.x += velocity.dx
        position.y += velocity.dy
        
        if velocity.dx > 0 {
            velocity.dx -= 1
        } else if velocity.dx < 0 {
            velocity.dx += 1
        }
        
        velocity.dy -= 1
    }
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
        case underneathTargetArea
        case stoppedBeforeTargetArea
    }
    
    static func trajectoryOf(probe: Probe, towards targetArea: TargetArea) -> ProbeTrajectory {
        if probe.position.y < targetArea.yArea.lowerBound {
            // Probe is lower than the target area
            return .underneathTargetArea
        } else if probe.position.x > targetArea.xArea.upperBound && probe.velocity.dx >= 0 {
            // Probe is further right than the target area and travelling right or stopped
            return .overshotTargetArea
        } else if probe.position.x < targetArea.xArea.lowerBound && probe.velocity.dx <= 0 {
            // Probe is further left than the target area and travelling left or stopped
            return .stoppedBeforeTargetArea
        } else if targetArea.xArea ~= probe.position.x && targetArea.yArea ~= probe.position.y {
            // Probe is inside target area
            return .insideTargetArea
        } else {
            return .approachingTargetArea
        }
    }
    
    /**
     - returns: The number of steps required to reach the `targetArea`, or nil if it never reaches it.
     */
    static func launchProbeWith(velocity: CGVector, towards targetArea: TargetArea) -> Int? {
        var probe = Probe(velocity: velocity)
        
        var numberOfSteps = 0
        
        var latestTrajectory = trajectoryOf(probe: probe, towards: targetArea)
        
        while latestTrajectory == .approachingTargetArea {
            probe.step()
            numberOfSteps += 1
            
            latestTrajectory = trajectoryOf(probe: probe, towards: targetArea)
        }
        
        return latestTrajectory == .insideTargetArea ? numberOfSteps : nil
    }
    
    static func minimumXVelocityTo(reach: CGFloat) -> CGFloat {
        var reach = reach
        var steps: CGFloat = 0
        
        while reach > 0 {
            steps += 1
            reach -= steps
        }
        
        return steps
    }
    
    /**
     Target area is always to the right and down in examples and puzzle
     */
    static func highestProbeTo(reach targetArea: TargetArea) -> (highestY: CGFloat, winningVelocity: CGVector) {
        var highestY: CGFloat = 0
        
        let minX = minimumXVelocityTo(reach: targetArea.xArea.lowerBound)
        /// We can never launch a probe with a higher X velocity than this, otherwise we will overshoot on the first shot.
        let maxX = targetArea.xArea.upperBound
        
        // Assume only minX for now
//        for x in Int(minX)...Int(maxX) {
            // Start with y = 0
        
        var initialYVelocity: CGFloat = 0
        
        whileTrueLoop:
        while true {
            var localHighestY: CGFloat = 0
            var probe = Probe(velocity: CGVector(dx: minX, dy: initialYVelocity))
            
            var latestTrajectory = trajectoryOf(probe: probe, towards: targetArea)
            
            while latestTrajectory == .approachingTargetArea {
                probe.step()
                
                if probe.position.y > localHighestY {
                    localHighestY = probe.position.y
                }
                
                latestTrajectory = trajectoryOf(probe: probe, towards: targetArea)
            }
            
            if latestTrajectory == .insideTargetArea {
                if localHighestY > highestY {
                    highestY = localHighestY
                }
                
                initialYVelocity += 1
                probe = Probe(velocity: CGVector(dx: minX, dy: initialYVelocity))
            } else {
                break whileTrueLoop
            }
        }
            
//        }
         
        return (highestY, CGVector(dx: minX, dy: initialYVelocity - 1)) // Has to be initialYVelocity - 1 because we incremented the initialYVelocity before the failing probe
    }
}

let exampleTargetArea = TargetArea(xArea: exampleXArea, yArea: exampleYArea)

Launcher.launchProbeWith(velocity: CGVector(dx: 7, dy: 2), towards: exampleTargetArea) // true (correct)
Launcher.launchProbeWith(velocity: CGVector(dx: 6, dy: 3), towards: exampleTargetArea) // true (correct)
Launcher.launchProbeWith(velocity: CGVector(dx: 9, dy: 0), towards: exampleTargetArea) // true (correct)
Launcher.launchProbeWith(velocity: CGVector(dx: 17, dy: -4), towards: exampleTargetArea) // false (correct)

Launcher.minimumXVelocityTo(reach: exampleTargetArea.xArea.lowerBound)

Launcher.launchProbeWith(velocity: CGVector(dx: 6, dy: 9), towards: exampleTargetArea)

Launcher.highestProbeTo(reach: exampleTargetArea)

let puzzleTargetArea = TargetArea(xArea: 206...250, yArea: ClosedRange(uncheckedBounds: (lower: -105, upper: -57)))

//Launcher.highestProbeTo(reach: puzzleTargetArea)
