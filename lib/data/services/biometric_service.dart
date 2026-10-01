import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

// Serviço para gerenciamento de autenticação biométrica e reconhecimento facial.
class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  // Verifica se o dispositivo possui hardware de biometria.
  Future<bool> canCheckBiometrics() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      return canCheck && isSupported;
    } on PlatformException {
      return false;
    }
  }

  // Obtém lista de biometrias disponíveis no dispositivo (digital, face, etc).
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  // Executa a autenticação por biometria ou reconhecimento facial.
  Future<bool> authenticate({required String reason}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
      );
    } on PlatformException {
      return false;
    }
  }
}
