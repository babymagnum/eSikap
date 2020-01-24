//
//  DaftarPeminjamanRuanganController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 22/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SVProgressHUD
import Toast_Swift

class DaftarPeminjamanRuanganController: BaseViewController {

    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var stackWeekHeight: NSLayoutConstraint!
    @IBOutlet weak var viewMonthHeight: NSLayoutConstraint!
    @IBOutlet weak var labelEmpty: CustomLabel!
    @IBOutlet weak var labelTutupCalendar: UILabel!
    @IBOutlet weak var buttonPengajuan: CustomButton!
    @IBOutlet weak var viewTutupCalendar: UIView!
    @IBOutlet weak var imageTutupCalendar: UIImageView!
    @IBOutlet weak var collectionCalendar: JTAppleCalendarView!
    @IBOutlet weak var stackviewConstraintBot: NSLayoutConstraint!
    @IBOutlet weak var stackviewConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var collectionCalendarHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionDaftarPeminjamanRuangan: UICollectionView!
    @IBOutlet weak var collectionDaftarPeminjamanRuanganHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionDaftarPeminjamanRuanganTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var viewMonth: UIView!
    
    private var currentDate = Date()
    private var isFirstTimeOpen = true
    private var selectedDate = ""
    private var listSchedules = [SchedulesRoomData]()
    private let formatter = DateFormatter()
    private var isCalendarShow = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        getSchedules()
        
        initEvent()
    }
    
    private func initEvent() {
        viewTutupCalendar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTutupCalendarClick)))
        buttonPengajuan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonPengajuanClick)))
    }
    
    private func getSchedulesOneDay(date: String) {
        SVProgressHUD.show()
        
        informationNetworking.getScheduleRoomsOneDay(date: date) { (error, schedules, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController ?? UINavigationController(nibName: "DaftarPeminjamanRuanganController", bundle: nil))
                return
            }
            
            if let _error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel") {
                    self.getSchedulesOneDay(date: date)
                }
                return
            }
            
            guard let _schedules = schedules else { return }
            
            self.listSchedules = _schedules.data
            
            self.labelEmpty.text = _schedules.message
            self.labelEmpty.isHidden = self.listSchedules.count > 0
            
            self.collectionDaftarPeminjamanRuangan.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIView.animate(withDuration: 0.2) {
                    self.collectionDaftarPeminjamanRuanganHeight.constant = self.collectionDaftarPeminjamanRuangan.contentSize.height
                    self.scrollView.resizeScrollViewContentSize()
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    private func getSchedules() {
        SVProgressHUD.show()
        
        informationNetworking.getScheduleRoomsOneMonth(month: function.getCurrentDate(pattern: "MM"), year: function.getCurrentDate(pattern: "yyyy")) { (error, schedules, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel") {
                    self.getSchedules()
                }
                return
            }
            
            guard let _schedules = schedules else { return }
            
            self.listSchedules = _schedules.data
            
            self.labelEmpty.text = _schedules.message
            self.labelEmpty.isHidden = self.listSchedules.count > 0
            
            self.collectionDaftarPeminjamanRuangan.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIView.animate(withDuration: 0.2) {
                    
                    self.collectionDaftarPeminjamanRuanganHeight.constant = self.collectionDaftarPeminjamanRuangan.contentSize.height
                    self.scrollView.resizeScrollViewContentSize()
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionDaftarPeminjamanRuangan.collectionViewLayout.invalidateLayout()
        
    }
    
    private func initView() {
        checkTopMargin(viewRootTopMargin: constraintViewRoot)
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        labelMonth.text = function.convertDateToString(pattern: "MMMM yyyy", date: currentDate)
        buttonPengajuan.isUserInteractionEnabled = true
        viewTutupCalendar.isUserInteractionEnabled = true
        buttonPengajuan.giveBorder(5, 0, "fff")
        viewTutupCalendar.giveBorder(5, 1, "42a5f5")
        collectionCalendar.scrollToDate(Date(),animateScroll: false)
        collectionCalendar.selectDates([Date()])
        imageTutupCalendar.image = UIImage(named: "icUp")?.tinted(with: UIColor.darkGray)
        buttonPrevious.setImage(UIImage(named: "icUp")?.tinted(with: UIColor.darkGray), for: .normal)
        buttonNext.setImage(UIImage(named: "icDown")?.tinted(with: UIColor.darkGray), for: .normal)

        collectionCalendar.register(UINib(nibName: "DateCell", bundle: nil), forCellWithReuseIdentifier: "DateCell")
        collectionCalendar.calendarDataSource = self
        collectionCalendar.calendarDelegate = self
        
        collectionDaftarPeminjamanRuangan.register(UINib(nibName: "DaftarPeminjamanRuanganCell", bundle: nil), forCellWithReuseIdentifier: "DaftarPeminjamanRuanganCell")
        collectionDaftarPeminjamanRuangan.delegate = self
        collectionDaftarPeminjamanRuangan.dataSource = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
 
    // Configure the cell
    func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let currentCell = cell as? DateCell else {
            return
        }
        
        currentCell.dateLabel.text = cellState.text
        configureTextColorFor(cell: currentCell, cellState: cellState)
    }
    
    // Configure text colors
    func configureTextColorFor(cell: JTAppleCell?, cellState: CellState){
        
        guard let currentCell = cell as? DateCell else {
            return
        }
        if cellState.isSelected{
            currentCell.dateLabel.textColor = UIColor.white
            currentCell.viewContainer.backgroundColor = UIColor(hexString: "9ccc65")
        }else{
            currentCell.viewContainer.backgroundColor = UIColor(hexString: "ffffff")
            
            if cellState.dateBelongsTo == .thisMonth {
                currentCell.dateLabel.textColor = UIColor.black
            }else{
                currentCell.dateLabel.textColor = UIColor.gray
            }
        }
    }
}

extension DaftarPeminjamanRuanganController: FormPeminjamanRuanganProtocol {
    func updateData() {
        getSchedules()
    }
    
    @objc func buttonPengajuanClick() {
        let vc = FormPeminjamanRuanganController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func viewTutupCalendarClick() {
        if isCalendarShow {
            UIView.animate(withDuration: 0.2) {
                self.imageTutupCalendar.image = UIImage(named: "icDown")?.tinted(with: UIColor.darkGray)
                self.labelTutupCalendar.text = "Buka Kalender"
                self.collectionCalendarHeight.constant = 0
                self.viewMonthHeight.constant = 0
                self.stackWeekHeight.constant = 0
                self.stackviewConstraintTop.constant = 0
                self.stackviewConstraintBot.constant = 0
                self.viewMonth.isHidden = true
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.imageTutupCalendar.image = UIImage(named: "icUp")?.tinted(with: UIColor.darkGray)
                self.labelTutupCalendar.text = "Tutup Kalender"
                self.collectionCalendarHeight.constant = 210
                self.viewMonthHeight.constant = 30
                self.stackWeekHeight.constant = 30
                self.stackviewConstraintTop.constant = 10
                self.stackviewConstraintBot.constant = 10
                self.viewMonth.isHidden = false
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            }
        }

        isCalendarShow = !isCalendarShow
    }
}

extension DaftarPeminjamanRuanganController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DaftarPeminjamanRuanganProtocol {
    
    func agendaClick(data: SchedulesRoomDataAgenda) {
        let vc = DetailPeminjamanRuanganController()
        vc.requestRoomId = data.id
        vc.isFromHistory = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateLayout() {
        collectionDaftarPeminjamanRuangan.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var agendaHeight: CGFloat = 0
        let item = listSchedules[indexPath.item]
        item.agenda.forEach { (item) in
            let height = item.title_agenda?.getHeight(withConstrainedWidth: UIScreen.main.bounds.size.width - 32 - 19.2 - 26, font_size: 12) ?? 0
            agendaHeight += height + 26
        }
        agendaHeight += CGFloat(item.agenda.count - 1 * 7)
        return CGSize(width: UIScreen.main.bounds.size.width - 32, height: agendaHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listSchedules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DaftarPeminjamanRuanganCell", for: indexPath) as! DaftarPeminjamanRuanganCell
        cell.delegate = self
        cell.data = listSchedules[indexPath.item]
        return cell
    }
}

extension DaftarPeminjamanRuanganController: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        calendar.scrollingMode = .stopAtEachSection

        let startDate = formatter.date(from: function.getCurrentDate(pattern: "dd-MM-yyyy"))!
        var dateComponents = DateComponents()
        dateComponents.year = 1
        let endDate = Calendar.current.date(byAdding: dateComponents, to: startDate)!

        let parameters = ConfigurationParameters(startDate: startDate,
                                endDate: endDate,
                                numberOfRows: 6,
                                calendar: Calendar.current,
                                generateInDates: .forAllMonths,
                                generateOutDates: .tillEndOfRow,
                                firstDayOfWeek: .sunday,
                                hasStrictBoundaries: true)
        return parameters
    }

}

extension DaftarPeminjamanRuanganController: JTAppleCalendarViewDelegate{

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {

        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        configureCell(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {

        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        configureCell(cell: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
        
        if !isFirstTimeOpen {
            selectedDate = function.convertDateToString(pattern: "yyyy-MM-dd", date: date)
            getSchedulesOneDay(date: selectedDate)
        }
        
        isFirstTimeOpen = false
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    @IBAction func buttonPreviousClick(_ sender: Any) {
        if currentDate < Date() {
            self.view.makeToast("Sudah mencapai batas bulan.")
        } else {
            var dateComponents = DateComponents()
            dateComponents.month = -1
            let futureDate = Calendar.current.date(byAdding: dateComponents, to: currentDate) ?? Date()
            currentDate = futureDate
            
            labelMonth.text = function.convertDateToString(pattern: "MMMM yyyy", date: currentDate)
            collectionCalendar.scrollToDate(currentDate, animateScroll: true)
        }
    }
    
    @IBAction func buttonNextClick(_ sender: Any) {
        var maxDateComponents = DateComponents()
        maxDateComponents.year = 1
        let maxDate = Calendar.current.date(byAdding: maxDateComponents, to: Date())!
        
        if currentDate > maxDate {
            self.view.makeToast("Sudah mencapai batas bulan.")
        } else {
            var currentDateComponents = DateComponents()
            currentDateComponents.month = 1
            let futureDate = Calendar.current.date(byAdding: currentDateComponents, to: currentDate)!
            currentDate = futureDate
            
            labelMonth.text = function.convertDateToString(pattern: "MMMM yyyy", date: currentDate)
            collectionCalendar.scrollToDate(currentDate, animateScroll: true)
        }
    }
}
