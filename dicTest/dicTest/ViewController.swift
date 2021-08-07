//
//  ViewController.swift
//  dicTest
//
//  Created by J_Min on 2021/08/05.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTestField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!

    var dictionary: [String: [String]] = [:] // 빈 딕셔너리 Key: String, value: [String]
    var array : [String] = [""] // array, ""를 넌 이유가 있었는데 기억안남ㅋ
    var currentIndex: String = "" // 현재 표시할 배열의 Index 값
    var dictionaryIndex: [String] = [] // 현재 표시할 딕셔너리의 배열값
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        pageControl.currentPage = 0 // pageControl 현재페이지
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:))) // 왼쪽 스와이프
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:))) // 오른쪽 스와이프
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        pageControl.isHidden = true // 페이지컨트롤 ui 안보이게
        
//        currentIndex = array[pageControl.currentPage]
//        dictionaryIndex = dictionary[currentIndex] ?? []
    }

    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) { // 스와이프했을때 실행할 함수
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left: // 왼쪽스와이프
                if (pageControl.currentPage < pageControl.numberOfPages - 1) {
                    pageControl.currentPage = pageControl.currentPage + 1
                }
            case UISwipeGestureRecognizer.Direction.right: // 오른쪽스와이프
                if (pageControl.currentPage > 0) {
                    pageControl.currentPage = pageControl.currentPage - 1
                }
            default: break
            }
            currentIndex = array[pageControl.currentPage] // 현재 페이지에 해당하는 array index값
            dictionaryIndex = dictionary[currentIndex] ?? [] // 현재 페이지에 해당하는 dictionary key값의 배열
            tableView.reloadData()
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        let str = firstTextField.text! // 첫번째 텍스트필드의 텍스트
        let str2 = secondTestField.text! // 두번째 텍스트필드의 텍스트
        
        if array.contains(str) { // array에 str 있을때
            dictionary[str]?.append(str2) // dictionary 해당 str key의 value에 str2 추가
        } else {
            array.append(str) // array에 str값 저장
            dictionary[str] = [str2] // dictionary에 key: str, value [str2] 값 저장
        }
        if array.contains("") == true {
            array.removeFirst() // 첫 저장할때 array에 저장돼있던 "" 값 지우기
        }
        
        currentIndex = array[pageControl.currentPage] // 현재 페이지에 해당하는 array index값
        dictionaryIndex = dictionary[currentIndex] ?? []// 현재 페이지에 해당하는 dictionary key값의 배열
        
        pageControl.numberOfPages = array.count // array 개수만큼 pageControl 만들기
        tableView.reloadData()
    }
    
    @IBAction func pageChanged(_ sender: Any) {
        currentIndex = array[pageControl.currentPage] // 현재 페이지에 해당하는 array index값
        dictionaryIndex = dictionary[currentIndex] ?? [] // 현재 페이지에 해당하는 dictionary key값의 배열
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionaryIndex.count // 현재 페이지에 하당하는 dictionary key값의 배열의 개수
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.keyLabel.text = currentIndex
        cell.valueLabel.text = dictionaryIndex[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

class TableViewCell: UITableViewCell {
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
}



// 딕셔너리에 키가 있을땐 append 없을땐 새로 생성해줘야함
// guard로 키먼저 생성해주고 그 다음 .append로 추가해주자

