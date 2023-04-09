class UserProfile {
  final String avatarUrl;
  final String email;
  final bool emailVerified;
  final String fullName;
  final String iss;
  final String name;
  final String picture;
  final String providerId;
  final String sub;

  UserProfile(
      {this.avatarUrl = "",
      this.email = "",
      this.emailVerified = false,
      this.fullName = "",
      this.iss = "",
      this.name = "",
      this.picture = "",
      this.providerId = "",
      this.sub = ""});

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        avatarUrl: json['avatar_url'] ?? "",
        email: json['email'] ?? "",
        emailVerified: json['email_verified'] ?? false,
        fullName: json['full_name'] ?? "",
        iss: json['iss'] ?? "",
        name: json['name'] ?? "",
        picture: json['picture'] ?? "",
        providerId: json['provider_id'] ?? "",
        sub: json['sub'] ?? "",
      );
}
