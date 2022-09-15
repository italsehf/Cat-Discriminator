//
//  ViewController.swift
//  CatDiscriminator
//
//  Created by Keum MinSeok on 2022/09/01.
//

import CoreML
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let imageSelectLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Tap to select the image"
        label.textColor = UIColor.systemGray
        label.numberOfLines = 0
        label.isHidden = false
        return label
    }()
    
    private let catBreedView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let catBreedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Cat Breed"
        label.numberOfLines = 0
        return label
    }()
    
    private let informationView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private var informationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Information abount Cat Breed"
        label.numberOfLines = 0
        return label
    }()
    
    private let informationCatBreedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Tangerine")
        view.addSubview(imageView)
        view.addSubview(imageSelectLabel)
        view.addSubview(catBreedView)
        view.addSubview(catBreedLabel)
        view.addSubview(informationView)
        view.addSubview(informationLabel)
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapImage)
        )
        tap.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    @objc func didTapImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
        imageSelectLabel.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top+40,
            width: view.frame.size.width-40,
            height: view.frame.size.width-40
        )
        imageView.backgroundColor = UIColor(named: "Beige")
        imageView.layer.cornerRadius = 20
        
        catBreedView.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top+60+(view.frame.size.width-40)+10,
            width: view.frame.size.width-40,
            height: 40
        )
        catBreedView.layer.cornerRadius = 20
        catBreedView.backgroundColor = UIColor(named: "Beige")
        
        informationView.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top+130+(view.frame.size.width-40)+10,
            width: view.frame.size.width-40,
            height: 260
        )
        informationView.layer.cornerRadius = 20
        informationView.backgroundColor = UIColor(named: "Beige")
        
        setUpImageSelectLabelView()
        setUpCatBreedLabelView()
        setUpInformationLabelView()
//        setUpNavigationTitle()
    }
    
    func setUpImageSelectLabelView() {
        imageSelectLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageSelectLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            imageSelectLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    func setUpCatBreedLabelView() {
        catBreedLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            catBreedLabel.centerXAnchor.constraint(equalTo: catBreedView.centerXAnchor),
            catBreedLabel.centerYAnchor.constraint(equalTo: catBreedView.centerYAnchor)
        ])
    }
    
    func setUpInformationLabelView() {
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            informationLabel.widthAnchor.constraint(equalTo: informationView.widthAnchor),
            informationLabel.heightAnchor.constraint(equalTo: informationView.heightAnchor),
            informationLabel.centerXAnchor.constraint(equalTo: informationView.centerXAnchor),
            informationLabel.centerYAnchor.constraint(equalTo: informationView.centerYAnchor)
        ])
    }
    
//    private func setUpNavigationTitle() {
//        navigationItem.title = "Cat Discriminator"
//        navigationItem.titleView =
//    }
    
    private func analyzeImage(image: UIImage?) {
        guard let buffer = image?.resize(size: CGSize(width: 224, height: 224))?
            .getCVPixelBuffer() else {
            return
        }
        
        do {
            let config = MLModelConfiguration()
            let model = try CatClassification2(configuration: config)
            let input = CatClassification2Input(image: buffer)
            
            let output = try model.prediction(input: input)
            let text = output.classLabel
            catBreedLabel.text = text
            
            if text == "\(output.classLabel)" {
                if text == "Russian Blue" {
                    informationLabel.text = "이 고양이는 제가 키우는 러시안 블루, 차차입니다. 귀엽죠? 저도 알아요^^"
                } else {
                    if text == "Others" {
                        informationLabel.text = "고양이 사진을 고르신 거 맞죠..?"
                    } else {
                        if text == "Turkish Angora" {
                            informationLabel.text = "귀가 작다, 콧대가 일자가 아니다, 털이 짧다, 볼살이 있고 얼굴이 둥글다 - 이 중 하나라도 해당되면 당신의 고양이는 터앙이 아니랍니다~"
                        } else {
                            if text == "Persian" {
                                informationLabel.text = "확실하게 Persian 고양이 사진이라고는 말 못하겠네요 ㅈㅅ;;"
                            }
                        }
                    }
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Image Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // cancelled
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        imageView.image = image
        analyzeImage(image: image)
    }
}

