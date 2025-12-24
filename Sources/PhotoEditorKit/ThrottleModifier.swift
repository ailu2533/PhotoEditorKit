//
//  ThrottleModifier.swift
//  GPUImage3Learning
//
//  Created by Lu Ai on 2025/11/17.
//

//import AsyncAlgorithms
import Combine
import SwiftUI

struct ThrottleModifier<Value: Equatable>: ViewModifier {
    @State private var subject = PassthroughSubject<Value, Never>()

    let value: Value
    let interval: Duration
    let action: (Value) -> Void

    private var timeInterval: TimeInterval {
        let components = interval.components
        return Double(components.seconds) + Double(components.attoseconds) / 1e18
    }

    func body(content: Content) -> some View {
        content
            .onChange(of: value) { _, newValue in
                subject.send(newValue)
            }
            .onReceive(subject.throttle(for: .seconds(timeInterval), scheduler: RunLoop.main, latest: true)) { newValue in
                action(newValue)
            }
    }
}

extension View {
    /// Throttles changes to a value and performs an action.
    ///
    /// - Parameters:
    ///   - value: The value to observe for changes.
    ///   - interval: The interval to throttle updates.
    ///   - action: The action to perform with the throttled value.
    func onThrottle<Value: Equatable>(
        of value: Value,
        interval: Duration = .milliseconds(200),
        perform action: @escaping (Value) -> Void
    ) -> some View {
        modifier(ThrottleModifier(value: value, interval: interval, action: action))
    }
}
