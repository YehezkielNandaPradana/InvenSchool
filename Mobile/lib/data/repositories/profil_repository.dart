import 'package:inventaris_app/core/error/failures.dart';
import 'package:inventaris_app/core/network/api_client.dart';
import 'package:inventaris_app/data/datasources/remote/profil_remote_datasource.dart';
import 'package:inventaris_app/data/models/profil/profil_model.dart';

class ProfilRepository {
  final ProfilRemoteDataSource remoteDataSource;

  const ProfilRepository({required this.remoteDataSource});

  Future<ProfilModel> getProfil() async {
    try {
      return await remoteDataSource.getProfil();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw const ServerFailure('Gagal memuat profil');
    }
  }

  Future<ProfilModel> updateProfil(ProfilModel profil) async {
    try {
      return await remoteDataSource.updateProfil(profil);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw const ServerFailure('Gagal menyimpan profil');
    }
  }
}
