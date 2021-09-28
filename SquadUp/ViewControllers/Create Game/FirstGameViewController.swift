//
//  CreateGameViewController.swift
//  SquadUp-v4
//
//  Created by Tommy Alpert on 11/4/20.
//

import UIKit

class FirstGameViewController: UIViewController {
    
    // MARK: - Outlets and Variables
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var sportCollectionView: UICollectionView!
    
    let sports = ["Baseball", "Basketball", "Soccer", "Tennis", "Football", "Running"]
    var selectedCellIndex : Int = -1
    var selectedSport = ""
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        customizeUI()
        
        sportCollectionView.delegate = self
        sportCollectionView.dataSource = self
        self.sportCollectionView.register(UINib(nibName: "sportsCell", bundle: nil), forCellWithReuseIdentifier: sportsCell.reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    // MARK: - Actions
    
    @objc func cancelGame() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        let nextVC = SecondGameViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
        nextVC.sport = selectedSport
    }
    
    // MARK: - Helpers
    
    func setUpNavBar() {
        
        // Overall nav bar
        navigationController?.navigationBar.barStyle = .black
        navigationItem.setHidesBackButton(true, animated: false)
        let textAttribute : [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttribute
        navigationController?.navigationBar.topItem?.title = "Select Sport"
        navigationController?.navigationBar.topItem?.prompt = "1 of 3"
        
        // Right cancel button
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelGame))
        let textAttribute2 : [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont(name: "HelveticaNeue-Medium", size: 13)!, .underlineStyle: NSUnderlineStyle.single.rawValue ]
        let textAttribute3 : [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightGray, .font: UIFont(name: "HelveticaNeue-Medium", size: 13)!, .underlineStyle: NSUnderlineStyle.single.rawValue ]
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.setTitleTextAttributes(textAttribute2, for: .normal)
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.setTitleTextAttributes(textAttribute3, for: .selected)

    }
    
    func customizeUI() {
        nextButton.layer.cornerRadius = 10
        nextButton.layer.borderWidth = 3
        nextButton.layer.borderColor = UIColor.black.cgColor
        nextButton.alpha = 0.5
        nextButton.isEnabled = false
    }
    
    func enableNextButton() {
        nextButton.alpha = 1
        nextButton.layer.borderWidth = 3
        nextButton.layer.borderColor = UIColor.black.cgColor
        nextButton.backgroundColor = UIColor.green.darker(by: 5)
        nextButton.isEnabled = true
    }
    
    func disableNextButton() {
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor.clear
        nextButton.layer.borderWidth = 3
        nextButton.alpha = 0.5
        nextButton.layer.borderColor = UIColor.black.cgColor
    }
}

// MARK: - Collection View

extension FirstGameViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sports.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = sportCollectionView.dequeueReusableCell(withReuseIdentifier: sportsCell.reuseIdentifier, for: indexPath) as! sportsCell
        
        cell.displayCell()
        
        cell.sportText.text = sports[indexPath.row]
        cell.sportImage.image = UIImage(named: sports[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 182, height: 242)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Deselect old cell
        if selectedCellIndex != -1 {
            let oldIndexPath = IndexPath(row: selectedCellIndex, section: 0)
            guard let cell1 = collectionView.cellForItem(at: oldIndexPath) as? sportsCell else { return }
            cell1.selectCell()
        }
        
        if indexPath.row != selectedCellIndex {
            
            // select new cell
            
            guard let cell2 = collectionView.cellForItem(at: indexPath) as? sportsCell else {
                return
            }
            cell2.selectCell()
            selectedCellIndex = indexPath.row
            selectedSport = cell2.sportText.text!
        } else {
            
            // No new cell selected
            
            selectedCellIndex = -1
            selectedSport = ""
        }
        
        // Enable next button
        if selectedCellIndex != -1 {
            enableNextButton()
        } else {
            disableNextButton()
        }
    }
    
}
