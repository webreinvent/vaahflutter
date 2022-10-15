class Token {
  Token({this.bearerToken});

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        bearerToken: json['bearerToken'],
      );

  static const String localKey = 'token';

  String? bearerToken;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'bearerToken': bearerToken};

  @override
  String toString() {
    return 'Token{bearerToken: $bearerToken}';
  }
}
