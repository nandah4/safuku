class WalletEntity {
  final int? id;
  final String name;
  final int saldo;
  final String? color;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WalletEntity({
    this.id,
    required this.name,
    required this.saldo,
    this.color,
    this.createdAt,
    this.updatedAt,
  });
}
