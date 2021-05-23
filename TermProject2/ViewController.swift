//
//  ViewController.swift
//  TermProject2
//
//  Created by KpuGame on 2021/05/17.
//

import UIKit
import Speech


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var nosunPickerDataSource = ["경부선","남해선(순천-부산)","광주대구선","무안광주선","서해안선","호남선","순천완주선","청주영덕선","통영대전선","중부선","평택제천선","중부내륙선","영동선","중앙선","동해선(삼척-속초)","동해선(부산-포항)","수도권제1순환선","서천공주선","호남지선","중부내륙지선"]
    
  
    //xml parsing
    //var locationInfoUrl: String = //"http://data.ex.co.kr/openapi/locationinfo/locationinfoRest?key=test&type=xml&numOfRows=100&routeNo="
    var foodsAndFacilitiesUrl: String = "http://data.ex.co.kr/openapi/business/conveniServiceArea?key=test&type=xml&numOfRows=100"
    var themeUrl: String = "http://data.ex.co.kr/openapi/restinfo/restThemeList?key=test&type=xml&numOfRows=100&routeCd="
    var weatherInfoUrl: String = "http://data.ex.co.kr/openapi/restinfo/restWeatherList?key=7237197557&type=xml&sdate=20210507&stdHour=10"
    
    var routeNum: String = "0010"

    @IBOutlet weak var nosunPickerView: UIPickerView!
    @IBOutlet weak var startVoiceButton: UIButton!
    @IBOutlet weak var stopVoiceButton: UIButton!
    @IBOutlet weak var myTextView: UITextView!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    private var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nosunPickerView.delegate = self;
        self.nosunPickerView.dataSource = self;
        authorizeSR()
    }
    
    
    @IBAction func doneToPickerViewController(segue:UIStoryboardSegue){
    }
    @IBAction func startVoiceButton(_ sender: Any) {
        startVoiceButton.isEnabled = false
        stopVoiceButton.isEnabled = true
        try! startSession()
    }
    @IBAction func stopTranscribing(_ sender: Any) {
        if audioEngine.isRunning{
            audioEngine.stop()
            speechRecognitionRequest?.endAudio()
            startVoiceButton.isEnabled = true
            stopVoiceButton.isEnabled = false
        }
        /*switch(self.myTextView.text){
        case "경부선" : self.pickerView.selectRow(0, inComponent: 0, animated: true)
            sgguCd = "110023"
            break
        case "구로구" : self.pickerView.selectRow(1, inComponent: 0, animated: true)
            sgguCd = "110005"
            break
        case "동대문구" : self.pickerView.selectRow(2, inComponent: 0, animated: true)
            sgguCd = "110007"
            break
        case "종로구" : self.pickerView.selectRow(3, inComponent: 0, animated: true)
            sgguCd = "110016"
            break
        default: break
        }*/
    }
    
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nosunPickerDataSource.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return nosunPickerDataSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        /*경부선: 0010, 남해선: 0100, 광주대구선: 0120, 무안광주선: 0121, 서해안선: 0150,
        호남선: 0251, 순천완주선: 0270, 청주영덕선: 0300, 통영대전선: 0351, 중부선: 0352
        평택제천선: 0400, 중부내륙선: 0450, 영동선: 0500, 중앙선: 0550, 서울양양선:0600
        동해선(삼척-속초): 0650, 동해선(부산-포항): 0652, 수도권제1순환선: 1000
        서천공주선: 1510, 호남지선: 2510, 중부내륙지선: 4510*/
        if row == 0{
            routeNum = "0010" //경부
        }else if row == 1{
            routeNum = "0100" //남해
        }else if row == 2{
            routeNum = "0120" // 광주대구
        }else if row == 3{
            routeNum = "0121" //무안광주
        }else if row == 4{
            routeNum = "0150" //서해안
        }else if row == 5{
            routeNum = "0251" //호남
        }else if row == 6{
            routeNum = "0270" //순천완주
        }
        else if row == 7{
            routeNum = "0300" //청주영덕
        }
        else if row == 8{
            routeNum = "0351" //통영대전
        }
        else if row == 9{
            routeNum = "0352" //중부
        }
        else if row == 10{
            routeNum = "0400" //평택제천
        }
        else if row == 11{
            routeNum = "0450" //중부내륙
        }else if row == 12{
            routeNum = "0500" //영동
        }else if row == 13{
            routeNum = "0550" //중앙
        }else if row == 14{
            routeNum = "0600" //서울양양
        }
        else if row == 15{
            routeNum = "0650" //동해(삼척-속초)
        }
        else if row == 16{
            routeNum = "0652" //동해(부산-포항)
        }
        else if row == 17{
            routeNum = "1000" //수도권제1순환
        }
        else if row == 18{
            routeNum = "1510" //서천공주
        }
        else if row == 19{
            routeNum = "2510" //호남지선
        }
        else if row == 20{
            routeNum = "4510" //중부내륙
        }
    }
    
    //다음페이지로 으로 넘어가기 위한 시작 페이지를 위한 함수
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToTableView"{
            if let navController = segue.destination as? UINavigationController{
                if let restAreaListViewController = navController.topViewController as? RestAreaListViewController{
                    restAreaListViewController.url = foodsAndFacilitiesUrl + "&routeCode=" + routeNum
                }
            }
        }
    }
    
    func authorizeSR(){
        SFSpeechRecognizer.requestAuthorization{
            authStatus in OperationQueue.main.addOperation{
            switch authStatus{
            case .authorized:
                self.startVoiceButton.isEnabled = true
            case .denied:
                self.startVoiceButton.isEnabled = false
            case .notDetermined:
                self.startVoiceButton.isEnabled = false
                self.startVoiceButton.setTitle("Speech recognition not authorized", for: .disabled)
            case .restricted:
                self.startVoiceButton.isEnabled = false
                self.startVoiceButton.setTitle("Speech recognition restricted on device", for: .disabled)
            @unknown default: break
                
            }
            }
        }
    }
    
    func startSession() throws{
        if let recognitionTask = speechRecognitionTask{
            recognitionTask.cancel()
            self.speechRecognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.record)
        
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = speechRecognitionRequest else{
            fatalError("SFSpeechAudioBufferRecognitionRequest object creation failed")
        }
        let inputNode = audioEngine.inputNode
        
        recognitionRequest.shouldReportPartialResults = true
        speechRecognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest){
            result, error in var finished = false
            
            if let result = result{
                self.myTextView.text = result.bestTranscription.formattedString
                finished = result.isFinal
            }
            if error != nil || finished{
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.speechRecognitionRequest = nil
                self.speechRecognitionTask = nil
                self .startVoiceButton.isEnabled = true
            }
        }
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){
            (buffer: AVAudioPCMBuffer, when: AVAudioTime)in self.speechRecognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
    }

      
}
