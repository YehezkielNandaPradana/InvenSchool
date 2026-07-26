import 'package:flutter_test/flutter_test.dart';
import 'package:inventaris_app/data/models/auth/login_model.dart';

void main() {
  group('LoginModel', () {
    test('should create from JSON', () {
      final json = {
        'email': 'admin@invenschool.com',
        'password': 'password',
      };
      final model = LoginModel.fromJson(json);
      expect(model.email, 'admin@invenschool.com');
      expect(model.password, 'password');
    });

    test('should convert to JSON', () {
      final model = LoginModel(
        email: 'admin@invenschool.com',
        password: 'password',
      );
      final json = model.toJson();
      expect(json['email'], 'admin@invenschool.com');
      expect(json['password'], 'password');
    });
  });
}
