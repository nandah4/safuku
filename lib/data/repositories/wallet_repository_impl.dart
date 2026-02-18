import 'package:dartz/dartz.dart';
import 'package:safuku/data/datasource/local/wallet_local.dart';
import 'package:safuku/data/mapper/wallet_mapper.dart';
import 'package:safuku/domain/entities/wallet.dart';
import 'package:safuku/domain/repositories/wallet_repository.dart';
import 'package:safuku/core/utils/errors/failures.dart';
import 'package:safuku/core/utils/errors/failure_mapper.dart';
import 'package:safuku/core/utils/logger.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletDataSource walletDataSource;

  WalletRepositoryImpl({required this.walletDataSource});

  @override
  Future<Either<Failure, int>> createWallet(WalletEntity wallet) async {
    try {
      final toModel = wallet.toModel().copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final id = await walletDataSource.createWallet(toModel);

      AppLogger.i(" Repository : Wallet created successfully");
      return Right(id);
    } catch (e) {
      return Left(FailureMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWallet(int id) async {
    try {
      await walletDataSource.deleteWallet(id);

      AppLogger.i(" Repository : Wallet deleted successfully");
      return const Right(null);
    } catch (e) {
      return Left(FailureMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, List<WalletEntity>>> getAllWallets() async {
    try {
      final wallets = await walletDataSource.getAllWallets();

      return Right(wallets.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(FailureMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, int>> updateWallet(WalletEntity wallet) async {
    try {
      final toModel = wallet.toModel().copyWith(updatedAt: DateTime.now());

      AppLogger.i(" Repository : Wallet updated successfully");
      final rows = await walletDataSource.updateWallet(toModel);

      return Right(rows);
    } catch (e) {
      return Left(FailureMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalSaldo() async {
    try {
      final totalSaldo = await walletDataSource.getTotalSaldo();
      return Right(totalSaldo);
    } catch (e) {
      return Left(FailureMapper.map(e));
    }
  }
}
