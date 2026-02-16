import 'package:safuku/data/models/wallet.dart';
import 'package:safuku/domain/entities/wallet.dart';

extension WalletMapper on WalletEntity {
  Wallet toModel() {
    return Wallet(
      id: id,
      name: name,
      saldo: saldo,
      color: color ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension WalletMapperModel on Wallet {
  WalletEntity toEntity() {
    return WalletEntity(
      id: id,
      name: name,
      saldo: saldo,
      color: color,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
