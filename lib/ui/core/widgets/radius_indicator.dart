import 'package:flutter/material.dart';
import '../../../domain/utils/distance_formatter.dart';

// Componente visual que exibe a distância do GPS e a validação do raio de 100 metros.
class RadiusIndicator extends StatelessWidget {
  final double distanceMeters;
  final double radiusMeters;
  final bool isWithinRadius;
  final bool isLoading;
  final VoidCallback onRefresh;

  const RadiusIndicator({
    super.key,
    required this.distanceMeters,
    required this.radiusMeters,
    required this.isWithinRadius,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isWithinRadius ? Colors.green.shade700 : Colors.red.shade700;
    final statusBg = isWithinRadius ? Colors.green.shade50 : Colors.red.shade50;
    final iconData = isWithinRadius ? Icons.check_circle : Icons.error;
    final statusText = isWithinRadius
        ? 'DENTRO DO RAIO (${DistanceFormatter.format(distanceMeters)})'
        : 'FORA DO RAIO PERMITIDO (${DistanceFormatter.format(distanceMeters)})';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: statusColor, width: 2),
      ),
      color: statusBg,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(iconData, color: statusColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  onPressed: isLoading ? null : onRefresh,
                  tooltip: 'Atualizar GPS',
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildProgressBar(statusColor),
            const SizedBox(height: 8),
            Text(
              'Limite máximo para registro: ${radiusMeters.toInt()}m',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  // Constrói barra de progresso proporcional à distância do raio.
  Widget _buildProgressBar(Color color) {
    double progress = distanceMeters / (radiusMeters * 2);
    if (progress > 1.0) progress = 1.0;
    if (progress.isNaN || progress.isInfinite) progress = 0.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 10,
        backgroundColor: Colors.grey.shade300,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
