//
//  ViewController.swift
//  UIKit-Laboratory
//
//  Created by denny on 2/11/25.
//

import SnapKit
import UIKit

class TextItemView: UIView {
    private var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.text = "TextLabel"
        return label
    }()
    
    private var subTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.text = "Sub-TextLabel"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemYellow
        self.addSubview(textLabel)
        self.addSubview(subTextLabel)
        
        textLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(4)
        }
        
        subTextLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(4)
            make.bottom.leading.trailing.equalToSuperview().inset(4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
    private var isTaskListViewHidden: Bool = false
    
    private var taskContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private var taskCountView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private var taskListView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        addItems()
    }
    
    @objc
    private func didTapCountView() {
        isTaskListViewHidden.toggle()
        taskListView.isHidden = isTaskListViewHidden
    }
    
    private func setupLayout() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(didTapCountView))
        taskCountView.addGestureRecognizer(tapGesture)
        
        view.addSubview(taskContainerView)
        taskContainerView.addSubview(taskCountView)
        taskContainerView.addSubview(taskListView)
        
        taskContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        taskCountView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        taskListView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalTo(taskCountView.snp.leading).offset(-8)
        }
    }
    
    private func addItems() {
        let items = ["할 일 1", "할 일 2", "할 일 3", "할 일 4", "할 일 5"]
        
        for text in items {
            let itemView = AnimatedCheckView(text: text)
            itemView.delegate = self
            taskListView.addArrangedSubview(itemView)
            
            itemView.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
        }
    }
    
    private func removeItem(_ view: AnimatedCheckView) {
        UIView.animate(withDuration: 0.3, animations: {
            view.isHidden = true
        }) { _ in
            self.taskListView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
}

extension ViewController: AnimatedCheckViewDelegate {
    func didCompleteAnimation(_ view: AnimatedCheckView) {
        removeItem(view)
    }
}

