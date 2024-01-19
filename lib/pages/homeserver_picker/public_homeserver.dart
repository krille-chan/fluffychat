class PublicHomeserver {
  final String name;
  final String? clientDomain;
  final String? isp;
  final String? staffJur;
  final bool? usingVanillaReg;
  final String? description;
  final String? regMethod;
  final String? regLink;
  final String? software;
  final String? version;
  final bool? captcha;
  final bool? email;
  final List<String>? languages;
  final List<Object>? features;
  final int? onlineStatus;
  final String? serverDomain;
  final int? verStatus;
  final int? roomDirectory;
  final bool? slidingSync;
  final bool? ipv6;

  const PublicHomeserver({
    required this.name,
    this.clientDomain,
    this.isp,
    this.staffJur,
    this.usingVanillaReg,
    this.description,
    this.regMethod,
    this.regLink,
    this.software,
    this.version,
    this.captcha,
    this.email,
    this.languages,
    this.features,
    this.onlineStatus,
    this.serverDomain,
    this.verStatus,
    this.roomDirectory,
    this.slidingSync,
    this.ipv6,
  });

  factory PublicHomeserver.fromJson(Map<String, dynamic> json) =>
      PublicHomeserver(
        name: json['name'],
        clientDomain: json['client_domain'],
        isp: json['isp'],
        staffJur: json['staff_jur'],
        usingVanillaReg: json['using_vanilla_reg'],
        description: json['description'],
        regMethod: json['reg_method'],
        regLink: json['reg_link'],
        software: json['software'],
        version: json['version'],
        captcha: json['captcha'],
        email: json['email'],
        languages: json['languages'] == null
            ? null
            : List<String>.from(json['languages']),
        features: json['features'] == null
            ? null
            : List<Object>.from(json['features']),
        onlineStatus: json['online_status'],
        serverDomain: json['server_domain'],
        verStatus: json['ver_status'],
        roomDirectory: json['room_directory'],
        slidingSync: json['sliding_sync'],
        ipv6: json['ipv6'],
      );
}
