//
//  ViewController.swift
//  OpenEarsDemo
//
//  Created by Priya Xavier on 9/27/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit
//import AVFoundation

class ViewController: UIViewController, OEEventsObserverDelegate {
    @IBOutlet weak var recipeDisplay: UITextView!
    var openEarsEventObserver = OEEventsObserver()
    var fliteController = OEFliteController()
    var slt = Slt()
    
    
    //Reading Button action
    @IBAction func readRecipe(_ sender: UIButton) {
        
        loadOpenEars()
        OEPocketsphinxController.sharedInstance().requestMicPermission()
        self.fliteController = OEFliteController()
        self.slt = Slt()
        
        self.fliteController.say(recipeDisplay.text, with: self.slt)
//        let test = recipeDisplay.text
//        let utterance = AVSpeechUtterance(string: test!)
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//        
//        synthesizer.speak(utterance)
       
       

        
        
    }
    
    
    
    //Listen button action
    @IBAction func listenBtn(_ sender: UIButton) {
        //Create language model with dictionary of fixed words
        loadOpenEars()
        //To end any previous sessions
        if OEPocketsphinxController.sharedInstance().isListening {
            self.stopListening() }
      OEPocketsphinxController.sharedInstance().requestMicPermission()
        
    }
    
    var stoppedListening: Bool = false
    
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


    //functions part of OEEventsObserver Delegate
    //result of mic permission sent to function
    func micPermissionCheckCompleted(_ result: Bool) {
    print("Permission to use this mike \(result)")
        
            if result {
                
                startListening()
            }
      }

    //Activate listening with OEPocketSphinxController
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
    
    func resumeListening() {
         OEPocketsphinxController.sharedInstance().resumeRecognition()
    }
    
    func addWords() {
        //add any thing here that you want to be recognized. Must be in capital letters
        words.append("START")
        words.append("STOP")
        words.append("CONTINUE")
        words.append("REPEAT")
    }

    
        func pocketsphinxDidReceiveHypothesis(_ hypothesis: String, recognitionScore: String, utteranceID: String) {
            print("The received hypothesis is \(hypothesis) with a score of \(recognitionScore) and an ID of \(utteranceID)")
           
            print("The word \(hypothesis) was recognized")
                //recipeDisplay.text = hypothesis
                
            
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
            stoppedListening = true
            print("XXXXXXXXXXX \(stoppedListening)")
            self.resumeListening()
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
        
    
    
    
//    


}

