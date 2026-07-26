import 'package:flutter/material.dart';
import 'package:inventaris_app/app/constants/app_strings.dart';
import 'package:inventaris_app/app/routes/app_routes.dart';
import 'package:inventaris_app/shared/providers/auth_provider.dart';
import 'package:inventaris_app/shared/widgets/app_input_field.dart';
import 'package:inventaris_app/shared/widgets/app_primary_button.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage!)),
        );
        authProvider.clearError();
      });
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF0F4FF),
              Color(0xFFF8F9FA),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogoSection(),
                  const SizedBox(height: 24),
                  _buildLoginCard(authProvider),
                  const SizedBox(height: 24),
                  _buildFooter(),
                  const SizedBox(height: 48),
                  _buildInfoRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF2563eb),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.inventory_2_outlined,
            size: 40,
            color: Color(0xFFeeefff),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.appName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF004ac6),
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(AuthProvider authProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFffffff),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFc3c6d7).withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              AppStrings.welcomeBack,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Color(0xFF191c1d),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.loginSubtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF434655),
              ),
            ),
            const SizedBox(height: 24),
            _buildFieldLabel(AppStrings.emailOrUsername),
            const SizedBox(height: 4),
            AppInputField(
              controller: _emailController,
              hintText: AppStrings.emailHint,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.person_outline),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email/Username tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFieldLabel(AppStrings.kataSandi),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Hubungi admin untuk reset password'),
                      ),
                    );
                  },
                  child: Text(
                    AppStrings.lupaPassword,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF004ac6),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            AppInputField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => setState(() {
                  _obscurePassword = !_obscurePassword;
                }),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF737686),
                    size: 20,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (value.length < 6) {
                  return 'Password minimal 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            AppPrimaryButton(
              label: AppStrings.masuk,
              onPressed: _onLogin,
              isLoading: authProvider.isLoading,
              suffixIcon: const Icon(
                Icons.login,
                size: 20,
                color: Color(0xFFeeefff),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF434655),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Text.rich(
      TextSpan(
        text: '${AppStrings.belumPunyaAkun} ',
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF434655),
        ),
        children: [
          TextSpan(
            text: AppStrings.hubungiAdmin,
            style: const TextStyle(
              color: Color(0xFF004ac6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildInfoItem(Icons.verified_user_outlined, AppStrings.dataTerenkripsi),
        const SizedBox(width: 32),
        _buildInfoItem(Icons.update, AppStrings.versionLabel),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF434655)),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF434655),
          ),
        ),
      ],
    );
  }
}
