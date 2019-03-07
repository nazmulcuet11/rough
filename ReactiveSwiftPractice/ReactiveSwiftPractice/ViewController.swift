//
//  ViewController.swift
//  ReactiveSwiftPractice
//
//  Created by Nazmul Islam on 2/20/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        letsLearnSignal()

        createSignalInAnotherWay()

//        transformedSignal()

//        stopAutoDisposal(id: 1)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0, execute: {
//            self.stopAutoDisposal(id: 2)
//        })

//        letsLearnHoockedObserver()

//        signalProducerBasic()

//        letsUnderstandFlatMap()

//        callChainedSignalProducer()
    }

    // MARK :- Signal
    func letsLearnSignal() {
        let signal = Signal<Int, NoError>({ observer, lifetime in
            for i in 1...15 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i), execute: {
                    if !lifetime.hasEnded {
                        print()
                        print("🔊 Sendig Signal with value: \(i)")
                    }
                    observer.send(value: i)
                    if i == 7 {
//                        observer.sendCompleted()
                    }
                })
            }

            lifetime.observeEnded {
                print("Signal Died. :'(")
            }
        })

        let observerOne = Signal<Int, NoError>.Observer(value: { value in
            print("👩‍🎤 ObserverOne:: Received signal with value: \(value)")
        }, failed: { error in
            print("👩‍🎤 ObserverOne:: \(error)")
        }, completed: {
            print("👩‍🎤 ObserverOne:: Signal Completed.")
        }, interrupted: {
            print("👩‍🎤 ObserverOne:: Signal Inturrupted.")
        })

        let observerTwo = Signal<Int, NoError>.Observer(value: { value in
            print("👩🏼‍💼 ObserverTwo:: Received signal with value: \(value)")
        }, failed: { error in
            print("👩🏼‍💼 ObserverTwo:: \(error)")
        }, completed: {
            print("👩🏼‍💼 ObserverTwo:: Signal Completed.")
        }, interrupted: {
            print("👩🏼‍💼 ObserverTwo:: Signal Inturrupted.")
        })

        var disposaableOne: Disposable?
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            disposaableOne = signal.observe(observerOne)
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            disposaableOne?.dispose()
        })

        var disposableTwo: Disposable?
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            disposableTwo = signal.observe(observerTwo)
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 12.0, execute: {
            disposableTwo?.dispose()
        })
    }

    func createSignalInAnotherWay() {
        let (signal, observer) = Signal<Int, NoError>.pipe()
        var signalTerminated = false
        let __disposable = signal.observe({ event in
            switch event {
            case .completed, .interrupted:
                print("Signal Died.:'(")
                signalTerminated = true
            default:
                break
            }
        })
        for i in 1...15 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i), execute: {
                if !signalTerminated {
                    print()
                    print("🔊 Sendig Signal with value: \(i)")
                }
                observer.send(value: i)
                if i == 7 {
                    observer.sendCompleted()
                }
            })
        }

        let signalObserver = Signal<Int, NoError>.Observer(value: { value in
            print("🐙 SignalObserver:: Received signal with value: \(value)")
        }, failed: { error in
            print("🐙 SignalObserver:: \(error)")
        }, completed: {
            print("🐙 SignalObserver:: Signal Completed.")
        }, interrupted: {
            print("🐙 SignalObserver:: Signal Inturrupted.")
        })

//        signal.observe({ event in
//            print("Observed in another way. Event: \(event)")
//        })

        var disposaable: Disposable?
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            disposaable = signal.observe(signalObserver)
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            disposaable?.dispose()
            __disposable?.dispose()
        })
    }

    func transformedSignal() {
        let integerSignal = Signal<Int, NoError>({ observer, lifetime in
            for i in 1...5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i), execute: {
                    if !lifetime.hasEnded {
                        print()
                        print("🔊 Sendig Signal with value: \(i)")
                    }
                    observer.send(value: i)
                })
            }
        })

        let stringSignal: Signal<String, NoError> = integerSignal.map({ (interger: Int) -> Double in
            let doubleValue = Double(interger)*2.0
            print("🐛 Transforming from Int to Double.. preveious value: \(interger), newValue: \(doubleValue)")
            return doubleValue
        }).map({ (double: Double) -> String in
            let stringValue = "Transformed value: \(double)"
            print("🦋 Transforming from Double to String.. preveious value: \(double), newValue: \(stringValue)")
            return stringValue
        })

        let signalObserver = Signal<String, NoError>.Observer(value: { value in
            print("🦑 SignalObserver:: Received signal with value: \(value)")
        }, failed: { error in
            print("🦑 SignalObserver:: \(error)")
        }, completed: {
            print("🦑 SignalObserver:: Signal Completed.")
        }, interrupted: {
            print("🦑 SignalObserver:: Signal Inturrupted.")
        })

        stringSignal.observe(signalObserver)
    }

    let (retainedSignal, retainedObserver) = Signal<Int, NoError>.pipe()
    func stopAutoDisposal(id: Int) {
        var signalTerminated = false
        retainedSignal.observe({ event in
            switch event {
            case .completed, .interrupted:
                print("Signal Died.:'(")
                signalTerminated = true
            default:
                break
            }
        })
        for i in 1...5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i), execute: {
                if !signalTerminated {
                    print()
                    print("🔊 Sendig Signal with value: \(i)")
                }
                self.retainedObserver.send(value: i)
            })
        }

        let retainedSignalObserver = Signal<Int, NoError>.Observer(value: { value in
            print("🧘‍♂️ RetainedSignalObserver \(id):: Received signal with value: \(value)")
        }, failed: { error in
            print("🧘‍♂️ RetainedSignalObserver \(id):: \(error)")
        }, completed: {
            print("🧘‍♂️ RetainedSignalObserver \(id):: Signal Completed.")
        }, interrupted: {
            print("🧘‍♂️ RetainedSignalObserver \(id):: Signal Inturrupted.")
        })
        let disposable = retainedSignal.observe(retainedSignalObserver)

        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            disposable?.dispose()
        })
    }

    func letsLearnHoockedObserver() {
        let firstSignal = Signal<Int, NoError> { observer, lifetime in
            for i in 1...5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i), execute: {
                    if !lifetime.hasEnded {
                        print()
                        print("🔊 First Signal Sendig value: \(i)")
                    }

                    observer.send(value: i)
                })
            }

            lifetime.observeEnded {
                print("First Signal Died.")
            }
        }

        let hookedSignal = Signal<Int, NoError> { observer, lifetime in
            //lifetime += firstSignal.observe(observer)
//            firstSignal.observe(observer)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 7.0, execute: {
//                firstSignal.observe(observer)
//                lifetime += firstSignal.observe(observer)
//            })

            firstSignal.observeValues({ value in
                observer.send(value: value)
            })

            for i in 1...7 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) + 2.0, execute: {
                    if !lifetime.hasEnded {
                        print()
                        print("📢 Hooked Signal Sendig value: \(i)")
                    }
                    observer.send(value: i)
                })
            }

            lifetime.observeEnded {
                print("Hooked Signal Died.")
            }
        }

        let firstObserver = Signal<Int, NoError>.Observer(value: { value in
            print("🐸 FirstObserver:: Received signal with value: \(value)")
        }, failed: { error in
            print("🐸 FirstObserver:: \(error)")
        }, completed: {
            print("🐸 FirstObserver:: Signal Completed.")
        }, interrupted: {
            print("🐸 FirstObserver:: Signal Inturrupted.")
        })

        firstSignal.observe(firstObserver)

        let hookedObserver = Signal<Int, NoError>.Observer(value: { value in
            print("🔱 HookedObserver:: Received signal with value: \(value)")
        }, failed: { error in
            print("🔱 HookedObserver:: \(error)")
        }, completed: {
            print("🔱 HookedObserver:: Signal Completed.")
        }, interrupted: {
            print("🔱 HookedObserver:: Signal Inturrupted.")
        })

        hookedSignal.observe(hookedObserver)
    }

    // MARK : Signal Prducer

    func signalProducerBasic() {

        let signal = Signal<Int, NoError> { observer, lifetime in
            for i in 1...5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i), execute: {
                    if !lifetime.hasEnded {
                        print()
                        print("🔊 Signal Sendig value: \(i)")
                    }
                    observer.send(value: i)
                })
            }
        }

        let producer = SignalProducer<Int, NoError> { observer, lifetime in
            for i in 1...5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i), execute: {
                    if !lifetime.hasEnded {
                        print()
                        print("🔊 Signal Producer Sendig value: \(i)")
                    }
                    observer.send(value: i)
                })
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            signal.observeValues({ value in
                print("Signal's value: \(value)")
            })

            producer.startWithValues({ value in
                print("SignalProducer's value: \(value)")
            })
        })
    }

    func letsUnderstandFlatMap() {
        var startTime = Date()

        startTime = Date()
        let producerOne = SignalProducer<Int, NoError> { observer, lifetime in
            let startAt = 0
            let interVal = 1
            for i in 1...3 {
                let value = Double(startAt) + Double(i-1)*Double(interVal)
                DispatchQueue.main.asyncAfter(deadline: .now() + value, execute: {
                    let elapsedTime = Int(Date().timeIntervalSince(startTime))
                    if !lifetime.hasEnded {
                        print("  ❗️ At second \(elapsedTime) Signal 1 Sending Value \(i)")
                    }

                    observer.send(value: i)
                })
            }

            let value = 11.0
            DispatchQueue.main.asyncAfter(deadline: .now() + value, execute: {
                let elapsedTime = Int(Date().timeIntervalSince(startTime))
                print("  ❗️ At second \(elapsedTime) Signal 1 Sending Value \(value)")
                observer.send(value: Int(value))
            })

            lifetime.observeEnded {
                let elapsedTime = Int(Date().timeIntervalSince(startTime))
                print("  ❗️ Signal 1 Died at \(elapsedTime) seconds.")
            }
        }

        startTime = Date()
        let producerTwo = SignalProducer<Int, NoError> { observer, lifetime in
            let startAt = 0
            let interVal = 3
            for i in 1...2 {
                let value = Double(startAt) + Double(i-1)*Double(interVal)
                DispatchQueue.main.asyncAfter(deadline: .now() + value, execute: {
                    let elapsedTime = Int(Date().timeIntervalSince(startTime))
                    if !lifetime.hasEnded {
                        print("❗️❗️ At second \(elapsedTime) Signal 2 Sending Value \(i)")
                    }

                    observer.send(value: i)

                    if i == 2 {
                        observer.sendCompleted()
                    }
                })
            }

            lifetime.observeEnded {
                let elapsedTime = Int(Date().timeIntervalSince(startTime))
                print("❗️❗️ Signal 2 Died at \(elapsedTime) seconds.")
            }
        }

//        print("... MERGE ...")
//        print("calling producer 1")
//        producerOne
//            .flatMap(.merge) { value -> SignalProducer<Int, NoError> in
//                print("Recevied \(value) from producer 1, calling producer 2")
//                return producerTwo
//            }
//            .startWithValues { value in
//                print(value)
//        }

//        print("... CONCAT ...")
//        print("calling producer 1")
//        producerOne
//            .flatMap(.concat) { value -> SignalProducer<Int, NoError> in
//                print("Recevied \(value) from producer 1, calling producer 2")
//                return producerTwo
//            }
//            .startWithValues { value in
//                print(value)
//        }

        print("... LATEST ...")
        print("calling producer 1")
        producerOne
            .flatMap(.latest) { value -> SignalProducer<Int, NoError> in
                print("Recevied \(value) from producer 1, calling producer 2")
                return producerTwo
            }
            .startWithValues { value in
                print(value)
        }
    }

    func increaseByTen(value receivedValue: Int, success: @escaping (_ value: Int) -> Void, failure: () -> Void) {
        print("increaseByTen:: I promise your value will be increased by ten. Don't know when!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            success(receivedValue + 10)
        })
    }

    enum MyCustomError: Error {
        case requestTimedOut
        case hudai
    }

    func getSignalProducerFromAsyncFunc(value receivedValue: Int) -> SignalProducer<Int, MyCustomError> {
        return SignalProducer { [weak self] observer, lifetime in
            self?.increaseByTen(value: receivedValue, success: { value in
                observer.send(value: value)
                observer.sendCompleted()
            }, failure: {
                print("myAsyncFunc Failed. I don't know why!")
                observer.send(error: .hudai)
                observer.sendCompleted()
            })
        }
        .timeout(after: 6, raising: MyCustomError.requestTimedOut, on: QueueScheduler())
        .retry(upTo: 1)
    }

    func getChainedSignalProducer() -> SignalProducer<String, MyCustomError> {
        return getSignalProducerFromAsyncFunc(value: 0)
            .flatMap(.latest) { (value: Int) -> SignalProducer<Int, MyCustomError> in
                print("Value after level one: \(value)")
                return self.getSignalProducerFromAsyncFunc(value: value)
            }
            .flatMap(.latest) { (value: Int) -> SignalProducer<Int, MyCustomError> in
                print("Value after level two: \(value)")
                return self.getSignalProducerFromAsyncFunc(value: value)
            }
            .flatMap(.latest) { (value: Int) -> SignalProducer<Int, MyCustomError> in
                print("Value after level three: \(value)")
                return self.getSignalProducerFromAsyncFunc(value: value)
            }
            .flatMap(.latest) { (value: Int) -> SignalProducer<String, MyCustomError> in
                print("Value after level four: \(value)")
                return SignalProducer { observer, lifetime in
                    observer.send(value: "Value received: \(value)")
                    observer.sendCompleted()
                }
            }
            .timeout(after: 10, raising: MyCustomError.requestTimedOut, on: QueueScheduler())
            .retry(upTo: 2)

        /*
        return getSignalProducerFromAsyncFunc(value: 0)
            .map { (value: Int) -> SignalProducer<Int, NoError> in
                return self.getSignalProducerFromAsyncFunc(value: value)
            }.map { (value: Int) -> SignalProducer<Int, NoError> in
                return self.getSignalProducerFromAsyncFunc(value: value)
            }.map { (value: Int) -> SignalProducer<Int, NoError> in
                return self.getSignalProducerFromAsyncFunc(value: value)
            }.map { (value: Int) -> SignalProducer<String, NoError> in
                return SignalProducer { observer, lifetime in
                    observer.send(value: "Value received: \(value)")
                }
        }
        */
    }

    func callChainedSignalProducer() {
        getChainedSignalProducer().startWithResult({ result in
            print("Result: \(result)")
        })

        var a = 10 + 15
        print(a)
    }
}
