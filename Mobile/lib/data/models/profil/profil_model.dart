class ProfilModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? alamat;
  final String? foto;

  const ProfilModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.alamat,
    this.foto,
  });

  factory ProfilModel.fromJson(Map<String, dynamic> json) {
    return ProfilModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      alamat: json['alamat'],
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'alamat': alamat,
      'foto': foto,
    };
  }
}
