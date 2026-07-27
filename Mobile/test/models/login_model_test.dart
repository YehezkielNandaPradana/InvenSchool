import 'package:flutter_test/flutter_test.dart';
import 'package:inventaris_app/data/models/auth/login_model.dart';

void main() {
  group('LoginRequest', () {
    test('should convert to JSON', () {
      const model = LoginRequest(email: 'admin@invenschool.com', password: 'password');
      final json = model.toJson();
      expect(json['email'], 'admin@invenschool.com');
      expect(json['password'], 'password');
    });
  });

  group('LoginResponse', () {
    test('should create from JSON', () {
      final json = {
        'token': 'abc123',
        'user': {'id': 1, 'name': 'Admin', 'email': 'admin@invenschool.com'},
      };
      final model = LoginResponse.fromJson(json);
      expect(model.token, 'abc123');
      expect(model.user.email, 'admin@invenschool.com');
    });
  });

  group('UserModel', () {
    test('should create from JSON', () {
      final json = {'id': 1, 'name': 'Admin', 'email': 'admin@invenschool.com', 'role': 'admin'};
      final model = UserModel.fromJson(json);
      expect(model.id, 1);
      expect(model.name, 'Admin');
      expect(model.role, 'admin');
    });

    test('should convert to JSON', () {
      const model = UserModel(id: 1, name: 'Admin', email: 'admin@invenschool.com', role: 'admin');
      final json = model.toJson();
      expect(json['name'], 'Admin');
    });
  });
}
