//
//  Day 17.swift
//  Advent of Code 2021
//
//  Created by James Coleman on 17/12/2021.
//

import Foundation

func day17() {
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
                print("Starting x: \(x)")
                
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
                        // Now that we know the maximum height (5460.0 (20.0, 104.0))
                        // could we simply use that as the y limit?
                        
                        // The bug in part 1 showed that after (20.0, 104.0), no other velocity entered the target area.
                        // Could we take e.g. max dy 200 and assume?
                        // If we get the wrong answer, raise the limit
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
                            
                            print(highestY, bestVector) // 5460 with (20, 104)
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
    
    let puzzleTargetArea = TargetArea(xArea: 206...250, yArea: ClosedRange(uncheckedBounds: (lower: -105, upper: -57)))

    print("Final answer", Launcher.highestProbeTo(reach: puzzleTargetArea))
    
    
}
