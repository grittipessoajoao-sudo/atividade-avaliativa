import 'package:flutter/material.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/services/biometric_service.dart';

// ViewModel responsável pelo gerenciamento de estado da autenticação.
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final BiometricService _biometricService;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _canUseBiometrics = false;

  AuthViewModel({
    required AuthRepository authRepository,
    required BiometricService biometricService,
  })  : _authRepository = authRepository,
        _biometricService = biometricService {
    checkInitialState();
  }

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get canUseBiometrics => _canUseBiometrics;

  // Carrega estado inicial e verifica se biometria está disponível.
  Future<void> checkInitialState() async {
    _isLoading = true;
    notifyListeners();

    _currentUser = await _authRepository.getCurrentUser();
    _canUseBiometrics = await _biometricService.canCheckBiometrics();

    _isLoading = false;
    notifyListeners();
  }

  // Realiza login por NIF/Email e senha.
  Future<bool> loginWithCredentials(String identifier, String password) async {
    _setLoading(true);
    _errorMessage = null;

    final user = await _authRepository.loginWithCredentials(identifier, password);
    if (user != null) {
      _currentUser = user;
      _setLoading(false);
      return true;
    }

    _errorMessage = 'Credenciais inválidas. Verifique o NIF/email e a senha.';
    _setLoading(false);
    return false;
  }

  // Realiza autenticação com biometria ou reconhecimento facial.
  Future<bool> loginWithBiometrics() async {
    _setLoading(true);
    _errorMessage = null;

    final user = await _authRepository.loginWithBiometrics();
    if (user != null) {
      _currentUser = user;
      _setLoading(false);
      return true;
    }

    _errorMessage = 'Falha na verificação biométrica ou cancelado.';
    _setLoading(false);
    return false;
  }

  // Realiza logout do usuário.
  Future<void> logout() async {
    _setLoading(true);
    await _authRepository.logout();
    _currentUser = null;
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
