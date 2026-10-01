import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_button.dart';
import '../../ponto/view_models/ponto_view_model.dart';

// Tela de Configurações do Local de Trabalho e Modo de Teste da Avaliação.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final pontoViewModel = context.watch<PontoViewModel>();
    final company = pontoViewModel.companyLocation;

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações do Local de Trabalho')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOfficeCard(company),
            const SizedBox(height: 16),
            _buildTestModeCard(pontoViewModel),
            const SizedBox(height: 16),
            _buildRadiusSliderCard(pontoViewModel, company.radiusMeters),
            const SizedBox(height: 16),
            _buildHardwareStatusCard(pontoViewModel),
          ],
        ),
      ),
    );
  }

  // Card com os dados do local da empresa.
  Widget _buildOfficeCard(company) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.business, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  company.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20),
            Text('Endereço: ${company.address}', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 4),
            Text('Latitude: ${company.latitude.toStringAsFixed(6)}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text('Longitude: ${company.longitude.toStringAsFixed(6)}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // Card para Simular/Ajustar localização da empresa para o GPS do avaliador.
  Widget _buildTestModeCard(PontoViewModel viewModel) {
    return Card(
      color: Colors.amber.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.amber.shade700, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.science, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  'Modo de Avaliação Prática',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Para testar a validação de 100 metros em qualquer lugar, clique abaixo para definir sua posição GPS atual como a Sede da Empresa.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'DEFINIR MEU GPS ATUAL COMO EMPRESA',
              icon: Icons.my_location,
              backgroundColor: Colors.amber.shade800,
              onPressed: viewModel.currentPosition == null
                  ? null
                  : () async {
                      await viewModel.setCompanyLocationToCurrentGPS();
                    },
            ),
          ],
        ),
      ),
    );
  }

  // Card para ajuste dinâmico do raio em metros.
  Widget _buildRadiusSliderCard(PontoViewModel viewModel, double currentRadius) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Raio Máximo Permitido: ${currentRadius.toInt()} metros',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Slider(
              value: currentRadius,
              min: 50.0,
              max: 500.0,
              divisions: 9,
              label: '${currentRadius.toInt()}m',
              onChanged: (val) => viewModel.updateCompanyRadius(val),
            ),
          ],
        ),
      ),
    );
  }

  // Card de status de hardware e integração.
  Widget _buildHardwareStatusCard(PontoViewModel viewModel) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.settings_remote, color: Colors.indigo),
        title: const Text('Recursos de Hardware & APIs', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: Text(
          'GPS: Ativo | Biometria: Suportada | Firebase: ${viewModel.isFirebaseActive ? "Conectado" : "Modo Local Fallback"}',
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
