import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../log.dart';
import '../ui/widgets/toast_widget.dart';

class AuthProvider with ChangeNotifier {
  bool isLoading = false;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  User? _user;

  User get user => _user!;

  set setIsLoading(val) {
    isLoading = val;
    notifyListeners();
  }

  set setSignedInUser(User user) {
    _user = user;
  }

  AuthProvider() {
    if (FirebaseAuth.instance.currentUser != null) {
      setSignedInUser = FirebaseAuth.instance.currentUser!;
    }
  }

  Future<void> signIn() async {
    setIsLoading = true;
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final firebaseAuth = FirebaseAuth.instance;
      await firebaseAuth.signInWithCredential(credential);
      setSignedInUser = firebaseAuth.currentUser!;
      ToastWidget.showToast("Logged in as ${firebaseAuth.currentUser!.email}");
    } on Exception catch (exception) {
      logger.e(exception.toString());
      ToastWidget.showToast('Something went wrong');
    } catch (error) {
      logger.e(error.toString());
      ToastWidget.showToast('Unexpected error occurred');
    } finally {
      setIsLoading = false;
    }
  }

  Future<void> signOut(context) async {
    setIsLoading = true;
    try {
      Navigator.pop(context);
      await FirebaseAuth.instance.signOut();
      await googleSignIn.disconnect();
      ToastWidget.showToast("Logged Out");
    } on Exception catch (exception) {
      debugPrint(exception.toString());
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      setIsLoading = false;
    }
  }
}
