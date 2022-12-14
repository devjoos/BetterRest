//
//  ContentView.swift
//  BetterRest
//
//  Created by Sam Joos on 8/14/22.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeup = wakeupDefault
    @State private var sleepAmount = 8.0
    @State private var cofeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    var reccoBedtime: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeup)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(cofeeAmount))
            let sleepTime = wakeup - prediction.actualSleep
            
            return "Your ideal bedtime is \(sleepTime.formatted(date: .omitted, time: .shortened))"
            
            
        } catch {
            
           return "Sorry, there was a problem calcuating your bedtime"
            
        }
    }
    
    static var wakeupDefault: Date {
        var compons = DateComponents()
        compons.hour = 7
        compons.minute = 30
        return Calendar.current.date(from: compons) ?? Date.now
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("Please enter a time", selection: $wakeup, displayedComponents: .hourAndMinute)

                } header: {
                    Text("when do you want to wake up?")
                        
                }
                
                
                Section("Desired amount of sleep") {
                    
                    Stepper("\(sleepAmount.formatted())", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Daily coffee intake") {
                    
                    Picker("", selection: $cofeeAmount) {
                        ForEach(0..<11) {
                            Text($0 == 1 ? "\($0) cup" : "\($0) cups" )
                        }
                    }
                   
                }
                Text(reccoBedtime)
                    .font(.title3)
              
                    
                    
                   
                    
                    
//                    Stepper(cofeeAmount == 1 ? "1 cup": "\(cofeeAmount) cups", value: $cofeeAmount, in: 1...20)
                
            }
            .navigationTitle("Better Rest")
//            .toolbar {
//                Button("Calculate") {
//                    calculateBedtime()
//                }
//            }
//            .alert(alertTitle, isPresented: $showingAlert) {
//                Button("OK") { }
//            } message: {
//                Text(alertMessage)
//                }
                
        
        }
      
        
    }
}
//    func calculateBedtime() {
//        do {
//            let config = MLModelConfiguration()
//            let model = try SleepCalculator(configuration: config)
//            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeup)
//            let hour = (components.hour ?? 0) * 60 * 60
//            let minute = (components.minute ?? 0) * 60
//
//            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(cofeeAmount))
//            let sleepTime = wakeup - prediction.actualSleep
//
//            alertTitle = "Your ideal bedtime is:"
//            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
//
//        } catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calcuating your bedtime"
//
//        }
////        showingAlert = true
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
