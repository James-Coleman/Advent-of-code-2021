import Foundation

var greeting = "Hello, playground"

let exampleXArea: ClosedRange<CGFloat> = 20...30
let exampleYArea: ClosedRange<CGFloat> = ClosedRange(uncheckedBounds: (lower: -10, upper: -5))

struct Probe {
    var position: CGPoint = .zero
    var velocity: CGVector
}

enum ProbeStepper {
    static func step(_ probe: Probe) -> Probe {
        var copy = probe
        
        copy.position.x += copy.velocity.dx
        copy.position.y += copy.velocity.dy
        
        if copy.velocity.dx > 0 {
            copy.velocity.dx -= 1
        } else if copy.velocity.dx < 0 {
            copy.velocity.dx += 1
        }
        
        copy.velocity.dy -= 1
        
        return copy
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
            probe = ProbeStepper.step(probe)
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
        var bestVector = CGVector(dx: 0, dy: 0)
        
        let minX = minimumXVelocityTo(reach: targetArea.xArea.lowerBound)
        /// We can never launch a probe with a higher X velocity than this, otherwise we will overshoot on the first shot.
        let maxX = targetArea.xArea.upperBound
        
        for x in Int(minX)...Int(maxX) {
            print("Starting x \(x)")
            
            let cgFloatX = CGFloat(x)
            var initialYVelocity: CGFloat = 0
            
            var haveStartedToReachTargetArea = false
            
            whileTrueLoop:
            while true {
                var localHighestY: CGFloat = 0
                let velocity = CGVector(dx: cgFloatX, dy: initialYVelocity)
                var probe = Probe(velocity: velocity)
                
                guard launchProbeWith(velocity: velocity, towards: targetArea) != nil else {
                    print("Won't reach target area with velocity \(velocity)")
                    
                    // Currently a bug where it never checks the next x (whileTrueLoop is never broken)
                    // I think we need to involve haveStartedToReachTargetArea again
                    initialYVelocity += 1
                    probe = Probe(velocity: CGVector(dx: cgFloatX, dy: initialYVelocity))
                    continue
                }
                
                var latestTrajectory = trajectoryOf(probe: probe, towards: targetArea)
                
                while latestTrajectory == .approachingTargetArea {
                    probe = ProbeStepper.step(probe)
                    
                    if probe.position.y > localHighestY {
                        localHighestY = probe.position.y
                    }
                    
                    latestTrajectory = trajectoryOf(probe: probe, towards: targetArea)
                }
                
                if latestTrajectory == .insideTargetArea {
                    if haveStartedToReachTargetArea == false {
                        print("Reached the target area for the first time with velocity: \(velocity)")
                        haveStartedToReachTargetArea = true
                    }
                    
                    if localHighestY > highestY {
                        highestY = localHighestY
                        bestVector = CGVector(dx: cgFloatX, dy: initialYVelocity)
                        
                        print(highestY, bestVector)
                    } else {
                        print("Only reached \(localHighestY) starting with \(velocity). Final position \(probe.position)")
                    }
                    
                    initialYVelocity += 1
                    probe = Probe(velocity: CGVector(dx: cgFloatX, dy: initialYVelocity))
                } else if haveStartedToReachTargetArea {
                    // Used to end up in target area but not any more
                    
                    break whileTrueLoop
                } else {
                    // Not yet entered the target area
                    initialYVelocity += 1
                    probe = Probe(velocity: CGVector(dx: cgFloatX, dy: initialYVelocity))
                }
            }
            
        }
         
        return (highestY, bestVector) // Has to be initialYVelocity - 1 because we incremented the initialYVelocity before the failing probe
    }
}

let exampleTargetArea = TargetArea(xArea: exampleXArea, yArea: exampleYArea)

Launcher.launchProbeWith(velocity: CGVector(dx: 7, dy: 2), towards: exampleTargetArea) // true (correct)
Launcher.launchProbeWith(velocity: CGVector(dx: 6, dy: 3), towards: exampleTargetArea) // true (correct)
Launcher.launchProbeWith(velocity: CGVector(dx: 9, dy: 0), towards: exampleTargetArea) // true (correct)
Launcher.launchProbeWith(velocity: CGVector(dx: 17, dy: -4), towards: exampleTargetArea) // false (correct)

Launcher.minimumXVelocityTo(reach: exampleTargetArea.xArea.lowerBound)

Launcher.launchProbeWith(velocity: CGVector(dx: 6, dy: 9), towards: exampleTargetArea)

//Launcher.highestProbeTo(reach: exampleTargetArea)

let puzzleTargetArea = TargetArea(xArea: 206...250, yArea: ClosedRange(uncheckedBounds: (lower: -105, upper: -57)))

Launcher.highestProbeTo(reach: puzzleTargetArea) // 1326 (too low)
