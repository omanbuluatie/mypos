class CashMovement {
  int? id;
  int shiftId;
  String type; // 'in' or 'out'
  double amount;
  String reason;
  DateTime timestamp;

  CashMovement({
    this.id,
    required this.shiftId,
    required this.type,
    required this.amount,
    required this.reason,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shift_id': shiftId,
      'type': type,
      'amount': amount,
      'reason': reason,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CashMovement.fromMap(Map<String, dynamic> map) {
    return CashMovement(
      id: map['id'],
      shiftId: map['shift_id'],
      type: map['type'],
      amount: map['amount'],
      reason: map['reason'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
