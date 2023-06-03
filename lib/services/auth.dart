import 'package:firebase_auth/firebase_auth.dart';
import 'package:bustrack/services/database.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // auth change user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // sign out
  Future signOut() async {
    await _auth.signOut();
  }
}

class SecondaryAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instanceFor(app: Firebase.app("sec"));
  final DataBaseServices db = DataBaseServices();

  Future registerWithEmailAndPassword(String email, String password,
      String name, String clas, String div, String admin) async {
    UserCredential userC = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userC.user;
    if (user != null) {
      await DataBaseServices().updateUser(user.uid, name, clas, div, admin);
    }
  }
}
