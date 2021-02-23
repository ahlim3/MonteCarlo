//
//  Monte.swift
//  MonteCarloIntegrationAnthonyLim
//
//  Created by Anthony Lim on 2/13/21.
//

import Foundation
import SwiftUI

class MonteCarloArea: NSObject, ObservableObject {
    
    @Published var insideData = [(xPoint: Double, yPoint: Double)]()
    @Published var outsideData = [(xPoint: Double, yPoint: Double)]()
    @Published var totalGuessesString = ""
    @Published var guessesString = ""
    @Published var areaString = ""
    @Published var errorString = ""
    @Published var actualIntegralString = ""
    
    var area = 0.0
    var guesses = 1
    var totalGuesses = 0
    var totalIntegral = 0.0
    var xinputdown = 0.0
    var xinput = 10.0
    var error = 0.0
    var actualIntegral = 0.0

    
    init(withData data: Bool){
        
        super.init()
        
        insideData = []
        outsideData = []
        
    }


    /// calculate the value of area
    ///
    /// - Calculates the Value of area under the e^-x using Monte Carlo Integration
    ///
    /// - Parameter sender: Any
    func calculateArea() {
        
        var maxGuesses = 0.0
        let boundingBoxCalculator = BoundingBox() ///Instantiates Class needed to calculate the area of the bounding box.
        
        
        maxGuesses = Double(guesses)
        
        totalIntegral = totalIntegral + calculateMonteCarloIntegral(xup: xinput, xdown:xinputdown, maxGuesses: maxGuesses)
        
        totalGuesses = totalGuesses + guesses
        
        totalGuessesString = "\(totalGuesses)"
        
        ///Calculates the value of π from the area of a unit circle
        
        area = totalIntegral/Double(totalGuesses) * boundingBoxCalculator.calculateSurfaceArea(numberOfSides: 2, lengthOfSide1: xinput, lengthOfSide2: xinput, lengthOfSide3: xinputdown)
        actualIntegral = mvInt(lowerlimit: xinputdown, upperlimit: xinput)
        
        error = abs(actualIntegral - area)
     	   
        areaString = "\(area)"
        errorString = "\(error)"
        actualIntegralString = "\(actualIntegral)"
        
       
        
    }

    /// calculates the Monte Carlo Integral of a Circle
    ///
    /// - Parameters:
    ///   - radius: radius of circle
    ///   - maxGuesses: number of guesses to use in the calculaton
    /// - Returns: ratio of points inside to total guesses. Must mulitply by area of box in calling function
    func calculateMonteCarloIntegral(xup: Double, xdown:Double, maxGuesses: Double) -> Double {
        
        var numberOfGuesses = 0.0
        var pointsInRadius = 0.0
        var integral = 0.0
        var point = (xPoint: 0.0, yPoint: 0.0)
        var radiusPoint = 0.0
        
        var newInsidePoints : [(xPoint: Double, yPoint: Double)] = []
        var newOutsidePoints : [(xPoint: Double, yPoint: Double)] = []
        
        
        while numberOfGuesses < maxGuesses {
            
            /* Calculate 2 random values within the box */
            /* Determine the distance from that point to the origin */
            /* If the distance is less than the unit radius count the point being within the Unit Circle */
            point.xPoint = Double.random(in: xdown...xup)
            point.yPoint = Double.random(in: xdown...xup)
            
            radiusPoint = exp(-point.xPoint)
            
            
            // if inside the area under the exponential add to the number of points in the radius
            if((point.yPoint - radiusPoint) < 0.0){
                pointsInRadius += 1.0
                
                
                newInsidePoints.append(point)
               
            }
            else { //if outside the exponential do not add to the number of points in the radius
                
                
                newOutsidePoints.append(point)

                
            }
            
            numberOfGuesses += 1.0
            
            
            
            
            }

        
        integral = Double(pointsInRadius)
        
        //Append the points to the arrays needed for the displays
        //Don't attempt to draw more than 250,000 points to keep the display updating speed reasonable.
        
        if ((totalGuesses < 1000001) || (insideData.count == 0)){
        
            insideData.append(contentsOf: newInsidePoints)
            outsideData.append(contentsOf: newOutsidePoints)
            
        }
        
        return integral
        }


    func mvInt(lowerlimit:Double, upperlimit:Double) -> Double {
        var average = 0.0
        let increment = 0.001
        var maxstep = 0
        var step = 0
        var tempx = 0.0
        var sum = 0.0
        var integral_sum = 0.0
        let range = upperlimit - lowerlimit
        maxstep = Int (range / increment)
        var yArray:[Double] = Array(repeating: 0.0, count: maxstep)
        while (step < maxstep){
            tempx = increment * Double(step) + lowerlimit
            yArray[step] = targetF(value: tempx)
            sum = yArray[step] + sum
            step = step + 1
        }
        average = sum / Double(maxstep)
        integral_sum = range * average
        
        return integral_sum
        
        }
    func targetF (value:Double) -> Double
    {
        let output = exp(-value)
        return output
    }


}
