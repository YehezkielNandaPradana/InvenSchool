class ApiEndpoints {
  static const String login = '/login';
  static const String logout = '/logout';
  static const String me = '/me';

  static const String barangMasuk = '/barang-masuk';
  static String barangMasukDetail(int id) => '/barang-masuk/$id';

  static const String dashboard = '/dashboard';

  static const String dataRekap = '/data-rekap';

  static const String kondisiRusak = '/kondisi-rusak';
  static String kondisiRusakDetail(int id) => '/kondisi-rusak/$id';

  static const String profil = '/profil';
  static const String profilUpdate = '/profil';
}
