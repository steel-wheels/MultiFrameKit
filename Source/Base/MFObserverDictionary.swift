/**
 * @file        MFObserverDictionary.swift
 * @brief      Define  MFObserverDictionary. class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiDataKit
import JavaScriptKit
import JavaScriptCore
import Foundation

public class MFObserverDictionary
{
        public typealias ListenerFunction = (Any?) -> Void        // new-value

        public struct ListnerHolder {
                var key:        String
                var listnerId:  Int

                public init(key k: String, listnerId l: Int){
                        self.key         = k
                        self.listnerId   = l
                }
        }

        private var mContext:           KSContext
        private var mValueTable:        NSMutableDictionary
        private var mObservers:         Dictionary<String, MIObjectListener>
        private var mListnerId:         Int

        public init(context ctxt: KSContext){
                mContext    = ctxt
                mValueTable = NSMutableDictionary(capacity: 32)
                mObservers  = [:]
                mListnerId  = 0
        }

        deinit {
                for key in mObservers.keys {
                        if let observer = mObservers[key] {
                                mValueTable.removeObserver(observer, forKeyPath: key)
                        }
                }
        }

        public var keys: Array<String> { get {
                if let result = Array(mValueTable.allKeys) as? Array<String> {
                        return result
                } else {
                        NSLog("[Error] at #function")
                        return []
                }
        }}

        public var count: Int { get {
                return mValueTable.count
        }}

        public var nativeValues: Array<MIValue> { get {
                var result: Array<MIValue> = []
                for elm in mValueTable.allValues {
                        if let obj = elm as? NSObject {
                                result.append(MIValue.fromObject(object: obj))
                        } else {
                                NSLog("[Error] Unexpected object at \(#file)")
                        }
                }
                return result
        }}

        public var scriptValues: Array<JSValue> { get {
                var result: Array<JSValue> = []
                for elm in mValueTable.allValues {
                        if let obj = elm as? NSObject {
                                if let val = JSValue(object: obj, in: mContext) {
                                        result.append(val)
                                } else {
                                        NSLog("[Error] Failed to allocate JSValue at \(#file)")
                                }
                        } else {
                                NSLog("[Error] Unexpected object at \(#file)")
                        }
                }
                return result
        }}

        public func setValue(_ val: NSObject, forKey key: String){
                mValueTable.setValue(val, forKey: key)
        }

        public func value(forKey k: String) -> NSObject? {
                if let obj =  mValueTable.value(forKey: k) as? NSObject {
                        return obj
                } else {
                        return nil
                }
        }

        public func addObserver(forKey key: String, listnerFunction lfunc: @escaping ListenerFunction) -> ListnerHolder {
                let result: ListnerHolder
                if let obs = mObservers[key] {
                        obs.add(listnerId: mListnerId, listenerFunction: lfunc)
                        result = ListnerHolder(key: key, listnerId: mListnerId)
                } else {
                        /* Allocate new observer */
                        let newobs = MIObjectListener()
                        mObservers[key] = newobs
                        newobs.add(listnerId: mListnerId, listenerFunction: lfunc)
                        result = ListnerHolder(key: key, listnerId: mListnerId)
                        /* Set the new observer to observe value table */
                        mValueTable.addObserver(newobs, forKeyPath: key, options: [.new], context: nil)
                }
                mListnerId += 1
                return result
        }

        public func countOfObservers(forKey key: String) -> Int {
                if let listner = mObservers[key] {
                        return listner.count
                } else {
                        return 0
                }
        }

        public func removeObserver(listnerHolder holderp: ListnerHolder?){
                guard let holder = holderp else {
                        return // ignore nil
                }
                if let listner = mObservers[holder.key] {
                        listner.remove(listnerId: holder.listnerId)
                        if listner.count == 0 {
                                /* remove empty listner */
                                mValueTable.removeObserver(listner, forKeyPath: holder.key)
                                mObservers[holder.key] = nil
                        }
                }
        }
}

private class MIObjectListener: NSObject
{
        public typealias ListenerFunction = (Any) -> Void        // new-value

        private var mListnerFunctions:        Dictionary<Int, ListenerFunction>

        public override init(){
                mListnerFunctions = [:]
        }

        public var count: Int { get {
                return mListnerFunctions.count
        }}

        public func add(listnerId lid: Int, listenerFunction lfunc: @escaping ListenerFunction){
                mListnerFunctions[lid] = lfunc
        }

        public func remove(listnerId lid: Int) {
                mListnerFunctions[lid] = nil
        }

        public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
                for lfunc in mListnerFunctions.values {
                        if let vals = change {
                                if let val = vals[.newKey] {
                                        lfunc(val)
                                } else {
                                        NSLog("changed is null (0)")
                                }
                        } else {
                                NSLog("changed is null (1)")
                        }
                }
        }
}
