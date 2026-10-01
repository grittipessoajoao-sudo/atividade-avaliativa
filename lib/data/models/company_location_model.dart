// Modelo que representa as coordenadas e o raio de tolerância do local de trabalho.
class CompanyLocationModel {
  final String name;
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final String address;

  const CompanyLocationModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    required this.address,
  });

  // Local de trabalho padrão (Sede da Empresa) para demonstração inicial.
  factory CompanyLocationModel.defaultOffice() {
    return const CompanyLocationModel(
      name: 'Sede SESI / Empresa',
      latitude: -23.550520, // São Paulo Centro (Exemplo Padrão)
      longitude: -46.633308,
      radiusMeters: 100.0,
      address: 'Praça da Sé - Centro, São Paulo - SP',
    );
  }

  // Converte o modelo para JSON.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'radiusMeters': radiusMeters,
      'address': address,
    };
  }

  // Cria instância a partir de mapa JSON.
  factory CompanyLocationModel.fromJson(Map<String, dynamic> json) {
    return CompanyLocationModel(
      name: json['name'] as String? ?? 'Sede Principal',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radiusMeters: (json['radiusMeters'] as num? ?? 100.0).toDouble(),
      address: json['address'] as String? ?? 'Endereço não informado',
    );
  }

  // Copia o modelo alterando apenas os campos fornecidos.
  CompanyLocationModel copyWith({
    String? name,
    double? latitude,
    double? longitude,
    double? radiusMeters,
    String? address,
  }) {
    return CompanyLocationModel(
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      address: address ?? this.address,
    );
  }
}
