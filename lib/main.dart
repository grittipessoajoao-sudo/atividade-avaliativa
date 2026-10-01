import 'package:firebase_core/firebase_core.dart' hide FirebaseService;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/auth_repository.dart';
import 'data/repositories/company_repository.dart';
import 'data/repositories/ponto_repository.dart';
import 'data/services/biometric_service.dart';
import 'data/services/firebase_service.dart';
import 'data/services/location_service.dart';
import 'data/services/storage_service.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/features/auth/view_models/auth_view_model.dart';
import 'ui/features/auth/views/login_view.dart';
import 'ui/features/home/views/home_view.dart';
import 'ui/features/ponto/view_models/ponto_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebaseSafely();
  runApp(const PontoBiometricoApp());
}

// Inicializa o Firebase de forma segura com fallback se não configurado.
Future<void> _initializeFirebaseSafely() async {
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Caso o Firebase não possua google-services.json no ambiente local.
  }
}

// Widget Raiz da aplicação.
class PontoBiometricoApp extends StatelessWidget {
  const PontoBiometricoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Instanciação dos Serviços
    final storageService = StorageService();
    final biometricService = BiometricService();
    final locationService = LocationService();
    final firebaseService = FirebaseService();

    // 2. Instanciação dos Repositorios
    final authRepo = AuthRepository(
      storageService: storageService,
      biometricService: biometricService,
      firebaseService: firebaseService,
    );
    final companyRepo = CompanyRepository(storageService: storageService);
    final pontoRepo = PontoRepository(
      locationService: locationService,
      storageService: storageService,
      firebaseService: firebaseService,
      biometricService: biometricService,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            authRepository: authRepo,
            biometricService: biometricService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PontoViewModel(
            pontoRepository: pontoRepo,
            companyRepository: companyRepo,
            firebaseService: firebaseService,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Registro de Ponto Biométrico',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapperWidget(),
      ),
    );
  }
}

// Seletor de tela com base na autenticação do usuário.
class AuthWrapperWidget extends StatelessWidget {
  const AuthWrapperWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    if (authViewModel.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (authViewModel.isAuthenticated) {
      return const HomeView();
    }

    return const LoginView();
  }
}
