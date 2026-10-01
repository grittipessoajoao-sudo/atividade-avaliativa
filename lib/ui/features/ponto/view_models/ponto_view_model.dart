import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../data/models/company_location_model.dart';
import '../../../../data/models/ponto_record_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/company_repository.dart';
import '../../../../data/repositories/ponto_repository.dart';
import '../../../../data/services/firebase_service.dart';

// ViewModel responsável pela lógica do registro de ponto e verificação do raio de 100m.
class PontoViewModel extends ChangeNotifier {
  final PontoRepository _pontoRepository;
  final CompanyRepository _companyRepository;
  final FirebaseService _firebaseService;

  CompanyLocationModel _companyLocation = CompanyLocationModel.defaultOffice();
  Position? _currentPosition;
  double _currentDistance = double.infinity;
  bool _isWithinRadius = false;
  bool _isLoadingGPS = false;
  bool _isRegistering = false;
  List<PontoRecordModel> _records = [];
  String? _errorMessage;
  String? _successMessage;

  PontoViewModel({
    required PontoRepository pontoRepository,
    required CompanyRepository companyRepository,
    required FirebaseService firebaseService,
  })  : _pontoRepository = pontoRepository,
        _companyRepository = companyRepository,
        _firebaseService = firebaseService;

  CompanyLocationModel get companyLocation => _companyLocation;
  Position? get currentPosition => _currentPosition;
  double get currentDistance => _currentDistance;
  bool get isWithinRadius => _isWithinRadius;
  bool get isLoadingGPS => _isLoadingGPS;
  bool get isRegistering => _isRegistering;
  List<PontoRecordModel> get records => _records;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isFirebaseActive => _firebaseService.isFirebaseAvailable;

  // Inicializa dados de localização da empresa e atualiza distância GPS.
  Future<void> initialize(String userId) async {
    _companyLocation = await _companyRepository.getCompanyLocation();
    await refreshLocation();
    await loadHistory(userId);
  }

  // Atualiza coordenadas GPS atuais do funcionário e calcula distância até a empresa.
  Future<void> refreshLocation() async {
    _isLoadingGPS = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _pontoRepository.getCurrentLocationAndDistance(_companyLocation);
    _currentPosition = result['position'] as Position?;
    _currentDistance = result['distance'] as double;
    _isWithinRadius = result['isWithinRadius'] as bool;
    _errorMessage = result['error'] as String?;

    _isLoadingGPS = false;
    notifyListeners();
  }

  // Bater ponto (Entrada, Saída Almoço, Retorno, Saída) com verificação de raio de 100m.
  Future<bool> registerPonto({
    required UserModel user,
    required String pontoType,
    bool requireBiometrics = true,
  }) async {
    _isRegistering = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final record = await _pontoRepository.registerPonto(
        user: user,
        pontoType: pontoType,
        companyLocation: _companyLocation,
        requireBiometrics: requireBiometrics,
      );

      if (record != null) {
        _records.insert(0, record);
        _successMessage = 'Ponto de ${record.typeLabel} registrado com sucesso!';
        _isRegistering = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    _isRegistering = false;
    notifyListeners();
    return false;
  }

  // Carrega histórico de pontos registrados.
  Future<void> loadHistory(String userId) async {
    _records = await _pontoRepository.getHistory(userId);
    notifyListeners();
  }

  // Define a localização atual como local de trabalho para testes e avaliação rápida.
  Future<void> setCompanyLocationToCurrentGPS() async {
    if (_currentPosition == null) return;
    _companyLocation = await _companyRepository.setLocationToCurrentGPS(_currentPosition!);
    await refreshLocation();
  }

  // Altera o raio máximo permitido em metros.
  Future<void> updateCompanyRadius(double newRadius) async {
    _companyLocation = _companyLocation.copyWith(radiusMeters: newRadius);
    await _companyRepository.updateCompanyLocation(_companyLocation);
    await refreshLocation();
  }
}
