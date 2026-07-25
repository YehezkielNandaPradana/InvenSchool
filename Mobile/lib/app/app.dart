import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inventaris_app/app/constants/app_theme.dart';
import 'package:inventaris_app/app/routes/route_generator.dart';
import 'package:inventaris_app/core/network/api_client.dart';
import 'package:inventaris_app/core/network/storage_service.dart';
import 'package:inventaris_app/data/datasources/local/auth_local_datasource.dart';
import 'package:inventaris_app/data/datasources/remote/auth_remote_datasource.dart';
import 'package:inventaris_app/data/datasources/remote/barang_masuk_remote_datasource.dart';
import 'package:inventaris_app/data/datasources/remote/dashboard_remote_datasource.dart';
import 'package:inventaris_app/data/datasources/remote/data_rekap_remote_datasource.dart';
import 'package:inventaris_app/data/datasources/remote/kondisi_rusak_remote_datasource.dart';
import 'package:inventaris_app/data/datasources/remote/profil_remote_datasource.dart';
import 'package:inventaris_app/data/repositories/auth_repository.dart';
import 'package:inventaris_app/data/repositories/barang_masuk_repository.dart';
import 'package:inventaris_app/data/repositories/dashboard_repository.dart';
import 'package:inventaris_app/data/repositories/data_rekap_repository.dart';
import 'package:inventaris_app/data/repositories/kondisi_rusak_repository.dart';
import 'package:inventaris_app/data/repositories/profil_repository.dart';
import 'package:inventaris_app/features/barang_masuk/state/barang_masuk_view_model.dart';
import 'package:inventaris_app/features/dashboard/state/dashboard_view_model.dart';
import 'package:inventaris_app/features/data_rekap/state/data_rekap_view_model.dart';
import 'package:inventaris_app/features/kondisi_rusak/state/kondisi_rusak_view_model.dart';
import 'package:inventaris_app/features/profil/state/profil_view_model.dart';
import 'package:inventaris_app/shared/providers/auth_provider.dart';
import 'package:inventaris_app/shared/providers/loading_provider.dart';
import 'package:provider/provider.dart';

class InventarisApp extends StatelessWidget {
  static final StorageService _storageService = StorageService();
  static final ApiClient _apiClient = ApiClient(
    dio: Dio(),
    storageService: _storageService,
  );

  static final AuthRemoteDataSource _authRemoteDataSource = AuthRemoteDataSource(
    apiClient: _apiClient,
    storageService: _storageService,
  );

  static final AuthLocalDataSource _authLocalDataSource = AuthLocalDataSource(
    storageService: _storageService,
  );

  static final AuthRepository _authRepository = AuthRepository(
    remoteDataSource: _authRemoteDataSource,
    localDataSource: _authLocalDataSource,
  );

  static final DashboardRemoteDataSource _dashboardRemoteDataSource =
      DashboardRemoteDataSource(
        apiClient: _apiClient,
        storageService: _storageService,
      );

  static final DashboardRepository _dashboardRepository = DashboardRepository(
    remoteDataSource: _dashboardRemoteDataSource,
  );

  static final BarangMasukRemoteDataSource _barangMasukRemoteDataSource =
      BarangMasukRemoteDataSource(
        apiClient: _apiClient,
        storageService: _storageService,
      );

  static final BarangMasukRepository _barangMasukRepository =
      BarangMasukRepository(
        remoteDataSource: _barangMasukRemoteDataSource,
      );

  static final DataRekapRemoteDataSource _dataRekapRemoteDataSource =
      DataRekapRemoteDataSource(
        apiClient: _apiClient,
        storageService: _storageService,
      );

  static final DataRekapRepository _dataRekapRepository = DataRekapRepository(
    remoteDataSource: _dataRekapRemoteDataSource,
  );

  static final KondisiRusakRemoteDataSource _kondisiRusakRemoteDataSource =
      KondisiRusakRemoteDataSource(
        apiClient: _apiClient,
        storageService: _storageService,
      );

  static final KondisiRusakRepository _kondisiRusakRepository =
      KondisiRusakRepository(
        remoteDataSource: _kondisiRusakRemoteDataSource,
      );

  static final ProfilRemoteDataSource _profilRemoteDataSource =
      ProfilRemoteDataSource(
        apiClient: _apiClient,
        storageService: _storageService,
      );

  static final ProfilRepository _profilRepository = ProfilRepository(
    remoteDataSource: _profilRemoteDataSource,
  );

  const InventarisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository: _authRepository)),
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel(dashboardRepository: _dashboardRepository)),
        ChangeNotifierProvider(create: (_) => BarangMasukViewModel(repository: _barangMasukRepository)),
        ChangeNotifierProvider(create: (_) => DataRekapViewModel(repository: _dataRekapRepository)),
        ChangeNotifierProvider(create: (_) => KondisiRusakViewModel(repository: _kondisiRusakRepository)),
        ChangeNotifierProvider(create: (_) => ProfilViewModel(repository: _profilRepository)),
      ],
      child: MaterialApp(
        title: 'Inventaris Sekolah',
        theme: appTheme(),
        initialRoute: '/login',
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
