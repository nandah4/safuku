class Wallet {
  final int? id;
  final String name;
  final int saldo;
  final String color;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Wallet({
    this.id,
    required this.name,
    required this.saldo,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  Wallet copyWith({
    int? id,
    String? name,
    int? saldo,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Wallet(
      id: id ?? this.id,
      name: name ?? this.name,
      saldo: saldo ?? this.saldo,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Wallet.fromMap(Map<String, dynamic> data) {
    return Wallet(
      id: data['id'],
      name: data['name'],
      saldo: data['saldo'],
      color: data['color'],
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null,
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'saldo': saldo,
      'color': color,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
