import UIKit
//Chapter 1

//1.1 The Fibonacci sequence
//1.1.1 A first recusvie attempt
// Infinite loop or infinite recursion issue. I don't know why they give this example
func fib1(n: UInt) -> UInt {
    return fib1(n: n-1) + fib1(n: n-2);
}

//1.1.2 Utilizing base cases

func fib2(n: UInt) -> UInt {
    if (n < 2) {
        return n
    }
    return fib2(n: n - 2) + fib2(n: n - 1)
}

fib2(n: 5)
fib2(n: 10)
//not very efficient - every non base case call of fib2 results in two more calls of fib2

//1.1.3 Memoization
// Store results of computed tasks so that when they are complete, they are not recalcuated if asked for again.

var fibMemo : [UInt: UInt] = [0:0, 1:1] // our base cases
func fib3(n: UInt) -> UInt {
    if let result = fibMemo[n] { // new base case
        return result
    } else {
        fibMemo[n] = fib3(n: n - 1) + fib3(n: n - 2) //memoization (storing computed values
    }
    return fibMemo[n]!
}

fib3(n: 5)
fib3(n: 10)
fib3(n: 50)

//1.1.4 Keeping it simple

func fib4(n: UInt) -> UInt {
    if (n == 0) { //special case
        return n
    }
    var last: UInt = 0, next: UInt = 1
    for _ in 1..<n {
        (last, next) = (next, last + next)
    }
    return next
}

// dumb tuple example but whatever.

fib4(n: 5)
fib4(n: 10)
fib4(n: 50)
