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

//1.2 Trivial compression
//nucleotide  makes up DNA, each nucleotide can be 1 of 4 values, A, C, G or T
//A is assigned 00
//C is assigned 01
//G is assigned 10
//T is assigned 11
// Storage size can be reduced by 75% (8 bits to 2 bits per nucleotide
struct CompressedGene {
    let length: Int
    private let bitVector: CFMutableBitVector
    
    init(original: String) {
        length = original.count
        // default allocator, need 2 * length number of bits
        bitVector = CFBitVectorCreateMutable(kCFAllocatorDefault, length * 2)
        CFBitVectorSetCount(bitVector, length * 2) //fills the bit vector with 0s
        compress(gene: original)
    }
    
    private func compress(gene: String) {
        for (index, nucleotide) in gene.uppercased().enumerated() {
            let nStart = index * 2 //start of each new nucleotide
            switch nucleotide {
            case "A":
                CFBitVectorSetBitAtIndex(bitVector, nStart, 0)
                CFBitVectorSetBitAtIndex(bitVector, nStart + 1, 0)
            case "C":
                CFBitVectorSetBitAtIndex(bitVector, nStart, 0)
                CFBitVectorSetBitAtIndex(bitVector, nStart + 1, 1)
            case "G":
                CFBitVectorSetBitAtIndex(bitVector, nStart, 1)
                CFBitVectorSetBitAtIndex(bitVector, nStart + 1, 0)
            case "T":
                CFBitVectorSetBitAtIndex(bitVector, nStart, 1)
                CFBitVectorSetBitAtIndex(bitVector, nStart + 1, 1)
            default:
                print("your nucleotide is invalid - character \(nucleotide) at \(index)")
            }
        }
    }
    
    func decompress() -> String {
        var gene: String = ""
        for index in 0..<length {
            let nStart = index * 2 //start of each nuc
            let firstBit = CFBitVectorGetBitAtIndex(bitVector, nStart)
            let secondBit = CFBitVectorGetBitAtIndex(bitVector, nStart + 1)
            switch (firstBit, secondBit) {
            case (0, 0):
                gene += "A"
            case (0, 1):
                gene += "C"
            case (1, 0):
                gene += "G"
            case (1, 1):
                gene += "T"
            default:
                break //things are bad if we get here
            }
        }
        return gene
    }
}

print(CompressedGene(original: "ATGAATGCC").decompress())


//1.3 Unbreakable encryption
//one time pad and stuff.
//1.3.1 Getting the data in order

typealias OTPKey = [UInt8]
typealias OTPKeyPair = (key1: OTPKey, key2: OTPKey)

func randomOTPKey(length: Int) -> OTPKey {
    var randomKey: OTPKey = OTPKey()
    for _ in 0..<length {
        let randomKeyPoint = UInt8(arc4random_uniform(UInt32(UInt8.max)))
        randomKey.append(randomKeyPoint)
    }
    return randomKey
}

//1.3.2 Encrypting and Decrypting
//XOR is a logical bitwise (operates at the bit level) operation that returns true when either operands are true, but not when both or neither are true

func encryptOTP(original: String) -> OTPKeyPair {
    let dummy = randomOTPKey(length: original.utf8.count)
    let encrypted: OTPKey = dummy.enumerated().map { i, e in
        return e ^ original.utf8[original.utf8.index(original.utf8.startIndex, offsetBy: i)] // in swift the XOR operation is ^
    }
    return (dummy, encrypted)
}

//enumerated is used before map so that we can get the index along with each e element that is being mapped. We need the index to pull specific bytes from the original String that corresponds to the bytes in the dummy data. We use startIndex and offsetBy instead of raw integers because the index type must match the expected type of the subscript

func decryptOTP(keyPair: OTPKeyPair) -> String? {
    let decrypted: OTPKey = keyPair.key1.enumerated().map { i, e in
        e ^ keyPair.key2[i]
    }
    return String(bytes: decrypted, encoding: String.Encoding.utf8)
}

decryptOTP(keyPair: encryptOTP(original: "herp-derp-malerp"))


//1.4 Calculating Pi
//pi = 4/1 - 4/3 + 4/5 - 4/7 + 4/9 - denoninator counts up by odd numbers, alternating + and -

func calculatePi(nTerms: UInt) -> Double {
    let numerator: Double = 4
    var denominator: Double = 1
    var operation: Double = -1
    var pi: Double = 0
    for _ in 0..<nTerms {
        pi += operation * (numerator / denominator)
        denominator += 2
        operation *= -1
    }
    return abs(pi) //abs = absolute value, always positive
}

//1.5 Towers of Hanoi (that game in the tomb on the evil planet in KOTOR where you had to shift the power around to pull down a force field so you could get some bad guy items.

//ie, 3 sticks, 3 disks on left stick, from largest to smallest at bottom. Goal is to move to the right stick in the same order, only one at a time can be moved.

// 1.5.1 Modelling the towers

public class Stack<T>: CustomStringConvertible {
    private var container: [T] = [T]()
    public func push(_ thing: T) { container.append(thing)}
    public func pop () -> T { return container.removeLast() }
    public var description: String {return container.description}
}

var numDiscs = 3
var towerA = Stack<Int>()
var towerB = Stack<Int>()
var towerC = Stack<Int>()
for i in 1...numDiscs {
    towerA.push(i)
}

//1.5.2 Solving the towers of hanoi
func hanoi(from: Stack<Int>, to: Stack<Int>, temp: Stack<Int>, n: Int) {
    if n == 1 { //base case
        to.push(from.pop()) // move one disk
    } else { //recursive case
        hanoi(from: from, to: temp, temp: to, n: n-1)
        hanoi(from: from, to: to, temp: temp, n: 1)
        hanoi(from: temp, to: to, temp: from, n: n-1)
    }
}

hanoi(from: towerA, to: towerC, temp: towerB, n: numDiscs)
print(towerA)
print(towerB)
print(towerC)


