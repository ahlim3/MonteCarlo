//
//  ContentView.swift
//  Shared
//
//  Created by Anthony Lim on 2/20/21.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    @EnvironmentObject var plotDataModel :PlotDataClass
    @ObservedObject private var calculator = CalculatePlotData()
    @State var isChecked:Bool = false
    @State var tempInput = ""
    @State var pi = 0.0
    @State var totalGuesses = 0.0
    @State var totalIntegral = 0.0
    @State var xinput = 10.0
    @State var xinputdown = 0.0
    @State var xInput: String = "\(1.0)"
    @State var xInputLower: String = "\(0.0)"
    @State var guessString = "23458"
    @State var totalGuessString = "0"
    @State var areaString = "0.0"
    @State var errorString = "0.0"
    @State var actualString = "0.0"
    @State var nStringA = ""
    @State var nStringE = ""
    @State var nCombine = ""
    @ObservedObject var monteCarlo = MonteCarloArea(withData: true)
    let n:[Int] = [10,20,50,100,200,500,1000,10000,50000,100000,500000,1000000]
    
  
    

    var body: some View {
        
        VStack{
      
            CorePlot(dataForPlot: $plotDataModel.plotData, changingPlotParameters: $plotDataModel.changingPlotParameters)
                .setPlotPadding(left: 10)
                .setPlotPadding(right: 10)
                .setPlotPadding(top: 10)
                .setPlotPadding(bottom: 10)
                .padding()
                .frame(minHeight: 300, maxHeight: 1000)
                .frame(minWidth: 480, maxWidth: 1000)
                .padding()
                .padding()
            
            
            HStack{
                
                
                VStack{
                    HStack(alignment: .center) {
                        Text("upperlimit")
                            .font(.callout)
                            .bold()
                        TextField("Upper limit", text: $xInput)
                            .padding()
                    }.padding()
                    HStack(alignment: .center) {
                        Text("lowerlimit")
                            .font(.callout)
                            .bold()
                        TextField("Lower limit", text: $xInputLower)
                            .padding()
                    }.padding()
                                 
                    
                    Button("Error Calculation", action: {self.nfunction()})
                        .padding()
                    Button("Estimation Calculation", action: {self.nfunction2()})
                        .padding()
                    
                }
                .padding()
                
                
               
                
            }
            
            

            
        }
        
    }
    
    
    
    
    /// calculate
    /// Function accepts the command to start the calculation from the GUI
    func calculate(){
        
     
        //pass the plotDataModel to the cosCalculator
        calculator.plotDataModel = self.plotDataModel
        
        //Calculate the new plotting data and place in the plotDataModel
        calculator.ploteToTheMinusX()
        
        
    }

    func nfunction (){
        let maxIndex = n.count
        let x = Double(xInput)
        let x2 = Double(xInputLower)
        xinput = x!
        xinputdown = x2!
        var irrIndex = 0
        var errorArray:[Double] = Array(repeating: 0.0, count: maxIndex)
        var areaArray:[Double] = Array(repeating: 0.0, count: maxIndex)
        plotDataModel.changingPlotParameters.yMax = 1.0
        plotDataModel.changingPlotParameters.yMin = -8.0
        plotDataModel.changingPlotParameters.xMax = 10.0
        plotDataModel.changingPlotParameters.xMin = -2.0
        plotDataModel.changingPlotParameters.xLabel = "ln(n)"
        plotDataModel.changingPlotParameters.yLabel = "ln(Error)"
        plotDataModel.changingPlotParameters.lineColor = .blue()
        plotDataModel.changingPlotParameters.title = "Error of exp(-x) Integral lower to upper"

        plotDataModel.zeroData()
        var plotData :[plotDataType] =  []
        
        while irrIndex < maxIndex {
            monteCarlo.guesses = n[irrIndex]
            monteCarlo.xinput = xinput
            monteCarlo.xinputdown = xinputdown
            monteCarlo.calculateArea()
            //check = monteCarlo.area
            //check2 = monteCarlo.error
            areaArray[irrIndex] = monteCarlo.area
            errorArray[irrIndex] = monteCarlo.error
            nStringA += String(format: "%f ", areaArray[irrIndex])
            
            nStringE += String(format: "%f ", errorArray[irrIndex])
            
            let dataPoint: plotDataType = [.X:  log10(Double(n[irrIndex])), .Y: log10(errorArray[irrIndex])]
            plotData.append(contentsOf: [dataPoint])
            
            plotDataModel.calculatedText += "\(n[irrIndex])\t\(errorArray[irrIndex])\n"
            
        irrIndex = irrIndex + 1
            
        }
        nCombine = nStringE + "\n" + nStringA
        plotDataModel.appendData(dataPoint: plotData)

        
    }
    func nfunction2 (){
        let maxIndex = n.count
        let x = Double(xInput)
        let x2 = Double(xInputLower)
        xinput = x!
        xinputdown = x2!
        var irrIndex = 0
        var errorArray:[Double] = Array(repeating: 0.0, count: maxIndex)
        var areaArray:[Double] = Array(repeating: 0.0, count: maxIndex)
        plotDataModel.changingPlotParameters.yMax = 1.0
        plotDataModel.changingPlotParameters.yMin = -1.0
        plotDataModel.changingPlotParameters.xMax = 7.0
        plotDataModel.changingPlotParameters.xMin = -1.0
        plotDataModel.changingPlotParameters.xLabel = "log(n)"
        plotDataModel.changingPlotParameters.yLabel = "e^-x integral 0 to 1 at n"
        plotDataModel.changingPlotParameters.lineColor = .red()
        plotDataModel.changingPlotParameters.title = "exp(-x)"

        plotDataModel.zeroData()
        var plotData :[plotDataType] =  []
        
        while irrIndex < maxIndex {
            monteCarlo.guesses = n[irrIndex]
            monteCarlo.xinput = xinput
            monteCarlo.xinputdown = xinputdown
            monteCarlo.calculateArea()
            //check = monteCarlo.area
            //check2 = monteCarlo.error
            areaArray[irrIndex] = monteCarlo.area
            errorArray[irrIndex] = monteCarlo.error
            nStringA += String(format: "%f ", areaArray[irrIndex])
            
            nStringE += String(format: "%f ", errorArray[irrIndex])
            
            let dataPoint: plotDataType = [.X:  log10(Double(n[irrIndex])), .Y: areaArray[irrIndex]]
            plotData.append(contentsOf: [dataPoint])
            
            plotDataModel.calculatedText += "\(n[irrIndex])\t\(areaArray[irrIndex])\n"
            
        irrIndex = irrIndex + 1
            
        }
        nCombine = nStringE + "\n" + nStringA
        plotDataModel.appendData(dataPoint: plotData)

        
    }
   
  
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
