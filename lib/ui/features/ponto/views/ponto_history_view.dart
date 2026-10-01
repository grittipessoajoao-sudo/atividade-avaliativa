import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/ponto_card.dart';
import '../../auth/view_models/auth_view_model.dart';
import '../view_models/ponto_view_model.dart';

// Tela que exibe o histórico de todos os registros de ponto realizados pelo funcionário.
class PontoHistoryView extends StatelessWidget {
  const PontoHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final pontoViewModel = context.watch<PontoViewModel>();
    final user = authViewModel.currentUser;

    if (user == null) return const Center(child: CircularProgressIndicator());

    final records = pontoViewModel.records;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Pontos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => pontoViewModel.loadHistory(user.id),
            tooltip: 'Atualizar Histórico',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => pontoViewModel.loadHistory(user.id),
        child: records.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  return PontoCard(record: records[index]);
                },
              ),
      ),
    );
  }

  // Componente exibido quando não há registros no histórico.
  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'Nenhum ponto registrado ainda.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Os seus pontos gravados aparecerão aqui.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
