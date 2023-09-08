//
//  HelpSupportVC.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 7.09.2023.
//

import UIKit
import SnapKit

struct FAQItem {
    let question: String
    let answer: String
}

class HelpSupportVC: UIViewController {
    
    let faqData: [FAQItem] = [
        FAQItem(question: "Nasıl bir gezi planlamalıyım?",
                answer: "Gezi planlaması yaparken öncelikle hedeflerinizi belirlemeniz önemlidir. Sonra nereye gitmek istediğinizi ve ne tür bir deneyim aradığınızı düşünün. Buna göre konaklama, ulaşım ve aktiviteleri planlayabilirsiniz."),
        FAQItem(question: "Vize işlemleri nasıl yapılır?",
                answer: "Vize gereksinimleri ülkelere göre değişir. Hedef ülkenizin konsolosluğu veya büyükelçiliği ile iletişime geçip gerekli belgeleri ve süreci öğrenmelisiniz."),
        FAQItem(question: "Hangi mevsimde gitmeliyim?",
                answer: "Gezi yaparken gitmek istediğiniz yerin mevsimleri önemlidir. Tatil amacınıza ve hava koşullarına bağlı olarak en uygun mevsimi seçmelisiniz."),
        FAQItem(question: "Gezi sırasında nasıl bütçe yapmalıyım?",
                answer: "Bütçenizi belirlemek ve kontrol altında tutmak için önceden araştırma yapmalısınız. Ulaşım, konaklama, yeme içme ve aktivite maliyetlerini göz önünde bulundurun."),
        FAQItem(question: "Yabancı dil bilmeden nasıl iletişim kurarım?",
                answer: "Yabancı dil bilmediğinizde temel ifadeleri öğrenmek ve çeviri uygulamaları kullanmak yardımcı olabilir. Ayrıca jestler ve mimiklerle iletişim kurabilirsiniz."),
        FAQItem(question: "Nasıl güvenli bir şekilde seyahat edebilirim?",
                answer: "Seyahat sağlığınıza, kişisel güvenliğinize ve mal varlığınıza dikkat edin. Pasaport ve değerli eşyalarınızı güvende tutun ve acil durumlar için bir acil durum planı yapın."),
        FAQItem(question: "Yerel kültüre nasıl saygılı olabilirim?",
                answer: "Yerel kültürü anlamaya çalışın ve yerel adetlere saygılı olun. Giyim kurallarına dikkat edin ve fotoğraf çekerken izin isteyin.")
    ]
    
    var selectedIndex = -1
    var isExpand = false
    
    private lazy var btnBack: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(btnBackTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.text = "Help&Support"
        label.textColor = .white
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 32)
        return label
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.backgroundLight.colorValue()
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = AppColor.backgroundLight.colorValue()
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.estimatedRowHeight = 150
        tv.rowHeight = UITableView.automaticDimension
        tv.register(HelpSupportTVC.self, forCellReuseIdentifier: HelpSupportTVC.identifier)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        mainView.roundCorners(corners: [.topLeft], radius: 80)
    }
    
    @objc private func btnBackTapped() {
        print("back button tapped")
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = AppColor.primaryColor.colorValue()
        self.view.addSubviews(btnBack,
                              lblTitle,
                              mainView)
        self.mainView.addSubviews(tableView)
        setupLayouts()
    }
    
    private func setupLayouts() {
        btnBack.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(32)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(22)
            make.width.equalTo(24)
        }
        
        lblTitle.snp.makeConstraints { make in
            make.leading.equalTo(btnBack.snp.trailing).offset(24)
            make.centerY.equalTo(btnBack.snp.centerY)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(lblTitle.snp.bottom).offset(58)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview()
        }
        
    }
    
}

extension HelpSupportVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath.row && isExpand == true {
            return 140
        } else {
            return 74
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.text = "FAQ"
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 24)
        label.textColor = AppColor.primaryColor.colorValue()
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath.row {
            if self.isExpand == true {
                isExpand = false
            } else {
                isExpand = true
            }
        }
        selectedIndex = indexPath.row
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

extension HelpSupportVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HelpSupportTVC.identifier, for: indexPath) as? HelpSupportTVC else { return UITableViewCell() }
        cell.configure(with: faqData[indexPath.row])
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathsForVisibleRows?.first {
            tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
        }
    }
    
    
    
}
