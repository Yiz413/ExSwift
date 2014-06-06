//
//  Dictionary.swift
//  ExSwift
//
//  Created by pNre on 04/06/14.
//  Copyright (c) 2014 pNre. All rights reserved.
//

import Foundation

extension Dictionary {

    /**
     *  Checks if the specified key exists in the dictionary
     *  @param key Key to check
     *  @return true if the key exists
     */
    func has (key: KeyType) -> Bool {

        return indexForKey(key) != nil

    }
    
    /**
     *  Creates a Dictionary with the same keys as self and values generated by running
     *  each (key, value) of self through the mapFunction
     *  @param mapFunction
     *  @return Mapped dictionary
     */
    func mapValues (mapFunction map: (KeyType, ValueType) -> (ValueType)) -> Dictionary<KeyType, ValueType> {

        var mapped = Dictionary<KeyType, ValueType>()

        self.each({
            mapped[$0] = map($0, $1)
        })

        return mapped

    }
    
    /**
     *  Creates a Dictionary with keys and values generated by running
     *  each (key, value) of self through the mapFunction
     *  @param mapFunction
     *  @return Mapped dictionary
     */
    func map (mapFunction map: (KeyType, ValueType) -> (KeyType, ValueType)) -> Dictionary<KeyType, ValueType> {

        var mapped = Dictionary<KeyType, ValueType>()

        self.each({
            let (_key, _value) = map($0, $1)
            mapped[_key] = _value
        })

        return mapped
        
    }
    
    /**
     *  Loops trough each (key, value) pair in self
     *  @param eachFunction
     */
    func each (eachFunction each: (KeyType, ValueType) -> ()) {

        for (key, value) in self {
            each(key, value)
        }

    }
    
    /**
     *  Constructs a dictionary containing every (key, value) pair from self
     *  for which testFunction evaluates to true.
     *  @param testFunction
     *  @return Filtered dictionary
     */
    func filter(testFunction test: (KeyType, ValueType) -> Bool) -> Dictionary<KeyType, ValueType> {
        
        var result = Dictionary<KeyType, ValueType>()
        
        for (key, value) in self {
            if test(key, value) {
                result[key] = value
            }
        }
        
        return result
        
    }
    
    /**
     *  Returns true if self contains no keys
     *  @return True if self is empty
     */
    func isEmpty () -> Bool {
        return Array(self.keys).isEmpty
    }
    
    /**
    *  Returns a new dictionary containing the contents of self and 
    *  the contents of all the dictionaries passed as parameters
    *  @param dictionaries Dictionaries to merge with self
    *  @return Merge result
    */
    func merge (dictionaries: Dictionary<KeyType, ValueType>...) -> Dictionary<KeyType, ValueType> {

        var result = Dictionary<KeyType, ValueType>()
        let allDictionaries = [self] + dictionaries

        for dictionary in allDictionaries {
            for (key, value) in dictionary {
                result[key] = value
            }
        }
        
        return result

    }

    /**
    *  Creates a dictionary composed of keys generated from the results of running each element of self through groupingFunction. The corresponding value of each key is an array of the elements responsible for generating the key.
    *  @param groupingFunction
    *  @return Grouped dictionary
    */
    func groupBy <T> (groupingFunction group: (KeyType, ValueType) -> (T)) -> Dictionary<T, Array<ValueType>> {
        
        var result = Dictionary<T, Array<ValueType>>();
        
        for (key, value) in self {
            
            let groupKey = group(key, value)
            var array: Array<ValueType>? = nil
            
            //  This is the first object for groupKey
            if !result.has(groupKey) {
                array = Array<ValueType>()
            } else {
                array = result[groupKey]
            }
            
            var finalArray = array!

            finalArray.push(value)
            
            result[groupKey] = finalArray
            
        }
        
        return result
        
    }
    
    /**
    *  Checks if test returns true for all the elements in self
    *  @param test Function to call for each element
    *  @return True if call returns true for all the elements in self
    */
    func all (test: (KeyType, ValueType) -> (Bool)) -> Bool {
        
        for (key, value) in self {
            if !test(key, value) {
                return false
            }
        }
        
        return true
        
    }
    
    /**
    *  Checks if test returns true for any element of self
    *  @param test Function to call for each element
    *  @return True if call returns true for any element of self
    */
    func any (test: (KeyType, ValueType) -> (Bool)) -> Bool {
        
        for (key, value) in self {
            if test(key, value) {
                return true
            }
        }
        
        return false
        
    }
    
    /**
    *  Removes a (key, value) pair from self and returns it as tuple
    *  @return (key, value)
    */
    mutating func shift () -> (KeyType, ValueType) {
        let key: KeyType! = Array(keys).first()
        let value: ValueType! = removeValueForKey(key)
        
        return (key, value)
    }
    
}
