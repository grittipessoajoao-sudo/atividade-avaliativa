import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_button.dart';
import '../view_models/auth_view_model.dart';

// Tela de Login com suporte a NIF/Email + Senha e Biometria/Reconhecimento Facial.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController(text: '100234');
  final _passwordController = TextEditingController(text: '123456');

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildIdentifierField(),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  const SizedBox(height: 24),
                  if (authViewModel.errorMessage != null) _buildErrorMessage(authViewModel.errorMessage!),
                  const SizedBox(height: 12),
                  _buildLoginButton(authViewModel),
                  const SizedBox(height: 16),
                  if (authViewModel.canUseBiometrics) _buildBiometricButton(authViewModel),
                  const SizedBox(height: 24),
                  _buildDemoHintCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Constrói o cabeçalho e logo do app.
  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.access_time_filled,
          size: 72,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 12),
        const Text(
          'Registro de Ponto',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Geolocalização & Biometria',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  // Campo de NIF ou Email.
  Widget _buildIdentifierField() {
    return TextFormField(
      controller: _identifierController,
      decoration: const InputDecoration(
        labelText: 'NIF ou E-mail',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.badge),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Informe seu NIF ou E-mail' : null,
    );
  }

  // Campo de Senha.
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Senha',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Informe sua senha' : null,
    );
  }

  // Mensagem de erro visual.
  Widget _buildErrorMessage(String msg) {
    return Text(
      msg,
      style: const TextStyle(color: Colors.red, fontSize: 13),
      textAlign: TextAlign.center,
    );
  }

  // Botão de Login Tradicional.
  Widget _buildLoginButton(AuthViewModel authViewModel) {
    return CustomButton(
      text: 'ENTRAR COM NIF / SENHA',
      icon: Icons.login,
      isLoading: authViewModel.isLoading,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          authViewModel.loginWithCredentials(
            _identifierController.text.trim(),
            _passwordController.text.trim(),
          );
        }
      },
    );
  }

  // Botão de Autenticação Biométrica.
  Widget _buildBiometricButton(AuthViewModel authViewModel) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.fingerprint, size: 24, color: Colors.blue),
      label: const Text('ENTRAR COM BIOMETRIA / FACE ID'),
      onPressed: authViewModel.isLoading ? null : () => authViewModel.loginWithBiometrics(),
    );
  }

  // Dica de teste em tela.
  Widget _buildDemoHintCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        '💡 Credenciais para avaliação:\nNIF: 100234 | Senha: 123456 ou clique em Biometria',
        style: TextStyle(fontSize: 12, color: Colors.blue),
        textAlign: TextAlign.center,
      ),
    );
  }
}
