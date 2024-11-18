import 'package:firebase_auth/firebase_auth.dart';
import 'package:umkmfirebase/models/firebaseUser.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future signInEmailPassword(String email, String password) async {
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.toString(),
          password: password.toString()
      );
      User? user = userCredential.user;
      return _firebaseUser(user);
    }on FirebaseAuthException catch (e){
      return FirebaseUser(code: e.code, uid: null);
    }
  }


  Future<FirebaseUser> registerWithEmailPassword(String email, String password, String namaUMKM, String alamatUMKM) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          namaUMKM: namaUMKM,
          alamatUMKM: alamatUMKM,
        );

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(newUser.toFirestore());
        return FirebaseUser(code: 'success', uid: user.uid);
      } else {
        return FirebaseUser(code: 'user-not-found', uid: null);
      }
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    } catch (e) {
      return FirebaseUser(code: e.toString(), uid: null);
    }
  }


  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch (e){
      return null;
    }
  }

  FirebaseUser? _firebaseUser(User? user){
    return user!=null ? FirebaseUser(uid: user.uid) : null;
  }

  Stream<FirebaseUser?> get user{
    return _auth.authStateChanges().map(_firebaseUser);
  }

  Future<void> updateUserData(String uid, String namaUMKM, String alamatUMKM) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'namaUMKM': namaUMKM,
      'alamatUMKM': alamatUMKM,
    });
  }


}