class ApiEndpoints {
  static String login = '/auth/login';
  static String logout = '/auth/logout';
  static String me = '/auth/me';

  static String barangMasuk = '/barang-masuk';
  static String barangMasukDetail(int id) => '/barang-masuk/$id';

  static String dashboard = '/dashboard';

  static String dataRekap = '/data-rekap';

  static String kondisiRusak = '/kondisi-rusak';
  static String kondisiRusakDetail(int id) => '/kondisi-rusak/$id';

  static String profil = '/profil';
  static String profilUpdate = '/profil';
}
