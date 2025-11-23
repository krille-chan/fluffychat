/// Matrix Widget API versions
enum MatrixApiVersion {
  /// 0.0.1 prerelease
  prerelease1('0.0.1'),

  /// 0.0.2 prerelease
  prerelease2('0.0.2');

  const MatrixApiVersion(this.value);
  final String value;
}

/// Unstable MSC API versions
enum UnstableApiVersion {
  /// MSC2762: Widget API
  msc2762('org.matrix.msc2762'),

  /// MSC2762: Update state action
  msc2762UpdateState('org.matrix.msc2762_update_state'),

  /// MSC2871: Capability notification
  msc2871('org.matrix.msc2871'),

  /// MSC2873: Mutual capability acknowledgment
  msc2873('org.matrix.msc2873'),

  /// MSC2931: OpenID
  msc2931('org.matrix.msc2931'),

  /// MSC2974: Capability renegotiation
  msc2974('org.matrix.msc2974'),

  /// MSC2876: Read events
  msc2876('org.matrix.msc2876'),

  /// MSC3819: To-device messages
  msc3819('org.matrix.msc3819'),

  /// MSC3846: TURN servers
  msc3846('town.robin.msc3846'),

  /// MSC3869: Read relations
  msc3869('org.matrix.msc3869'),

  /// MSC3973: User directory search
  msc3973('org.matrix.msc3973'),

  /// MSC4039: Media upload/download
  msc4039('org.matrix.msc4039');

  const UnstableApiVersion(this.value);
  final String value;
}

/// Current supported API versions
const currentApiVersions = <String>[
  '0.0.1',
  '0.0.2',
  'org.matrix.msc2762',
  'org.matrix.msc2762_update_state',
  'org.matrix.msc2871',
  'org.matrix.msc2873',
  'org.matrix.msc2931',
  'org.matrix.msc2974',
  'org.matrix.msc2876',
  'org.matrix.msc3819',
  'town.robin.msc3846',
  'org.matrix.msc3869',
  'org.matrix.msc3973',
  'org.matrix.msc4039',
];

/// Negotiates supported API versions
class VersionNegotiation {
  /// Find common supported versions
  static List<String> negotiate({
    required List<String> clientVersions,
    required List<String> widgetVersions,
  }) {
    return clientVersions.where((v) => widgetVersions.contains(v)).toList();
  }

  /// Check if version is supported
  static bool supports(List<String> versions, String version) {
    return versions.contains(version);
  }
}
