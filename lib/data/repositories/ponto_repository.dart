import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import '../models/company_location_model.dart';
import '../models/ponto_record_model.dart';
import '../models/user_model.dart';
import '../services/biometric_service.dart';
import '../services/firebase_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

// Repositório responsável pelo registro, validação e histórico de pontos.
class PontoRepository {
  final LocationService _locationService;
  final StorageService _storageService;
  final FirebaseService _firebaseService;
  final BiometricService _biometricService;
  final Uuid _uuid = const Uuid();

  PontoRepository({
    required LocationService locationService,
    required StorageService storageService,
    required FirebaseService firebaseService,
    required BiometricService biometricService,
  })  : _locationService = locationService,
        _storageService = storageService,
        _firebaseService = firebaseService,
        _biometricService = biometricService;

  // Obtém o GPS atual e a distância até a empresa.
  Future<Map<String, dynamic>> getCurrentLocationAndDistance(
    CompanyLocationModel companyLocation,
  ) async {
    final Position? position = await _locationService.getCurrentPosition();
    if (position == null) {
      return {
        'position': null,
        'distance': double.infinity,
        'isWithinRadius': false,
        'error': 'Não foi possível obter o sinal de GPS.',
      };
    }

    final distance = _locationService.calculateDistance(
      startLat: position.latitude,
      startLng: position.longitude,
      endLat: companyLocation.latitude,
      endLng: companyLocation.longitude,
    );

    final isWithinRadius = distance <= companyLocation.radiusMeters;

    return {
      'position': position,
      'distance': distance,
      'isWithinRadius': isWithinRadius,
      'error': null,
    };
  }

  // Registra um novo ponto com validação de raio e confirmação por biometria.
  Future<PontoRecordModel?> registerPonto({
    required UserModel user,
    required String pontoType,
    required CompanyLocationModel companyLocation,
    required bool requireBiometrics,
  }) async {
    // 1. Validação de biometria se exigido
    String authMethod = 'SENHA';
    if (requireBiometrics) {
      final authenticated = await _biometricService.authenticate(
        reason: 'Confirme sua biometria para registrar o ponto',
      );
      if (!authenticated) return null;
      authMethod = 'RECONHECIMENTO_FACIAL_BIOMETRIA';
    }

    // 2. Obtenção do GPS e cálculo da distância
    final locData = await getCurrentLocationAndDistance(companyLocation);
    final Position? position = locData['position'] as Position?;
    final double distance = locData['distance'] as double;
    final bool isWithinRadius = locData['isWithinRadius'] as bool;

    if (position == null || !isWithinRadius) {
      throw Exception(
        'Fora do raio permitido de ${companyLocation.radiusMeters.toInt()}m da empresa. Distância atual: ${distance.toInt()}m',
      );
    }

    // 3. Criação do modelo de registro
    final record = PontoRecordModel(
      id: _uuid.v4(),
      userId: user.id,
      userName: user.name,
      timestamp: DateTime.now(),
      type: pontoType,
      latitude: position.latitude,
      longitude: position.longitude,
      distanceMeters: distance,
      isWithinRadius: isWithinRadius,
      authMethod: authMethod,
      companyAddress: companyLocation.address,
    );

    // 4. Salvar localmente e enviar ao Firebase se disponível
    await _storageService.savePontoRecord(record);
    await _firebaseService.savePontoToFirestore(record);

    return record;
  }

  // Obtém o histórico completo de pontos registrados.
  Future<List<PontoRecordModel>> getHistory(String userId) async {
    final localRecords = await _storageService.getPontoRecords();
    if (_firebaseService.isFirebaseAvailable) {
      final remoteRecords =
          await _firebaseService.getPontoRecordsFromFirestore(userId);
      if (remoteRecords.isNotEmpty) return remoteRecords;
    }
    return localRecords;
  }
}
