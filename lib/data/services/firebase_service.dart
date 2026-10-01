import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/ponto_record_model.dart';
import '../models/user_model.dart';

// Serviço responsável pela comunicação e sincronização com o Firebase.
class FirebaseService {
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;

  // Verifica se o Firebase foi inicializado no app.
  bool get isFirebaseAvailable => Firebase.apps.isNotEmpty;

  // Construtor com inicialização segura dos serviços Firebase.
  FirebaseService() {
    if (isFirebaseAvailable) {
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
    }
  }

  // Tenta autenticar via Firebase Auth (ou retorna nulo se desativado/erro).
  Future<UserModel?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (!isFirebaseAvailable || _auth == null) return null;
    try {
      final credential = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) return null;
      return UserModel(
        id: user.uid,
        name: user.displayName ?? email.split('@').first,
        email: user.email ?? email,
        nif: '100234',
        role: 'Funcionário',
      );
    } catch (_) {
      return null;
    }
  }

  // Sincroniza o registro de ponto no Cloud Firestore.
  Future<bool> savePontoToFirestore(PontoRecordModel record) async {
    if (!isFirebaseAvailable || _firestore == null) return false;
    try {
      await _firestore!
          .collection('ponto_records')
          .doc(record.id)
          .set(record.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }

  // Recupera registros de ponto do Firestore.
  Future<List<PontoRecordModel>> getPontoRecordsFromFirestore(
    String userId,
  ) async {
    if (!isFirebaseAvailable || _firestore == null) return [];
    try {
      final snapshot = await _firestore!
          .collection('ponto_records')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => PontoRecordModel.fromJson(doc.data()))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
