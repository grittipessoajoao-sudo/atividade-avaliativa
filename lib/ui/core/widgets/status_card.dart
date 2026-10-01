import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/utils/date_formatter.dart';

// Card com informações do funcionário e status da conexão com Firebase.
class StatusCard extends StatelessWidget {
  final UserModel user;
  final bool isFirebaseActive;

  const StatusCard({
    super.key,
    required this.user,
    required this.isFirebaseActive,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    user.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'NIF: ${user.nif} | ${user.role}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormatter.formatWeekDay(now),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormatter.formatDate(now),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                _buildSyncBadge(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Gera o selo de status da sincronização com Firebase.
  Widget _buildSyncBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isFirebaseActive ? Colors.green.shade100 : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isFirebaseActive ? Icons.cloud_done : Icons.cloud_off,
            size: 14,
            color: isFirebaseActive ? Colors.green.shade900 : Colors.blue.shade900,
          ),
          const SizedBox(width: 4),
          Text(
            isFirebaseActive ? 'Firebase On' : 'Modo Local',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isFirebaseActive ? Colors.green.shade900 : Colors.blue.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
