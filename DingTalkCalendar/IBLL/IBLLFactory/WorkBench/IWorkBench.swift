//
//  IWorkBench.swift
//  DingTalkCalander
//
//  Created by Noah_Shan on 2018/4/12.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import Foundation


protocol IWorkBench {
    
    /// get dates with position & middleDates
    ///
    /// - Parameters:
    ///   - position: position- middle left right
    ///   - middleDates: middleDates may be nil
    ///   - middleFollowDate: middleDates order to which day
    /// - Returns: trupleInfo
    func getDate(position: DingTalkPosition,middleDates: dingTalkTrupleModel!,middleFollowDate: Date?)->dingTalkTrupleModel

    /// folow dingTalkTrupleModel create a key [string]
    ///
    /// - Parameter dateInfo: dingTalkTrupleModel
    /// - Returns: str-key
    func getDicKey(with dateInfo: dingTalkTrupleModel)->dingTalkTrupleKey
    
    /// get after month [next month] first day
    ///
    /// - Parameter date: trupleinfo
    /// - Returns: date
    func getAfterMonthFirstDay(with date: dingTalkTrupleModel)->Date
    
    /// get before month [] last day
    ///
    /// - Parameter date: truple info
    /// - Returns: date
    func getBeforeMonthLastDay(with date: dingTalkTrupleModel)->Date
    
    /// follow date create a key [string]
    ///
    /// - Parameter dateInfo: date info
    /// - Returns: str - key
    func getDicKey(with dateInfo : Date)->dingTalkTrupleKey
    
    /// get 7 days [before or next]
    ///
    /// - Parameters:
    ///   - dateInfo: first day || last day in this line
    ///   - lastDays: true : rights ; false : left[before]
    /// - Returns: values
    func get7Days(with dateInfo: Date,is lastDays:Bool)->[DingTalkCalanderModel]
}
