class PublicHomeserverData {
  final String? name;
  final String? clientDomain;
  final String? homepage;
  final String? isp;
  final String? staffJur;
  final String? rules;
  final String? privacy;
  final bool? usingVanillaReg;
  final String? description;
  final String? regMethod;
  final String? regLink;
  final String? software;
  final String? version;
  final bool? captcha;
  final bool? email;
  final List<String>? languages;
  final List<String>? features;
  final int? onlineStatus;
  final String? serverDomain;
  final int? verStatus;
  final int? roomDirectory;
  final bool? slidingSync;
  final bool? ipv6;

  PublicHomeserverData({
    this.name,
    this.clientDomain,
    this.homepage,
    this.isp,
    this.staffJur,
    this.rules,
    this.privacy,
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

  factory PublicHomeserverData.fromJson(Map<String, dynamic> json) {
    return PublicHomeserverData(
      name: json['name'],
      clientDomain: json['client_domain'],
      homepage: json['homepage'],
      isp: json['isp'],
      staffJur: json['staff_jur'],
      rules: json['rules'],
      privacy: json['privacy'],
      usingVanillaReg: json['using_vanilla_reg'],
      description: json['description'],
      regMethod: json['reg_method'],
      regLink: json['reg_link'],
      software: json['software'],
      version: json['version'],
      captcha: json['captcha'],
      email: json['email'],
      languages: List<String>.from(json['languages'] ?? []),
      features: List<String>.from(json['features'] ?? []),
      onlineStatus: json['online_status'],
      serverDomain: json['server_domain'],
      verStatus: json['ver_status'],
      roomDirectory: json['room_directory'],
      slidingSync: json['sliding_sync'],
      ipv6: json['ipv6'],
    );
  }
}
