//
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
// AOPGCDExtension.swift
//
// Created by    Noah Shan on 2018/3/15
// InspurEmail   shanwzh@inspur.com
// GithubAddress https://github.com/hatjs880328s
//
// Copyright © 2018年 Inspur. All rights reserved.
//
// For the full copyright and license information, plz view the LICENSE(open source)
// File that was distributed with this source code.
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * *
//
//

import Foundation


class IIMergeSort<T:Comparable> {
    
    /// step - insert sort
    /// two sorted arrs , use insert sort method
    /// - Parameters:
    ///   - arrayLeft: arrone
    ///   - arrayRight: arrtwo
    /// - Returns: result
    private class func sort(arrayLeft:[T],arrayRight:[T],sortState:String)->[T] {
        var leftindex = 0
        var rightindex = 0
        var resultarray = [T]()
        while leftindex <= arrayLeft.count - 1 ||  rightindex <= arrayRight.count - 1{
            if sortState == "desc" {
                if arrayLeft[leftindex] >= arrayRight[rightindex] {
                    resultarray.append(arrayLeft[leftindex])
                    if leftindex != arrayLeft.count - 1 {
                        leftindex += 1
                    }else{
                        for eachItem in rightindex ... arrayRight.count - 1 {
                            resultarray.append(arrayRight[eachItem])
                        }
                        break
                    }
                }else{
                    resultarray.append(arrayRight[rightindex])
                    if rightindex != arrayRight.count - 1 {
                        rightindex += 1
                    }else{
                        for eachItem in leftindex ... arrayLeft.count - 1 {
                            resultarray.append(arrayLeft[eachItem])
                        }
                        break
                    }
                }
            }else{
                if arrayLeft[leftindex] <= arrayRight[rightindex] {
                    resultarray.append(arrayLeft[leftindex])
                    if leftindex != arrayLeft.count - 1 {
                        leftindex += 1
                    }else{
                        for eachItem in rightindex ... arrayRight.count - 1 {
                            resultarray.append(arrayRight[eachItem])
                        }
                        break
                    }
                }else{
                    resultarray.append(arrayRight[rightindex])
                    if rightindex != arrayRight.count - 1 {
                        rightindex += 1
                    }else{
                        for eachItem in leftindex ... arrayLeft.count - 1 {
                            resultarray.append(arrayLeft[eachItem])
                        }
                        break
                    }
                }
            }
        }
        return resultarray
    }
    
    
    /// division the arr  [eg: [a,b,c] -> arrs eg : [a] [b] [c] ]
    ///
    /// - Parameter array: origin arr
    /// - Returns: result
    private class func sepAllnumberToarray(array:[T])->[[T]] {
        var resultarray = [[T]]()
        if array.count == 0 { return resultarray }
        for eachItem in 0 ... array.count - 1 {
            resultarray.append([array[eachItem]])
        }
        return resultarray
    }
    
    
    /// insert sort
    ///
    /// - Parameter arrays: arrs
    /// - Returns: result
    private class func combineArray(arrays:[[T]],sortState:String)->[T] {
        if arrays.count == 1 {
            return arrays[0]
        }
        if arrays.count == 2 {
            return self.sort(arrayLeft: arrays[0], arrayRight: arrays[1],sortState:sortState)
        }
        let groupCount = arrays.count / 2
        let groupSplit = arrays.count % 2
        var resultArray = [[T]]()
        
        for eachItem in 0 ... groupCount - 1 {
            resultArray.append(self.sort(arrayLeft: arrays[eachItem * 2], arrayRight: arrays[eachItem * 2 + 1],sortState:sortState))
        }
        if groupSplit != 0 {
            resultArray.append(arrays.last!)
        }
        return combineArray(arrays: resultArray,sortState:sortState)
    }
    
    
    /// merge sort default asc [ u could use desc :) ]
    ///
    /// - Parameter array: origin arr
    /// - Returns: result
    class func sort(array:[T],sortState:String = "asc")->[T] {
        let info = sepAllnumberToarray(array: array)
        if info.count == 0 { return array }
        return combineArray(arrays: info,sortState:sortState)
    }
}
