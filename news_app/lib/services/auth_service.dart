import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Kullanıcı durumunu dinle
  Stream<User?> get userStream => _auth.authStateChanges();

  // Email/Şifre ile kayıt
  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      print('Kayıt işlemi başlatılıyor...');
      print('Email: $email');

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Kayıt başarılı: ${userCredential.user?.email}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Firebase kayıt hatası: ${e.code}');
      print('Hata mesajı: ${e.message}');
      rethrow;
    } catch (e) {
      print('Genel kayıt hatası: $e');
      rethrow;
    }
  }

  // Email/Şifre ile giriş
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      print('Giriş işlemi başlatılıyor...');
      print('Email: $email');

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Giriş başarılı: ${userCredential.user?.email}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Firebase giriş hatası: ${e.code}');
      print('Hata mesajı: ${e.message}');
      rethrow;
    } catch (e) {
      print('Genel giriş hatası: $e');
      rethrow;
    }
  }

  // Google ile giriş
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Google giriş hatası: $e');
      rethrow;
    }
  }

  // Çıkış yap
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Çıkış hatası: $e');
      rethrow;
    }
  }

  // Şifre sıfırlama
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Şifre sıfırlama hatası: $e');
      rethrow;
    }
  }

  // Mevcut kullanıcıyı al
  User? get currentUser => _auth.currentUser;
}
