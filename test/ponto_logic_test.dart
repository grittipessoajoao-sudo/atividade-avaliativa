import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ponto_biometrico_app/data/models/company_location_model.dart';
import 'package:ponto_biometrico_app/data/models/ponto_record_model.dart';
import 'package:ponto_biometrico_app/data/models/user_model.dart';
import 'package:ponto_biometrico_app/domain/utils/distance_formatter.dart';

void main() {
  group('Testes da Lógica do Registro de Ponto e Geolocalização', () {
    test('Validação de Usuário Modelo', () {
      const user = UserModel(
        id: '123',
        name: 'Maria Santos',
        email: 'maria@empresa.com',
        nif: '998877',
        role: 'Desenvolvedora',
      );

      expect(user.id, equals('123'));
      expect(user.nif, equals('998877'));
      final json = user.toJson();
      final fromJson = UserModel.fromJson(json);
      expect(fromJson.name, equals('Maria Santos'));
    });

    test('Validação da Regra do Raio de 100 metros', () {
      final office = CompanyLocationModel.defaultOffice();
      expect(office.radiusMeters, equals(100.0));

      // Ponto na mesma coordenada exata da empresa
      final distanceExact = Geolocator.distanceBetween(
        office.latitude,
        office.longitude,
        office.latitude,
        office.longitude,
      );
      expect(distanceExact, equals(0.0));
      expect(distanceExact <= office.radiusMeters, isTrue);

      // Ponto distante (mais de 1km)
      final distanceFar = Geolocator.distanceBetween(
        office.latitude,
        office.longitude,
        -22.9068, // Rio de Janeiro
        -43.1729,
      );
      expect(distanceFar > 100.0, isTrue);
    });

    test('Formatador de Distância', () {
      expect(DistanceFormatter.format(45.2), equals('45 m'));
      expect(DistanceFormatter.format(1500.0), equals('1.50 km'));
    });

    test('Serialização do PontoRecordModel', () {
      final record = PontoRecordModel(
        id: 'rec_01',
        userId: '123',
        userName: 'Maria Santos',
        timestamp: DateTime(2026, 10, 1, 8, 30),
        type: 'ENTRADA',
        latitude: -23.550520,
        longitude: -46.633308,
        distanceMeters: 15.0,
        isWithinRadius: true,
        authMethod: 'BIOMETRIA',
        companyAddress: 'Sede SP',
      );

      final json = record.toJson();
      final restored = PontoRecordModel.fromJson(json);

      expect(restored.id, equals('rec_01'));
      expect(restored.typeLabel, equals('Entrada'));
      expect(restored.isWithinRadius, isTrue);
    });
  });
}
