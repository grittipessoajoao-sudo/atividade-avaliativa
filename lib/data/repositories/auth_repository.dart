import '../models/user_model.dart';
import '../services/biometric_service.dart';
import '../services/firebase_service.dart';
import '../services/storage_service.dart';

// Repositório responsável pela autenticação do usuário.
class AuthRepository {
  final StorageService _storageService;
  final BiometricService _biometricService;
  final FirebaseService _firebaseService;

  AuthRepository({
    required StorageService storageService,
    required BiometricService biometricService,
    required FirebaseService firebaseService,
  })  : _storageService = storageService,
        _biometricService = biometricService,
        _firebaseService = firebaseService;

  // Realiza login via NIF ou Email e Senha.
  Future<UserModel?> loginWithCredentials(
    String identifier,
    String password,
  ) async {
    // 1. Tenta Firebase se disponível
    final firebaseUser = await _firebaseService.loginWithEmailAndPassword(
      identifier,
      password,
    );
    if (firebaseUser != null) {
      await _storageService.saveUser(firebaseUser);
      return firebaseUser;
    }

    // 2. Validação local com dados padrão para teste
    if (password.length >= 4) {
      final user = UserModel(
        id: 'usr_100234',
        name: 'Carlos Silva (Funcionário)',
        email: identifier.contains('@') ? identifier : '$identifier@empresa.com',
        nif: identifier.contains('@') ? '100234' : identifier,
        role: 'Analista de Sistemas',
      );
      await _storageService.saveUser(user);
      return user;
    }
    return null;
  }

  // Realiza autenticação via Biometria ou Reconhecimento Facial.
  Future<UserModel?> loginWithBiometrics() async {
    final canCheck = await _biometricService.canCheckBiometrics();
    if (!canCheck) return null;

    final authenticated = await _biometricService.authenticate(
      reason: 'Autentique-se com biometria ou reconhecimento facial para acessar o registro de ponto',
    );

    if (authenticated) {
      var user = await _storageService.getUser();
      user ??= const UserModel(
        id: 'usr_100234',
        name: 'Carlos Silva (Funcionário)',
        email: 'carlos.silva@empresa.com',
        nif: '100234',
        role: 'Analista de Sistemas',
      );
      await _storageService.saveUser(user);
      return user;
    }
    return null;
  }

  // Obtém o usuário ativo salvo no dispositivo.
  Future<UserModel?> getCurrentUser() async {
    return await _storageService.getUser();
  }

  // Efetua logout e limpa os dados locais de sessão.
  Future<void> logout() async {
    await _storageService.clearUser();
  }
}
