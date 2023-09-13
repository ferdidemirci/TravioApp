//
//  HelpSupportVM.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 13.09.2023.
//

import Foundation

struct FAQItem {
    let question: String
    let answer: String
}

class HelpSupportVM {
    
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
    
}
