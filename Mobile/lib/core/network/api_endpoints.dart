class ApiEndpoints {
  static String login = '/login';
  static String logout = '/logout';
  static String me = '/me';

  static String barangMasuk = '/barang-masuk';
  static String barangMasukDetail(int id) => '/barang-masuk/$id';

  static String dashboard = '/dashboard';

  static String dataRekap = '/data-rekap';

  static String kondisiRusak = '/kondisi-rusak';
  static String kondisiRusakDetail(int id) => '/kondisi-rusak/$id';

  static String profil = '/profil';
  static String profilUpdate = '/profil';
}
