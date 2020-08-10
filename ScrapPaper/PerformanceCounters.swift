// Copyright © 2020 Brian's Brain. All rights reserved.

import Foundation

final public class PerformanceCounters: ObservableObject {
  struct Record {
    var count: Int = 0
    var sum: Double = 0.0
    var sumOfSquares: Double = 0.0

    mutating func addObservation(_ observation: Double) {
      count += 1
      sum += observation
      sumOfSquares += observation * observation
    }

    var mean: Double {
      sum / Double(count)
    }

    var variance: Double {
      sumOfSquares - (sum * sum) / Double(count)
    }

    var standardDeviation: Double {
      sqrt(variance)
    }
  }

  static let shared = PerformanceCounters()

  @Published private(set) var counters: [String: Record] = [:]

  public func addObservation(_ observation: Double, forKey key: String) {
    if counters[key] == nil {
      counters[key] = Record()
    }
    counters[key]?.addObservation(observation)
  }
}
