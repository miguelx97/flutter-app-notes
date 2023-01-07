import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signIn({email, password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('Email incorrecto');
        case 'wrong-password':
          throw Exception('Contraseña incorrecta');
        case 'too-many-requests':
          throw Exception('Intente entrar en unos minutos');
        default:
          throw Exception(e.code);
      }
    }
  }

  Future<void> signUp({email, password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw Exception('Contraseña débil');
        case 'email-already-in-use':
          throw Exception('El email ya existe');
        case 'too-many-requests':
          throw Exception('Intente entrar en unos minutos');
        default:
          throw Exception(e.code);
      }
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
