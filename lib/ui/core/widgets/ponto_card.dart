import 'package:flutter/material.dart';
import '../../../data/models/ponto_record_model.dart';
import '../../../domain/utils/date_formatter.dart';
import '../../../domain/utils/distance_formatter.dart';

// Widget para exibição dos detalhes de um ponto no histórico.
class PontoCard extends StatelessWidget {
  final PontoRecordModel record;

  const PontoCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTypeChip(record.typeLabel),
                Text(
                  DateFormatter.formatTime(record.timestamp),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  DateFormatter.formatDate(record.timestamp),
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
                const Spacer(),
                const Icon(Icons.fingerprint, size: 14, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  record.authMethod.contains('BIOMETRIA') ? 'Biometria' : 'Senha',
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ],
            ),
            const Divider(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Distância: ${DistanceFormatter.format(record.distanceMeters)} (${record.companyAddress})',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Gera o chip colorido com o tipo do ponto.
  Widget _buildTypeChip(String label) {
    Color bg = Colors.blue.shade100;
    Color text = Colors.blue.shade900;

    if (label.contains('Entrada')) {
      bg = Colors.green.shade100;
      text = Colors.green.shade900;
    } else if (label.contains('Saída')) {
      bg = Colors.orange.shade100;
      text = Colors.orange.shade900;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
