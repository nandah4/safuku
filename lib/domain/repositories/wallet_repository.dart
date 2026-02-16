import 'package:dartz/dartz.dart';
import 'package:safuku/domain/entities/wallet.dart';
import 'package:safuku/core/utils/errors/failures.dart';

abstract class WalletRepository {
  Future<Either<Failure, int>> createWallet(WalletEntity wallet);
  Future<Either<Failure, int>> updateWallet(WalletEntity wallet);
  Future<Either<Failure, void>> deleteWallet(int id);
  Future<Either<Failure, List<WalletEntity>>> getAllWallets();
  Future<Either<Failure, int>> getTotalSaldo();
}
