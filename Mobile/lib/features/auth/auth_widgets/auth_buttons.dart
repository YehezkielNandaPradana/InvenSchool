import 'package:flutter/material.dart';
import 'package:inventaris_app/shared/widgets/app_primary_button.dart';

class AuthButtons extends StatelessWidget {
  const AuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPrimaryButton(
      label: 'Login',
      onPressed: null,
    );
  }
}
