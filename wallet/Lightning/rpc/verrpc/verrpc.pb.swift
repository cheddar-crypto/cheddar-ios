// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: verrpc/verrpc.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct Verrpc_VersionRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Verrpc_Version {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// A verbose description of the daemon's commit.
  var commit: String = String()

  /// The SHA1 commit hash that the daemon is compiled with.
  var commitHash: String = String()

  /// The semantic version.
  var version: String = String()

  /// The major application version.
  var appMajor: UInt32 = 0

  /// The minor application version.
  var appMinor: UInt32 = 0

  /// The application patch number.
  var appPatch: UInt32 = 0

  /// The application pre-release modifier, possibly empty.
  var appPreRelease: String = String()

  /// The list of build tags that were supplied during compilation.
  var buildTags: [String] = []

  /// The version of go that compiled the executable.
  var goVersion: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "verrpc"

extension Verrpc_VersionRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".VersionRequest"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Verrpc_VersionRequest, rhs: Verrpc_VersionRequest) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Verrpc_Version: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Version"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "commit"),
    2: .standard(proto: "commit_hash"),
    3: .same(proto: "version"),
    4: .standard(proto: "app_major"),
    5: .standard(proto: "app_minor"),
    6: .standard(proto: "app_patch"),
    7: .standard(proto: "app_pre_release"),
    8: .standard(proto: "build_tags"),
    9: .standard(proto: "go_version"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self.commit)
      case 2: try decoder.decodeSingularStringField(value: &self.commitHash)
      case 3: try decoder.decodeSingularStringField(value: &self.version)
      case 4: try decoder.decodeSingularUInt32Field(value: &self.appMajor)
      case 5: try decoder.decodeSingularUInt32Field(value: &self.appMinor)
      case 6: try decoder.decodeSingularUInt32Field(value: &self.appPatch)
      case 7: try decoder.decodeSingularStringField(value: &self.appPreRelease)
      case 8: try decoder.decodeRepeatedStringField(value: &self.buildTags)
      case 9: try decoder.decodeSingularStringField(value: &self.goVersion)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.commit.isEmpty {
      try visitor.visitSingularStringField(value: self.commit, fieldNumber: 1)
    }
    if !self.commitHash.isEmpty {
      try visitor.visitSingularStringField(value: self.commitHash, fieldNumber: 2)
    }
    if !self.version.isEmpty {
      try visitor.visitSingularStringField(value: self.version, fieldNumber: 3)
    }
    if self.appMajor != 0 {
      try visitor.visitSingularUInt32Field(value: self.appMajor, fieldNumber: 4)
    }
    if self.appMinor != 0 {
      try visitor.visitSingularUInt32Field(value: self.appMinor, fieldNumber: 5)
    }
    if self.appPatch != 0 {
      try visitor.visitSingularUInt32Field(value: self.appPatch, fieldNumber: 6)
    }
    if !self.appPreRelease.isEmpty {
      try visitor.visitSingularStringField(value: self.appPreRelease, fieldNumber: 7)
    }
    if !self.buildTags.isEmpty {
      try visitor.visitRepeatedStringField(value: self.buildTags, fieldNumber: 8)
    }
    if !self.goVersion.isEmpty {
      try visitor.visitSingularStringField(value: self.goVersion, fieldNumber: 9)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Verrpc_Version, rhs: Verrpc_Version) -> Bool {
    if lhs.commit != rhs.commit {return false}
    if lhs.commitHash != rhs.commitHash {return false}
    if lhs.version != rhs.version {return false}
    if lhs.appMajor != rhs.appMajor {return false}
    if lhs.appMinor != rhs.appMinor {return false}
    if lhs.appPatch != rhs.appPatch {return false}
    if lhs.appPreRelease != rhs.appPreRelease {return false}
    if lhs.buildTags != rhs.buildTags {return false}
    if lhs.goVersion != rhs.goVersion {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
