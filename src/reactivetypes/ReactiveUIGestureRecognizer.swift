/*
 Copyright 2016-present The Material Motion Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import UIKit

public class ReactiveUIGestureRecognizer<O: UIGestureRecognizer> {
  public let gestureRecognizer: O

  public lazy var isEnabled: ReactiveProperty<Bool> = {
    let gestureRecognizer = self.gestureRecognizer
    return ReactiveProperty(initialValue: gestureRecognizer.isEnabled,
                            write: { gestureRecognizer.isEnabled = $0 })
  }()

  init(_ gestureRecognizer: O) {
    self.gestureRecognizer = gestureRecognizer
    self.stream = gestureToStream(gestureRecognizer)
  }

  fileprivate let stream: MotionObservable<O>
}

extension ReactiveUIGestureRecognizer: MotionObservableConvertible {
  public func asStream() -> MotionObservable<O> {
    return stream
  }
}

extension ReactiveUIGestureRecognizer {
  public func centroidOnRecognition(in relativeView: UIView) -> MotionObservable<CGPoint> {
    return gestureToStream(gestureRecognizer).onRecognitionState(.recognized).centroid(in: relativeView)
  }
}

extension ReactiveUIGestureRecognizer where O: UIPanGestureRecognizer {
  public func velocityOnReleaseStream(in relativeView: UIView) -> MotionObservable<CGPoint> {
    return gestureToStream(gestureRecognizer).onRecognitionState(.ended).velocity(in: relativeView)
  }
}

extension ReactiveUIGestureRecognizer where O: UIRotationGestureRecognizer {
  public func velocityOnReleaseStream() -> MotionObservable<CGFloat> {
    return gestureToStream(gestureRecognizer).onRecognitionState(.ended).velocity()
  }
}

extension ReactiveUIGestureRecognizer where O: UIPinchGestureRecognizer {
  public func velocityOnReleaseStream() -> MotionObservable<CGFloat> {
    return gestureToStream(gestureRecognizer).onRecognitionState(.ended).velocity()
  }
}
