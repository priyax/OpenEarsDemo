//
//  ViewController.swift
//  OpenEarsDemo
//
//  Created by Priya Xavier on 9/27/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit
import AVFoundation
//import OpenEars/OELanguageModelGenerator.h
//import <OpenEars/OEAcousticModel.h
//import <OpenEars/OEPocketsphinxController.h>
//import <OpenEars/OEEventsObserver.h>
class ViewController: UIViewController, OEEventsObserverDelegate {
    @IBOutlet weak var recipeDisplay: UITextView!
    @IBAction func readRecipe(_ sender: UIButton) {
        
        let test = recipeDisplay.text
        let utterance = AVSpeechUtterance(string: test!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        synthesizer.speak(utterance)
        loadOpenEars()
        OEPocketsphinxController.sharedInstance().requestMicPermission()
               
    }
    var openEarsEventObserver = OEEventsObserver()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


        var lmPath: String!
        var dicPath: String!
        var words: Array<String> = []
        var currentWord: String!
        let synthesizer = AVSpeechSynthesizer()

        
        func loadOpenEars() {
            self.openEarsEventObserver = OEEventsObserver()
            self.openEarsEventObserver.delegate = self
            
            let lmGenerator = OELanguageModelGenerator()
            
            addWords()
            
            let name = "LanguageModelFileStarSaver"
            lmGenerator.generateLanguageModel(
                from: words, withFilesNamed: name, forAcousticModelAtPath: OEAcousticModel.path(toModel: ("AcousticModelEnglish")))
            
            lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModel(withRequestedName: name)
            dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionary(withRequestedName: name)
            
            print("lmPath = \(lmPath)")
             print("dicPath = \(dicPath)")
        }
    
    func micPermissionCheckCompleted(_ result: Bool) {
        print("Permission to use mike \(result)")
        if result {
        startListening()
        }
    }
        func pocketsphinxDidReceiveHypothesis(_ hypothesis: String, recognitionScore: String, utteranceID: String) {
            print("The received hypothesis is \(hypothesis) with a score of \(recognitionScore) and an ID of \(utteranceID)")
            if hypothesis == "Stop" {
            synthesizer.
            }
        }
        
        func pocketsphinxDidStartListening() {
            print("Pocketsphinx is now listening.")
        }
        
        func pocketsphinxDidDetectSpeech() {
            print("Pocketsphinx has detected speech.")
            
        }
        
        func pocketsphinxDidDetectFinishedSpeech() {
            print("Pocketsphinx has detected a period of silence, concluding an utterance.")
        }
        
        func pocketsphinxDidStopListening() {
            print("Pocketsphinx has stopped listening.")
        }
        
        func pocketsphinxDidSuspendRecognition() {
            print("Pocketsphinx has suspended recognition.")
        }
        
        func pocketsphinxDidResumeRecognition() {
            print("Pocketsphinx has resumed recognition.")
        }
        
        func pocketsphinxDidChangeLanguageModelToFile(newLanguageModelPathAsString: String, newDictionaryPathAsString: String) {
            print("Pocketsphinx is now using the following language model: \(newLanguageModelPathAsString) and the following dictionary: \(newDictionaryPathAsString)")
        }
        
        func pocketSphinxContinuousTeardownDidFail(withReason reasonForFailure: String) {
            print("Listening setup wasn’t successful and returned the failure reason: \(reasonForFailure)")
        }
        
        func pocketSphinxContinuousTeardownDidFailWithReason(reasonForFailure: String) {
            print("Listening teardown wasn’t successful and returned the failure reason: \(reasonForFailure)")
        }
        
        func testRecognitionCompleted() {
            print("A test file that was submitted for recognition is now complete.")
        }
        
        func startListening() {
            do {
                try OEPocketsphinxController.sharedInstance().setActive(true)
                
                
                OEPocketsphinxController.sharedInstance().startListeningWithLanguageModel(atPath: lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"), languageModelIsJSGF: false)
            } catch let error as NSError {
                print("Error while startListening: \(error) – \(error.localizedDescription)")
            }
        }
        
        func stopListening() {
            OEPocketsphinxController.sharedInstance().stopListening()
        }
        
        func addWords() {
            //add any thing here that you want to be recognized. Must be in capital letters
            words.append("START")
            words.append("STOP")
            words.append("CONTINUE")
            words.append("REPEAT")
        }
        
    
    
//    


}

