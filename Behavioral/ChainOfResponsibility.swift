//
//  ChainOfResponsibility.swift
//  
//
//  Created by Admin on 8/10/18.
//

import Foundation

final class MoneyPile{
    let value: Int
    let quantity: Int
    var next: MoneyPile?
    
    init(value: Int, quantity: Int, next: MoneyPile? = nil) {
        self.value = value
        self.quantity = quantity
        self.next = next
    }
    
    //this code was not modfied.
    //TODO: modify this code 
    func canWithdraw(amount: Int) -> Bool {
        
        var amount = amount
        
        func canTakeSomeBill(want: Int) -> Bool {
            return (want / self.value) > 0
        }
        
        var quantity = self.quantity
        
        while canTakeSomeBill(want: amount) {
            
            if quantity == 0 {
                break
            }
            
            amount -= self.value
            quantity -= 1
        }
        
        guard amount > 0 else {
            return true
        }
        
        if let next = self.next {
            return next.canWithdraw(amount: amount)
        }
        return false
    }
}

final class ATMBuilder{
    let head: MoneyPile
    var current: MoneyPile?
    
    init(head: MoneyPile) {
        self.head = head
        self.current = head
    }
    
    func next(pile: MoneyPile?) -> ATMBuilder{
        current?.next = pile
        current = pile
        return self
    }
}

final class ATM{
    let sentinel: MoneyPile
    
    init(builder: ATMBuilder) {
        self.sentinel = builder.head
    }
    
    //print out values
    func printOut(){
        var starter = sentinel
        print(starter.value)
        while starter.next != nil {
            starter = starter.next!
            print(starter.value)
        }
    }
    
    lazy var testInputs: ([Int])->() = {
        let allResults = $0.map{ self.sentinel.canWithdraw(amount: $0) }
        self.printClosure(allResults)
    }
    
    let printClosure: ([Bool]) -> () = {
        $0.forEach{ print($0) }
    }
}

let ten = MoneyPile(value: 10, quantity: 6)
let twenty = MoneyPile(value: 20, quantity: 2)
let fifty = MoneyPile(value: 50, quantity: 2)
let hundred = MoneyPile(value: 100, quantity: 1)


let atmBuilder = ATMBuilder(head: hundred)
    .next(pile: fifty)
    .next(pile: twenty)
    .next(pile: ten)

let atm = ATM(builder: atmBuilder)
atm.printOut()
let inputs = [310, 100, 165, 30]
atm.testInputs(inputs)
