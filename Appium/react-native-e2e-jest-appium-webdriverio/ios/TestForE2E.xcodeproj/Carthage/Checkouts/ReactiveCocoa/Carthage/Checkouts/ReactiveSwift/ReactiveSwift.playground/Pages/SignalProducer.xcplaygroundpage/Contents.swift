/*:
> # IMPORTANT: To use `ReactiveSwift.playground`, please:

1. Retrieve the project dependencies using one of the following terminal commands from the ReactiveSwift project root directory:
    - `git submodule update --init`
 **OR**, if you have [Carthage](https://github.com/Carthage/Carthage) installed
    - `carthage checkout`
1. Open `ReactiveSwift.xcworkspace`
1. Build `ReactiveSwift-macOS` scheme
1. Finally open the `ReactiveSwift.playground`
1. Choose `View > Show Debug Area`
*/

import ReactiveSwift
import Foundation

/*:
## SignalProducer

A **signal producer**, represented by the [`SignalProducer`](https://github.com/ReactiveCocoa/ReactiveSwift/blob/master/Sources/SignalProducer.swift) type, creates
[signals](https://github.com/ReactiveCocoa/ReactiveSwift/blob/master/Sources/Signal.swift) and performs side effects.

They can be used to represent operations or tasks, like network
requests, where each invocation of `start()` will create a new underlying
operation, and allow the caller to observe the result(s). The
`startWithSignal()` variant gives access to the produced signal, allowing it to
be observed multiple times if desired.

Because of the behavior of `start()`, each signal created from the same
producer may see a different ordering or version of events, or the stream might
even be completely different! Unlike a plain signal, no work is started (and
thus no events are generated) until an observer is attached, and the work is
restarted anew for each additional observer.

Starting a signal producer returns a [disposable](https://github.com/ReactiveCocoa/ReactiveSwift/blob/master/Sources/Disposable.swift) that can be used to
interrupt/cancel the work associated with the produced signal.

Just like signals, signal producers can also be manipulated via primitives
like `map`, `filter`, etc.
Every signal primitive can be “lifted” to operate upon signal producers instead,
using the `lift` method.
Furthermore, there are additional primitives that control _when_ and _how_ work
is started—for example, `times`.
*/

/*:
### `Subscription`
A SignalProducer represents an operation that can be started on demand. Starting the operation returns a Signal on which the result(s) of the operation can be observed. This behavior is sometimes also called "cold".
This means that a subscriber will never miss any values sent by the SignalProducer.
*/
scopedExample("Subscription") {
	let producer = SignalProducer<Int, Never> { observer, _ in
		print("New subscription, starting operation")
		observer.send(value: 1)
		observer.send(value: 2)
	}

	let subscriber1 = Signal<Int, Never>.Observer(value: { print("Subscriber 1 received \($0)") })
	let subscriber2 = Signal<Int, Never>.Observer(value: { print("Subscriber 2 received \($0)") })

	print("Subscriber 1 subscribes to producer")
	producer.start(subscriber1)

	print("Subscriber 2 subscribes to producer")
	// Notice, how the producer will start the work again
	producer.start(subscriber2)
}

/*:
### `empty`
A producer for a Signal that will immediately complete without sending
any values.
*/
scopedExample("`empty`") {
	let emptyProducer = SignalProducer<Int, Never>.empty

	let observer = Signal<Int, Never>.Observer(
		value: { _ in print("value not called") },
		failed: { _ in print("error not called") },
		completed: { print("completed called") }
	)

	emptyProducer.start(observer)
}

/*:
### `never`
A producer for a Signal that never sends any events to its observers.
*/
scopedExample("`never`") {
	let neverProducer = SignalProducer<Int, Never>.never

	let observer = Signal<Int, Never>.Observer(
		value: { _ in print("value not called") },
		failed: { _ in print("error not called") },
		completed: { print("completed not called") }
	)

	neverProducer.start(observer)
}

/*:
### `startWithSignal`
Creates a Signal from the producer, passes it into the given closure,
then starts sending events on the Signal when the closure has returned.

The closure will also receive a disposable which can be used to
interrupt the work associated with the signal and immediately send an
`Interrupted` event.
*/
scopedExample("`startWithSignal`") {
	var started = false
	var value: Int?

	SignalProducer<Int, Never>(value: 42)
		.on(value: {
			value = $0
		})
		.startWithSignal { signal, disposable in
			print(value)
		}

	print(value)
}

/*:
### `startWithResult`
Creates a Signal from the producer, then adds exactly one observer to
the Signal, which will invoke the given callback when `value` or `failed`
events are received.

Returns a Disposable which can be used to interrupt the work associated
with the Signal, and prevent any future callbacks from being invoked.
*/
scopedExample("`startWithResult`") {
	SignalProducer<Int, Never>(value: 42)
		.startWithResult { result in
			print(result)
		}
}

/*:
### `startWithValues`
Creates a Signal from the producer, then adds exactly one observer to
the Signal, which will invoke the given callback when `value` events are
received.

This method is available only if the producer never emits error, or in
other words, has an error type of `Never`.

Returns a Disposable which can be used to interrupt the work associated
with the Signal, and prevent any future callbacks from being invoked.
*/
scopedExample("`startWithValues`") {
	SignalProducer<Int, Never>(value: 42)
		.startWithValues { value in
			print(value)
		}
}

/*:
### `startWithCompleted`
Creates a Signal from the producer, then adds exactly one observer to
the Signal, which will invoke the given callback when a `completed` event is
received.

Returns a Disposable which can be used to interrupt the work associated
with the Signal.
*/
scopedExample("`startWithCompleted`") {
	SignalProducer<Int, Never>(value: 42)
		.startWithCompleted {
			print("completed called")
		}
}

/*:
### `startWithFailed`
Creates a Signal from the producer, then adds exactly one observer to
the Signal, which will invoke the given callback when a `failed` event is
received.

Returns a Disposable which can be used to interrupt the work associated
with the Signal.
*/
scopedExample("`startWithFailed`") {
	SignalProducer<Int, NSError>(error: NSError(domain: "example", code: 42, userInfo: nil))
		.startWithFailed { error in
			print(error)
		}
}

/*:
### `startWithInterrupted`
Creates a Signal from the producer, then adds exactly one observer to
the Signal, which will invoke the given callback when an `interrupted` event
is received.

Returns a Disposable which can be used to interrupt the work associated
with the Signal.
*/
scopedExample("`startWithInterrupted`") {
	let disposable = SignalProducer<Int, Never>.never
		.startWithInterrupted {
			print("interrupted called")
		}

	disposable.dispose()
}


/*:
### `lift`
Lifts an unary Signal operator to operate upon SignalProducers instead.

In other words, this will create a new SignalProducer which will apply
the given Signal operator to _every_ created Signal, just as if the
operator had been applied to each Signal yielded from start().
*/
scopedExample("`lift`") {
	var counter = 0
	let transform: (Signal<Int, Never>) -> Signal<Int, Never> = { signal in
		counter = 42
		return signal
	}

	SignalProducer<Int, Never>(value: 0)
		.lift(transform)
		.startWithValues { _ in
			print(counter)
		}
}

/*:
### `map`
Maps each value in the producer to a new value.
*/
scopedExample("`map`") {
	SignalProducer<Int, Never>(value: 1)
		.map { $0 + 41 }
		.startWithValues { value in
			print(value)
		}
}

/*:
### `mapError`
Maps errors in the producer to a new error.
*/
scopedExample("`mapError`") {
	SignalProducer<Int, NSError>(error: NSError(domain: "mapError", code: 42, userInfo: nil))
		.mapError { PlaygroundError.example($0.description) }
		.startWithFailed { error in
			print(error)
		}
}

/*:
### `filter`
Preserves only the values of the producer that pass the given predicate.
*/
scopedExample("`filter`") {
	SignalProducer<Int, Never>([ 1, 2, 3, 4 ])
		.filter { $0 > 3 }
		.startWithValues { value in
			print(value)
		}
}

/*:
### `take(first:)`
Returns a producer that will yield the first `count` values from the
input producer.
*/
scopedExample("`take(first:)`") {
	SignalProducer<Int, Never>([ 1, 2, 3, 4 ])
		.take(first: 2)
		.startWithValues { value in
			print(value)
		}
}

/*:
### `observe(on:)`
Forwards all events onto the given scheduler, instead of whichever
scheduler they originally arrived upon.
*/
scopedExample("`observe(on:)`") {
	let baseProducer = SignalProducer<Int, Never>([ 1, 2, 3, 4 ])
	let completion = { print("is main thread? \(Thread.current.isMainThread)") }

	baseProducer
		.observe(on: QueueScheduler(qos: .default, name: "test"))
		.startWithCompleted(completion)

	baseProducer
		.startWithCompleted(completion)
}

/*:
### `collect`
Returns a producer that will yield an array of values until it completes.
*/
scopedExample("`collect`") {
	SignalProducer<Int, Never> { observer, disposable in
		observer.send(value: 1)
		observer.send(value: 2)
		observer.send(value: 3)
		observer.send(value: 4)
		observer.sendCompleted()
	}
		.collect()
		.startWithValues { value in
			print(value)
		}
}

/*:
### `collect(count:)`
Returns a producer that will yield an array of values until it reaches a certain count.
*/
scopedExample("`collect(count:)`") {
	SignalProducer<Int, Never> { observer, disposable in
		observer.send(value: 1)
		observer.send(value: 2)
		observer.send(value: 3)
		observer.send(value: 4)
		observer.sendCompleted()
	}
		.collect(count: 2)
		.startWithValues { value in
			print(value)
		}
}

/*:
### `collect(_:)` matching values inclusively
Returns a producer that will yield an array of values based on a predicate
which matches the values collected.

When producer completes any remaining values will be sent, the last values
array may not match `predicate`. Alternatively, if were not collected any
values will sent an empty array of values.
*/
scopedExample("`collect(_:)` matching values inclusively") {
	SignalProducer<Int, Never> { observer, disposable in
		observer.send(value: 1)
		observer.send(value: 2)
		observer.send(value: 3)
		observer.send(value: 4)
		observer.sendCompleted()
	}
		.collect { values in values.reduce(0, +) == 3 }
		.startWithValues { value in
			print(value)
		}
}

/*:
### `collect(_:)` matching values exclusively
Returns a producer that will yield an array of values based on a predicate
which matches the values collected and the next value.

When producer completes any remaining values will be sent, the last values
array may not match `predicate`. Alternatively, if were not collected any
values will sent an empty array of values.
*/
scopedExample("`collect(_:)` matching values exclusively") {
	SignalProducer<Int, Never> { observer, disposable in
		observer.send(value: 1)
		observer.send(value: 2)
		observer.send(value: 3)
		observer.send(value: 4)
		observer.sendCompleted()
	}
		.collect { values, next in next == 3 }
		.startWithValues { value in
			print(value)
		}
}

/*:
### `combineLatest(with:)`
Combines the latest value of the receiver with the latest value from
the given producer.

The returned producer will not send a value until both inputs have sent at
least one value each. If either producer is interrupted, the returned producer
will also be interrupted.
*/
scopedExample("`combineLatest(with:)`") {
	let producer1 = SignalProducer<Int, Never>([ 1, 2, 3, 4 ])
	let producer2 = SignalProducer<Int, Never>([ 1, 2 ])

	producer1
		.combineLatest(with: producer2)
		.startWithValues { value in
			print("\(value)")
		}
}

/*:
### `skip(first:)`
Returns a producer that will skip the first `count` values, then forward
everything afterward.
*/
scopedExample("`skip(first:)`") {
	SignalProducer<Int, Never>([ 1, 2, 3, 4 ])
		.skip(first: 2)
		.startWithValues { value in
			print(value)
		}
}

/*:
### `materialize`

Treats all Events from the input producer as plain values, allowing them to be
manipulated just like any other value.

In other words, this brings Events “into the monad.”

When a Completed or Failed event is received, the resulting producer will send
the Event itself and then complete. When an Interrupted event is received,
the resulting producer will send the Event itself and then interrupt.
*/
scopedExample("`materialize`") {
	SignalProducer<Int, Never>([ 1, 2, 3, 4 ])
		.materialize()
		.startWithValues { value in
			print(value)
		}
}

/*:
 ### `materializeResults`

 Treats all Results from the input producer as plain values, allowing them
 to be manipulated just like any other value.

 In other words, this brings Results “into the monad.”

 When a Failed event is received, the resulting producer will
 send the `Result.failure` itself and then complete.
 */
scopedExample("`materializeResults`") {
    SignalProducer<Int, Never>([ 1, 2, 3, 4 ])
        .materializeResults()
        .startWithValues { value in
            print(value)
    }
}

/*:
### `sample(on:)`
Forwards the latest value from `self` whenever `sampler` sends a `value`
event.

If `sampler` fires before a value has been observed on `self`, nothing
happens.

Returns a producer that will send values from `self`, sampled (possibly
multiple times) by `sampler`, then complete once both input producers have
completed, or interrupt if either input producer is interrupted.
*/
scopedExample("`sample(on:)`") {
	let baseProducer = SignalProducer<Int, Never>([ 1, 2, 3, 4 ])
	let sampledOnProducer = SignalProducer<Int, Never>([ 1, 2 ])
		.map { _ in () }

	baseProducer
		.sample(on: sampledOnProducer)
		.startWithValues { value in
			print(value)
		}
}

/*:
### `combinePrevious`
Forwards events from `self` with history: values of the returned producer
are a tuple whose first member is the previous value and whose second member
is the current value. `initial` is supplied as the first member when `self`
sends its first value.
*/
scopedExample("`combinePrevious`") {
	SignalProducer<Int, Never>([ 1, 2, 3, 4 ])
		.combinePrevious(42)
		.startWithValues { value in
			print("\(value)")
		}
}

/*:
### `scan`
Aggregates `self`'s values into a single combined value. When `self` emits
its first value, `combine` is invoked with `initial` as the first argument and
that emitted value as the second argument. The result is emitted from the
producer returned from `scan`. That result is then passed to `combine` as the
first argument when the next value is emitted, and so on.
*/
scopedExample("`scan`") {
	SignalProducer<Int, Never>([ 1, 2, 3, 4 ])
		.scan(0, +)
		.startWithValues { value in
			print(value)
		}
}

/*:
### `reduce`
Like `scan`, but sends only the final value and then immediately completes.
*/
scopedExample("`reduce`") {
	SignalProducer<Int, Never>([ 1, 2, 3, 4 ])
		.reduce(0, +)
		.startWithValues { value in
			print(value)
		}
}

/*:
### `skipRepeats`
Forwards only those values from `self` which do not pass `isRepeat` with
respect to the previous value. The first value is always forwarded.
*/
scopedExample("`skipRepeats`") {
	SignalProducer<Int, Never>([ 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 1, 1, 1, 2, 2, 2, 4 ])
		.skipRepeats(==)
		.startWithValues { value in
			print(value)
		}
}

/*:
### `skip(while:)`
Does not forward any values from `self` until `predicate` returns false,
at which point the returned signal behaves exactly like `self`.
*/
scopedExample("`skip(while:)`") {
	// Note that trailing closure is used for `skip(while:)`.
	SignalProducer<Int, Never>([ 3, 3, 3, 3, 1, 2, 3, 4 ])
		.skip { $0 > 2 }
		.startWithValues { value in
			print(value)
		}
}

/*:
### `take(untilReplacement:)`
Forwards events from `self` until `replacement` begins sending events.

Returns a producer which passes through `value`, `failed`, and `interrupted`
events from `self` until `replacement` sends an event, at which point the
returned producer will send that event and switch to passing through events
from `replacement` instead, regardless of whether `self` has sent events
already.
*/
scopedExample("`take(untilReplacement:)`") {
	let (replacementSignal, incomingReplacementObserver) = Signal<Int, Never>.pipe()

	let baseProducer = SignalProducer<Int, Never> { incomingObserver, _ in
		incomingObserver.send(value: 1)
		incomingObserver.send(value: 2)
		incomingObserver.send(value: 3)

		incomingReplacementObserver.send(value: 42)

		incomingObserver.send(value: 4)

		incomingReplacementObserver.send(value: 42)
	}

	baseProducer
		.take(untilReplacement: replacementSignal)
		.startWithValues { value in
			print(value)
		}
}

/*:
### `take(last:)`
Waits until `self` completes and then forwards the final `count` values
on the returned producer.
*/
scopedExample("`take(last:)`") {
	SignalProducer<Int, Never>([ 1, 2, 3, 4 ])
		.take(last: 2)
		.startWithValues { value in
			print(value)
		}
}

/*:
### `skipNil`
Unwraps non-`nil` values and forwards them on the returned signal, `nil`
values are dropped.
*/
scopedExample("`skipNil`") {
	SignalProducer<Int?, Never>([ nil, 1, 2, nil, 3, 4, nil ])
		.skipNil()
		.startWithValues { value in
			print(value)
		}
}


/*:
### `zip(with:)`
Zips elements of two producers into pairs. The elements of any Nth pair
are the Nth elements of the two input producers.
*/
scopedExample("`zip(with:)`") {
	let baseProducer = SignalProducer<Int, Never>([ 1, 2, 3, 4 ])
	let zippedProducer = SignalProducer<Int, Never>([ 42, 43 ])

	baseProducer
		.zip(with: zippedProducer)
		.startWithValues { value in
			print("\(value)")
		}
}

/*:
### `repeat`
Repeats `self` a total of `count` times. Repeating `1` times results in
an equivalent signal producer.
*/
scopedExample("`repeat`") {
	var counter = 0

	SignalProducer<(), Never> { observer, disposable in
		counter += 1
		observer.sendCompleted()
	}
		.repeat(42)
		.start()

	print(counter)
}

/*:
### `retry(upTo:)`
Ignores failures up to `count` times.
*/
scopedExample("`retry(upTo:)`") {
	var tries = 0

	SignalProducer<Int, NSError> { observer, disposable in
		if tries == 0 {
			tries += 1
			observer.send(error: NSError(domain: "retry", code: 0, userInfo: nil))
		} else {
			observer.send(value: 42)
			observer.sendCompleted()
		}
	}
		.retry(upTo: 1)
		.startWithResult { result in
			print(result)
		}
}

/*:
### `then`
Waits for completion of `producer`, *then* forwards all events from
`replacement`. Any failure sent from `producer` is forwarded immediately, in
which case `replacement` will not be started, and none of its events will be
be forwarded. All values sent from `producer` are ignored.
*/
scopedExample("`then`") {
	let baseProducer = SignalProducer<Int, Never>([ 1, 2, 3, 4 ])
	let thenProducer = SignalProducer<Int, Never>(value: 42)

	baseProducer
		.then(thenProducer)
		.startWithValues { value in
			print(value)
		}
}

/*:
### `replayLazily(upTo:)`
Creates a new `SignalProducer` that will multicast values emitted by
the underlying producer, up to `capacity`.
This means that all clients of this `SignalProducer` will see the same version
of the emitted values/errors.

The underlying `SignalProducer` will not be started until `self` is started
for the first time. When subscribing to this producer, all previous values
(up to `capacity`) will be emitted, followed by any new values.

If you find yourself needing *the current value* (the last buffered value)
you should consider using `PropertyType` instead, which, unlike this operator,
will guarantee at compile time that there's always a buffered value.
This operator is not recommended in most cases, as it will introduce an implicit
relationship between the original client and the rest, so consider alternatives
like `PropertyType`, `SignalProducer.buffer`, or representing your stream using
a `Signal` instead.

This operator is only recommended when you absolutely need to introduce
a layer of caching in front of another `SignalProducer`.

This operator has the same semantics as `SignalProducer.buffer`.
*/
scopedExample("`replayLazily(upTo:)`") {
	let baseProducer = SignalProducer<Int, Never>([ 1, 2, 3, 4, 42 ])
		.replayLazily(upTo: 2)

	baseProducer.startWithValues { value in
		print(value)
	}

	baseProducer.startWithValues { value in
		print(value)
	}

	baseProducer.startWithValues { value in
		print(value)
	}
}

/*:
### `flatMap(.latest)`
Maps each event from `self` to a new producer, then flattens the
resulting producers (into a producer of values), according to the
semantics of the given strategy.

If `self` or any of the created producers fail, the returned producer
will forward that failure immediately.
*/
scopedExample("`flatMap(.latest)`") {
	SignalProducer<Int, Never>([ 1, 2, 3, 4 ])
		.flatMap(.latest) { SignalProducer(value: $0 + 3) }
		.startWithValues { value in
			print(value)
		}
}

/*:
### `flatMapError`
Catches any failure that may occur on the input producer, mapping to a new producer
that starts in its place.
*/
scopedExample("`flatMapError`") {
	SignalProducer<Int, NSError>(error: NSError(domain: "flatMapError", code: 42, userInfo: nil))
		.flatMapError { SignalProducer<Int, Never>(value: $0.code) }
		.startWithValues { value in
			print(value)
		}
}

/*:
### `sample(with:)`
Forwards the latest value from `self` with the value from `sampler` as a tuple,
only when `sampler` sends a `value` event.

If `sampler` fires before a value has been observed on `self`, nothing happens.
Returns a producer that will send values from `self` and `sampler`,
sampled (possibly multiple times) by `sampler`, then complete once both
input producers have completed, or interrupt if either input producer is interrupted.
*/
scopedExample("`sample(with:)`") {
	let producer = SignalProducer<Int, Never>([ 1, 2, 3, 4 ])
	let sampler = SignalProducer<String, Never>([ "a", "b" ])

	let result = producer.sample(with: sampler)

	result.startWithValues { left, right in
		print("\(left) \(right)")
	}
}

/*:
### `logEvents`
Logs all events that the receiver sends.
By default, it will print to the standard output.
*/
scopedExample("`log events`") {
	let baseProducer = SignalProducer<Int, Never>([ 1, 2, 3, 4, 42 ])
	
 	baseProducer
 		.logEvents(identifier: "Playground is fun!")
 		.start()
}
