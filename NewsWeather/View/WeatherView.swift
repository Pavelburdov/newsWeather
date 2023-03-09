//
//  WeatherView.swift
//  NewsWeather
//
//  Created by Pavel on 21.02.2023.
//

import Foundation
import SnapKit
import UIKit
protocol WeatherViewDelegate {
    
}
class WeatherView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        configureConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

var weatherManager = WeatherManager()

//MARK: - Constants

private enum Constant {

    static let spacing: CGFloat = 20
    static let indent: CGFloat = 10


    enum StackViewMain {

        static let height: CGFloat = 10
    }

    enum StackViewTop {

        static let spacing: CGFloat = 10
        static let height: CGFloat = 25

    }

    enum StackTemp {

        static let spacing: CGFloat = 1
        static let height: CGFloat = 80
    }

    enum BackgroundImage {

        static let image = UIImage(named: "backgroundImg")
    }

    enum ButtonLocation {

        static let pointSize: CGFloat = 25
        static let largeConfig = UIImage.SymbolConfiguration(pointSize: Constant.ButtonLocation.pointSize, weight: .bold, scale: .large)
        static let image = UIImage(systemName: "location.circle.fill", withConfiguration: Constant.ButtonLocation.largeConfig)
        static let height: CGFloat = 25
        static let width: CGFloat = 25
    }

    enum SearchTextField {

        static let spacing: CGFloat = 10
        static let font = UIFont.systemFont(ofSize: 12, weight: .regular)
        static let placeHolder = "Search"


    }
    enum SearchButton {

        static let pointSize: CGFloat = 25
        static let largeConfig = UIImage.SymbolConfiguration(pointSize: Constant.SearchButton.pointSize, weight: .bold, scale: .large)
        static let image = UIImage(systemName: "magnifyingglass", withConfiguration: Constant.SearchButton.largeConfig)
        static let height: CGFloat = 25
        static let width: CGFloat = 25
    }

    enum ConditionImage {

        static let pointSize: CGFloat = 80
        static let largeConfig = UIImage.SymbolConfiguration(pointSize: Constant.ConditionImage.pointSize, weight: .regular, scale: .large)
        static let image = UIImage(systemName: "sun.max", withConfiguration: Constant.ConditionImage.largeConfig)
    }

    enum LabelNumber {

        static let font = UIFont.systemFont(ofSize: 80, weight: .regular)
        static let text = "20"
        static let color = UIColor.white
        static let height: CGFloat = 80
        static let width: CGFloat = 80

    }

    enum LabelDegree {

        static let font = UIFont.systemFont(ofSize: 80, weight: .regular)
        static let text = "\u{00B0}"
        static let color = UIColor.white
        static let height: CGFloat = 80
        static let width: CGFloat = 28

    }

    enum LabelCelcius {

        static let font = UIFont.systemFont(ofSize: 80, weight: .regular)
        static let text = "C"
        static let color = UIColor.white
        static let height: CGFloat = 80


    }

    enum LabelCity {

        static let font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        static let text = "Moscow"
        static let color = UIColor.white
        static let height: CGFloat = 25
    }
}



//MARK: - UI Elements

var stackViewMain = UIStackView()
var stackViewTop = UIStackView()
var stackTemp = UIStackView()

var buttonLocation = UIButton()
var searchButton = UIButton()

var conditionImage = UIImageView()
var backgroundImage = UIImageView()

var searchTextField = UITextField()

var labelNumber = GradientLabel()
var labelDegree = GradientLabel()
var labelCelcius = GradientLabel()
var labelCity = GradientLabel()


//MARK: - Methods
private extension WeatherView {

    func configureUI() {

        stackViewMain.axis = .vertical
        stackViewMain.alignment = .fill
        stackViewMain.distribution = .fill
        stackViewMain.spacing = Constant.spacing


        stackViewTop.axis = .horizontal
        stackViewTop.alignment = .fill
        stackViewTop.distribution = .fill
        stackViewTop.spacing = Constant.StackViewTop.spacing


        stackTemp.axis = .horizontal
        stackTemp.spacing = 1
        stackTemp.alignment = .center
        stackTemp.distribution = .fillProportionally
        stackTemp.spacing = Constant.StackTemp.spacing


        buttonLocation.setImage(Constant.ButtonLocation.image, for: .normal)
        buttonLocation.tintColor = .white


        searchButton.setImage(Constant.SearchButton.image, for: .normal)
        searchButton.tintColor = .white

        backgroundImage.image = Constant.BackgroundImage.image
        backgroundImage.contentMode = .scaleAspectFill


        conditionImage.tintColor = .white
        conditionImage.contentMode = .scaleAspectFit
        conditionImage.image = Constant.ConditionImage.image


        searchTextField.tintColor = .white
        searchTextField.placeholder = Constant.SearchTextField.placeHolder
        searchTextField.textAlignment = .right
        searchTextField.returnKeyType = .go
        


        labelNumber.textAlignment = .right
        labelNumber.textColor = Constant.LabelNumber.color
        labelNumber.text = Constant.LabelNumber.text
        labelNumber.font = Constant.LabelNumber.font
        labelNumber.update(colors: [.yellow, .systemYellow], startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))

        labelDegree.textAlignment = .left
        labelDegree.textColor = Constant.LabelDegree.color
        labelDegree.text = Constant.LabelDegree.text
        labelDegree.font = Constant.LabelNumber.font
        labelDegree.update(colors: [.yellow, .systemYellow], startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))

        labelCelcius.textAlignment = .left
        labelCelcius.textColor = Constant.LabelCelcius.color
        labelCelcius.text = Constant.LabelCelcius.text
        labelCelcius.font = Constant.LabelNumber.font
        labelCelcius.update(colors: [.yellow, .systemYellow], startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))

        labelCity.textAlignment = .center
        labelCity.textColor = Constant.LabelCity.color
        labelCity.text = Constant.LabelCity.text
        labelCity.font = Constant.LabelCity.font
        labelCity.update(colors: [.white, .gray], startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))

    }

    func configureConstraints() {

        addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        addSubview(stackViewMain)
        stackViewMain.snp.makeConstraints { make in
            make.left.equalTo(safeAreaLayoutGuide).offset(16)
            make.right.equalTo(safeAreaLayoutGuide).offset(-16)
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-480)
        }

        stackViewMain.addArrangedSubview(stackViewTop)
        stackViewTop.snp.makeConstraints { make in
            make.top.equalTo(stackViewMain)
            make.left.equalTo(stackViewMain)
            make.right.equalTo(stackViewMain)
            make.height.equalTo(Constant.StackViewTop.height)
        }

        stackViewTop.addArrangedSubview(buttonLocation)
        buttonLocation.snp.makeConstraints { make in
            make.height.equalTo(Constant.ButtonLocation.height)
            make.width.equalTo(Constant.ButtonLocation.width)
        }

        stackViewTop.addArrangedSubview(searchTextField)

        stackViewTop.addArrangedSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.width.equalTo(Constant.SearchButton.width)
            make.height.equalTo(Constant.SearchButton.height)
        }

        stackViewMain.addArrangedSubview(conditionImage)
        conditionImage.snp.makeConstraints { make in
            make.height.equalTo(Constant.ConditionImage.pointSize)
        }

        stackViewMain.addArrangedSubview(stackTemp)

        stackTemp.snp.makeConstraints { make in
            make.height.equalTo(Constant.StackTemp.height)

        }

        stackTemp.addArrangedSubview(labelNumber)
        labelNumber.snp.makeConstraints { make in
        }
        stackTemp.addArrangedSubview(labelDegree)
        labelDegree.snp.makeConstraints { make in
            make.width.equalTo(Constant.LabelDegree.width)
        }
        stackTemp.addArrangedSubview(labelCelcius)
        labelCelcius.snp.makeConstraints { make in

        }

        stackViewMain.addArrangedSubview(labelCity)
        labelCity.snp.makeConstraints { make in
            make.height.equalTo(Constant.LabelCity.height)

        }
    }
}

