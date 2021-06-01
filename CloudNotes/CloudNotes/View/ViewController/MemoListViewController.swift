//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 
import Foundation
import UIKit

class MemoListViewController: UIViewController {
    
    let tableView = UITableView()
    
    lazy var rightNvigationItem: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
//        button.addTarget(self, action: #selector(), for: .touchDown)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        setUpNavigationBar()
    }
    
    private func setUpNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNvigationItem)
        self.navigationItem.title = "메모"
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    private func setUpTableView() {
        self.view.addSubview(tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(MemoListTableViewCell.classForCoder(),forCellReuseIdentifier:MemoListTableViewCell.identifier)
        self.setTableViewLayout()
    }
    
    private func setTableViewLayout() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            self.tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            self.tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            self.tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0),
        ])
    }
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier : MemoListTableViewCell.identifier) as? MemoListTableViewCell else {
            
            return UITableViewCell()
        }
        cell.configure(with: Memo(title: "", writedDate: "", main: ""))
        return cell
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailMemoViewController = DetailMemoViewController()
        detailMemoViewController.configure(with: Memo(title: "애플, 한국에 개발자 아카데미 개설 공식 발표",
                             writedDate: "",
                             main: "[서울=뉴시스] 안호균 기자 = 애플이 정보통신기술(ICT) 인재 양성을 위한 프로그램인 '개발자 아카데미(Apple Developer Academy)'를 한국에 개설한다고 13일 공식 발표했다. 애플은 이날 뉴스룸을 통해 브라질, 인도네시아, 이탈리아를 비롯한 10여 곳의 아카데미에 이어 디트로이트와 한국에도 아카데미 프로그램이 새롭게 개설된다고 밝혔다. 애플 개발자 아카데미는 기업가, 개발자, 디자이너를 꿈꾸는 이들을 교육해 iOS 앱 생태계에서 일자리를 얻고 창출할 수 있도록 돕자는 목표로 2013년 브라질에 처음 개설됐다. 현재 애플은 세계 곳곳에 12개 이상의 개발자 아카데미를 운영 중이며 한국과 미국 디트로이트에 추가로 아카데미를 개설할 예정이다.애플이 오는 6월 개발자 대회(WWDC)를 앞두고 한국에 개발자 아카데미를 연다는 소식을 발표자 국내 ICT 업계에서도 관심이 커지고 있다. 현재 애플은 한국에 개설될 아카데미 부지와 파트너 선정을 위해 관련 팀을 가동하고 있는 것으로 알려졌다. 아카데미에서는 두 종류의 프로그램을 운영한다. 특정 주제를 다루는 30일 과정의 기초 코스는 앱 개발 분야에서 커리어를 쌓고자 하는 이들을 위한 입문 과정이다. 10~12개월 동안 진행되는 집중 프로그램은 코딩과 전문 역량을 개발할 수 있는 과정이다. 지원 자격은 특별하지 않다. 18세 이상 고등학교 졸업자 이상이면 개발 관련 경험이 없어도 누구나 지원 가능하다. 애플은 전 세계에 위치한 아카데미의 수강생들은 코딩의 기본과 핵심 전문 역량, 디자인, 마케팅을 배우고, 졸업생들은 현지 비즈니스 커뮤니티에 기여하는 데 필요한 모든 역량을 갖추게 된다며 또 커리큘럼 전반에 애플의 가치가 담겨 있어 학생들이 포용적인 방식으로 디자인하고 세상에 긍정적인 영향을 줄 수 있도록 장려한다고 설명했다. 한편 애플의 개발자회의 WWDC는 6월 7일부터 11일까지 온라인으로 개최될 예정이다. WWDC는 수백 명의 현 개발자 아카데미 학생들과 이전 학생들을 비롯해, 모든 연령과 배경의 개발자들이 참여하는 수백 개의 세션으로 이뤄진다. 개발자들은 이런 세션에 참여해 앱과 게임을 개발하는 데 필요한 새로운 기술, 툴, 프레임워크에 대한 정보를 공유하게 된다. [서울=뉴시스] 안호균 기자 = 애플이 정보통신기술(ICT) 인재 양성을 위한 프로그램인 '개발자 아카데미(Apple Developer Academy)'를 한국에 개설한다고 13일 공식 발표했다. 애플은 이날 뉴스룸을 통해 브라질, 인도네시아, 이탈리아를 비롯한 10여 곳의 아카데미에 이어 디트로이트와 한국에도 아카데미 프로그램이 새롭게 개설된다고 밝혔다. 애플 개발자 아카데미는 기업가, 개발자, 디자이너를 꿈꾸는 이들을 교육해 iOS 앱 생태계에서 일자리를 얻고 창출할 수 있도록 돕자는 목표로 2013년 브라질에 처음 개설됐다. 현재 애플은 세계 곳곳에 12개 이상의 개발자 아카데미를 운영 중이며 한국과 미국 디트로이트에 추가로 아카데미를 개설할 예정이다.애플이 오는 6월 개발자 대회(WWDC)를 앞두고 한국에 개발자 아카데미를 연다는 소식을 발표자 국내 ICT 업계에서도 관심이 커지고 있다. 현재 애플은 한국에 개설될 아카데미 부지와 파트너 선정을 위해 관련 팀을 가동하고 있는 것으로 알려졌다. 아카데미에서는 두 종류의 프로그램을 운영한다. 특정 주제를 다루는 30일 과정의 기초 코스는 앱 개발 분야에서 커리어를 쌓고자 하는 이들을 위한 입문 과정이다. 10~12개월 동안 진행되는 집중 프로그램은 코딩과 전문 역량을 개발할 수 있는 과정이다. 지원 자격은 특별하지 않다. 18세 이상 고등학교 졸업자 이상이면 개발 관련 경험이 없어도 누구나 지원 가능하다. 애플은 전 세계에 위치한 아카데미의 수강생들은 코딩의 기본과 핵심 전문 역량, 디자인, 마케팅을 배우고, 졸업생들은 현지 비즈니스 커뮤니티에 기여하는 데 필요한 모든 역량을 갖추게 된다며 또 커리큘럼 전반에 애플의 가치가 담겨 있어 학생들이 포용적인 방식으로 디자인하고 세상에 긍정적인 영향을 줄 수 있도록 장려한다고 설명했다. 한편 애플의 개발자회의 WWDC는 6월 7일부터 11일까지 온라인으로 개최될 예정이다. WWDC는 수백 명의 현 개발자 아카데미 학생들과 이전 학생들을 비롯해, 모든 연령과 배경의 개발자들이 참여하는 수백 개의 세션으로 이뤄진다. 개발자들은 이런 세션에 참여해 앱과 게임을 개발하는 데 필요한 새로운 기술, 툴, 프레임워크에 대한 정보를 공유하게 된다."))
        navigationController?.pushViewController(detailMemoViewController, animated: true)
    }
}
