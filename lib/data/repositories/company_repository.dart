import 'package:geolocator/geolocator.dart';
import '../models/company_location_model.dart';
import '../services/storage_service.dart';

// Repositório responsável pela localização da empresa e configurações do raio.
class CompanyRepository {
  final StorageService _storageService;

  CompanyRepository({required StorageService storageService})
      : _storageService = storageService;

  // Obtém as coordenadas e o raio configurados para o local de trabalho.
  Future<CompanyLocationModel> getCompanyLocation() async {
    return await _storageService.getCompanyLocation();
  }

  // Atualiza as configurações de localização da empresa.
  Future<bool> updateCompanyLocation(CompanyLocationModel location) async {
    return await _storageService.saveCompanyLocation(location);
  }

  // Define a localização atual do GPS do dispositivo como o local de trabalho (Modo de Teste).
  Future<CompanyLocationModel> setLocationToCurrentGPS(
    Position position,
  ) async {
    final updated = CompanyLocationModel(
      name: 'Local de Trabalho (Modo Teste GPS)',
      latitude: position.latitude,
      longitude: position.longitude,
      radiusMeters: 100.0,
      address: 'Lat: ${position.latitude.toStringAsFixed(5)}, Lng: ${position.longitude.toStringAsFixed(5)}',
    );
    await _storageService.saveCompanyLocation(updated);
    return updated;
  }
}
