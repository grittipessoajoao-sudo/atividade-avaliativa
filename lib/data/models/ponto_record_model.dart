// Modelo que representa cada registro de ponto feito pelo funcionário.
class PontoRecordModel {
  final String id;
  final String userId;
  final String userName;
  final DateTime timestamp;
  final String type; // ENTRADA, SAIDA_ALMOCO, RETORNO_ALMOCO, SAIDA
  final double latitude;
  final double longitude;
  final double distanceMeters;
  final bool isWithinRadius;
  final String authMethod; // BIOMETRIA, SENHA
  final String companyAddress;

  const PontoRecordModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.timestamp,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    required this.isWithinRadius,
    required this.authMethod,
    required this.companyAddress,
  });

  // Retorna descrição amigável do tipo de ponto.
  String get typeLabel {
    switch (type) {
      case 'ENTRADA':
        return 'Entrada';
      case 'SAIDA_ALMOCO':
        return 'Saída para Almoço';
      case 'RETORNO_ALMOCO':
        return 'Retorno do Almoço';
      case 'SAIDA':
        return 'Saída';
      default:
        return type;
    }
  }

  // Converte o registro para formato JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'distanceMeters': distanceMeters,
      'isWithinRadius': isWithinRadius,
      'authMethod': authMethod,
      'companyAddress': companyAddress,
    };
  }

  // Constrói o modelo a partir de um JSON.
  factory PontoRecordModel.fromJson(Map<String, dynamic> json) {
    return PontoRecordModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String? ?? 'Funcionário',
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: json['type'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distanceMeters: (json['distanceMeters'] as num).toDouble(),
      isWithinRadius: json['isWithinRadius'] as bool? ?? true,
      authMethod: json['authMethod'] as String? ?? 'BIOMETRIA',
      companyAddress: json['companyAddress'] as String? ?? '',
    );
  }
}
