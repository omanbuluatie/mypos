class Shift {
  int? id;
  int userId;
  DateTime openTime;
  DateTime? closeTime;
  double openingBalance;
  double? closingBalance;

  Shift({
    this.id,
    required this.userId,
    required this.openTime,
    this.closeTime,
    required this.openingBalance,
    this.closingBalance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'open_time': openTime.toIso8601String(),
      'close_time': closeTime?.toIso8601String(),
      'opening_balance': openingBalance,
      'closing_balance': closingBalance,
    };
  }

  factory Shift.fromMap(Map<String, dynamic> map) {
    return Shift(
      id: map['id'],
      userId: map['user_id'],
      openTime: DateTime.parse(map['open_time']),
      closeTime: map['close_time'] != null ? DateTime.parse(map['close_time']) : null,
      openingBalance: map['opening_balance'],
      closingBalance: map['closing_balance'],
    );
  }

  Shift copyWith({
    int? id,
    int? userId,
    DateTime? openTime,
    DateTime? closeTime,
    double? openingBalance,
    double? closingBalance,
  }) {
    return Shift(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      openingBalance: openingBalance ?? this.openingBalance,
      closingBalance: closingBalance ?? this.closingBalance,
    );
  }
}
