import 'package:flutter/material.dart';
import 'package:inventaris_app/features/auth/login/login_page.dart';
import 'package:inventaris_app/features/barang_masuk/barang_masuk_page.dart';
import 'package:inventaris_app/features/dashboard/dashboard_page.dart';
import 'package:inventaris_app/features/data_rekap/data_rekap_page.dart';
import 'package:inventaris_app/features/kondisi_rusak/kondisi_rusak_page.dart';
import 'package:inventaris_app/features/profil/profil_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case '/barang-masuk':
        return MaterialPageRoute(builder: (_) => const BarangMasukPage());
      case '/data-rekap':
        return MaterialPageRoute(builder: (_) => const DataRekapPage());
      case '/kondisi-rusak':
        return MaterialPageRoute(builder: (_) => const KondisiRusakPage());
      case '/profil':
        return MaterialPageRoute(builder: (_) => const ProfilPage());
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}
