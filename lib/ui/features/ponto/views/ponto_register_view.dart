import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/radius_indicator.dart';
import '../../../core/widgets/status_card.dart';
import '../../auth/view_models/auth_view_model.dart';
import '../view_models/ponto_view_model.dart';

// Tela principal de Registro de Ponto com geolocalização e verificação do raio de 100m.
class PontoRegisterView extends StatefulWidget {
  const PontoRegisterView({super.key});

  @override
  State<PontoRegisterView> createState() => _PontoRegisterViewState();
}

class _PontoRegisterViewState extends State<PontoRegisterView> {
  bool _useBiometrics = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthViewModel>().currentUser;
      if (user != null) {
        context.read<PontoViewModel>().initialize(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final pontoViewModel = context.watch<PontoViewModel>();
    final user = authViewModel.currentUser;

    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => pontoViewModel.refreshLocation(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusCard(
                user: user,
                isFirebaseActive: pontoViewModel.isFirebaseActive,
              ),
              const SizedBox(height: 12),
              RadiusIndicator(
                distanceMeters: pontoViewModel.currentDistance,
                radiusMeters: pontoViewModel.companyLocation.radiusMeters,
                isWithinRadius: pontoViewModel.isWithinRadius,
                isLoading: pontoViewModel.isLoadingGPS,
                onRefresh: () => pontoViewModel.refreshLocation(),
              ),
              const SizedBox(height: 16),
              _buildBiometricsToggle(pontoViewModel),
              const SizedBox(height: 16),
              _buildActionGrid(pontoViewModel, user),
              const SizedBox(height: 16),
              if (pontoViewModel.errorMessage != null) _buildAlertCard(pontoViewModel.errorMessage!, Colors.red),
              if (pontoViewModel.successMessage != null) _buildAlertCard(pontoViewModel.successMessage!, Colors.green),
            ],
          ),
        ),
      ),
    );
  }

  // Alternador para exigir ou dispensar biometria durante o teste.
  Widget _buildBiometricsToggle(PontoViewModel viewModel) {
    return Card(
      child: SwitchListTile(
        title: const Text('Autenticar com Biometria / Facial', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: const Text('Exige confirmação por biometria antes de gravar o ponto', style: TextStyle(fontSize: 12)),
        value: _useBiometrics,
        secondary: const Icon(Icons.fingerprint, color: Colors.blue),
        onChanged: (val) => setState(() => _useBiometrics = val),
      ),
    );
  }

  // Grade com os botões para registrar cada tipo de ponto.
  Widget _buildActionGrid(PontoViewModel viewModel, user) {
    final enabled = viewModel.isWithinRadius && !viewModel.isRegistering;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildGridButton(
                title: 'ENTRADA',
                icon: Icons.login,
                color: Colors.green.shade700,
                enabled: enabled,
                onPressed: () => viewModel.registerPonto(
                  user: user,
                  pontoType: 'ENTRADA',
                  requireBiometrics: _useBiometrics,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGridButton(
                title: 'SAÍDA ALMOÇO',
                icon: Icons.restaurant,
                color: Colors.orange.shade800,
                enabled: enabled,
                onPressed: () => viewModel.registerPonto(
                  user: user,
                  pontoType: 'SAIDA_ALMOCO',
                  requireBiometrics: _useBiometrics,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildGridButton(
                title: 'RETORNO ALMOÇO',
                icon: Icons.work,
                color: Colors.blue.shade800,
                enabled: enabled,
                onPressed: () => viewModel.registerPonto(
                  user: user,
                  pontoType: 'RETORNO_ALMOCO',
                  requireBiometrics: _useBiometrics,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGridButton(
                title: 'SAÍDA',
                icon: Icons.logout,
                color: Colors.red.shade700,
                enabled: enabled,
                onPressed: () => viewModel.registerPonto(
                  user: user,
                  pontoType: 'SAIDA',
                  requireBiometrics: _useBiometrics,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Auxiliar para criar botões em grade estilizados.
  Widget _buildGridButton({
    required String title,
    required IconData icon,
    required Color color,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 80,
      child: CustomButton(
        text: title,
        icon: icon,
        backgroundColor: enabled ? color : Colors.grey.shade400,
        onPressed: enabled ? onPressed : null,
      ),
    );
  }

  // Card de Alertas de Sucesso ou Erro.
  Widget _buildAlertCard(String message, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        message,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }
}
