import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/company_location_model.dart';
import '../models/ponto_record_model.dart';
import '../models/user_model.dart';

// Serviço para persistência de dados no armazenamento local do dispositivo.
class StorageService {
  static const String _userKey = 'app_user_session';
  static const String _companyLocationKey = 'company_location_config';
  static const String _pontoRecordsKey = 'ponto_records_list';

  // Salva os dados do usuário autenticado no armazenamento local.
  Future<bool> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // Carrega os dados do usuário autenticado salvo.
  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data == null) return null;
    return UserModel.fromJson(jsonDecode(data));
  }

  // Remove a sessão do usuário no logout.
  Future<bool> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_userKey);
  }

  // Salva a configuração de localização da empresa.
  Future<bool> saveCompanyLocation(CompanyLocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
      _companyLocationKey,
      jsonEncode(location.toJson()),
    );
  }

  // Obter localização salva da empresa (ou padrão caso não exista).
  Future<CompanyLocationModel> getCompanyLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_companyLocationKey);
    if (data == null) return CompanyLocationModel.defaultOffice();
    return CompanyLocationModel.fromJson(jsonDecode(data));
  }

  // Obtém a lista de todos os pontos registrados offline ou armazenados.
  Future<List<PontoRecordModel>> getPontoRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_pontoRecordsKey) ?? [];
    return data
        .map((item) => PontoRecordModel.fromJson(jsonDecode(item)))
        .toList();
  }

  // Adiciona um novo ponto à lista salva localmente.
  Future<bool> savePontoRecord(PontoRecordModel record) async {
    final list = await getPontoRecords();
    list.insert(0, record);
    final prefs = await SharedPreferences.getInstance();
    final encoded = list.map((item) => jsonEncode(item.toJson())).toList();
    return await prefs.setStringList(_pontoRecordsKey, encoded);
  }
}
