//
//  File.swift
//  
//
//  Created by Adam Bell on 5/16/20.
//

import simd
import QuartzCore

public extension CATransform3D {

  init(_ matrix: matrix_double4x4) {
    self = CATransform3DIdentity
    self.m11 = CGFloat(matrix[0][0])
    self.m12 = CGFloat(matrix[0][1])
    self.m13 = CGFloat(matrix[0][2])
    self.m14 = CGFloat(matrix[0][3])

    self.m21 = CGFloat(matrix[1][0])
    self.m22 = CGFloat(matrix[1][1])
    self.m23 = CGFloat(matrix[1][2])
    self.m24 = CGFloat(matrix[1][3])

    self.m31 = CGFloat(matrix[2][0])
    self.m32 = CGFloat(matrix[2][1])
    self.m33 = CGFloat(matrix[2][2])
    self.m34 = CGFloat(matrix[2][3])

    self.m41 = CGFloat(matrix[3][0])
    self.m42 = CGFloat(matrix[3][1])
    self.m43 = CGFloat(matrix[3][2])
    self.m44 = CGFloat(matrix[3][3])
  }

  internal var matrix: matrix_double4x4 {
    return matrix_double4x4(self)
  }

  var decomposed: TransformationMatrix.Decomposed {
    return TransformationMatrix(self).decomposed
  }

  var perspective: simd_double4 {
    get {
      return decomposed.perspective
    }
    set {
      var decomposed = self.decomposed
      decomposed.perspective = newValue
      self = CATransform3D(decomposed.recomposed)
    }
  }

  func applyingPerspective(m31: CGFloat? = nil, m32: CGFloat? = nil, m33: CGFloat? = nil, m34: CGFloat? = nil) -> Self {
    let perspective = simd_double4(Double(m31 ?? self.m31), Double(m32 ?? self.m32), Double(m33 ?? self.m33), Double(m34 ?? self.m34))
    return self.applyingPerspective(perspective)
  }

  func applyingPerspective(_ perspective: simd_double4) -> Self {
    var transform = self
    transform.applyPerspective(perspective)
    return transform
  }

  mutating func applyPerspective(_ perspective: simd_double4) {
    self = matrix.applyingPerspective(perspective).transform
  }

  var translation: simd_double3 {
    get {
      return decomposed.translation
    }
    set {
      var decomposed = self.decomposed
      decomposed.translation = newValue
      self = CATransform3D(decomposed.recomposed)
    }
  }

  func translated(by translation: simd_double3) -> Self {
    var transform = self
    transform.translate(by: translation)
    return transform
  }

  func translatedBy(x: CGFloat = 0.0, y: CGFloat = 0.0, z: CGFloat = 0.0) -> Self {
    let translation = simd_double3(Double(x), Double(y), Double(z))
    return self.translated(by: translation)
  }

  mutating func translate(by translation: simd_double3) {
    self = matrix.translated(by: translation).transform
  }

  var rotation: simd_quatd {
    get {
      return decomposed.quaternion
    }
    set {
      var decomposed = self.decomposed
      decomposed.quaternion = newValue
      self = CATransform3D(decomposed.recomposed)
    }
  }

  func rotated(by rotation: simd_quatd) -> Self {
    var transform = self
    transform.rotate(by: rotation)
    return transform
  }

  func rotatedBy(angle: CGFloat, x: CGFloat = 0.0, y: CGFloat = 0.0, z: CGFloat = 0.0) -> Self {
    let rotation = simd_quatd(angle: Double(angle), axis: simd_double3(Double(x), Double(y), Double(z)))
    return self.rotated(by: rotation)
  }

  mutating func rotate(by rotation: simd_quatd) {
    self = matrix.rotated(by: rotation).transform
  }

  var skew: TransformationMatrix.Decomposed.Skew {
    get {
      return decomposed.skew
    }
    set {
      var decomposed = self.decomposed
      decomposed.skew = newValue
      self = CATransform3D(decomposed.recomposed)
    }
  }

  func skewed(by skew: TransformationMatrix.Decomposed.Skew) -> Self {
    var transform = self
    transform.skew(by: skew)
    return transform
  }

  func skewedBy(XY: Double = 0.0, XZ: CGFloat = 0.0, YZ: CGFloat = 0.0) -> Self {
    let skew = TransformationMatrix.Decomposed.Skew(XY: Double(XY), XZ: Double(XZ), YZ: Double(YZ))
    return self.skewed(by: skew)
  }

  mutating func skew(by skew: TransformationMatrix.Decomposed.Skew) {
    self = matrix.skewed(by: skew).transform
  }

  var scale: simd_double3 {
    get {
      return decomposed.scale
    }
    set {
      var decomposed = self.decomposed
      decomposed.scale = newValue
      self = CATransform3D(decomposed.recomposed)
    }
  }

  func scaled(by scale: simd_double3) -> Self {
    var transform = self
    transform.scale(by: scale)
    return transform
  }

  func scaledBy(x: CGFloat = 1.0, y: CGFloat = 1.0, z: CGFloat = 1.0) -> Self {
    let scale = simd_double3(Double(x), Double(y), Double(z))
    return self.scaled(by: scale)
  }

  mutating func scale(by scale: simd_double3) {
    self = matrix.scaled(by: scale).transform
  }

}
