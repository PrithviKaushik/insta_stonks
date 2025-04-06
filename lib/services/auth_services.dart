import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SignIn {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return _auth.signInWithCredential(credential);
    } on Exception catch (e) {
      return Future.error('Error during Google Sign-in service: $e');
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the Facebook Login
      final LoginResult result = await _facebookAuth.login();
      // Get the Facebook authentication credentials
      if (result.status == LoginStatus.success) {
        final AccessToken fbToken = result.accessToken!;
        final OAuthCredential credential = FacebookAuthProvider.credential(
          fbToken.tokenString,
        );
        // Sign in to Firebase with Facebook credentials
        return await _auth.signInWithCredential(credential);
      } else {
        return Future.error("Facebook login failed: ${result.message}");
      }
    } on Exception catch (e) {
      return Future.error("Error during Facebook sign-in service: $e");
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Future.error('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return Future.error('Wrong password provided for that user.');
      }
    } catch (e) {
      return Future.error(e);
    }
    return null;
  }

  Future<UserCredential?> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(
        name,
      ); //updating user's name with provided name

      await credential.user
          ?.reload(); //reloading user to ensure name is updated
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Future.error('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return Future.error('The account already exists for that email.');
      }
    } catch (e) {
      return Future.error(e);
    }
    return null;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();

    await _facebookAuth.logOut();
    await _auth.signOut();
    await Future.delayed(Duration(milliseconds: 500)); // Ensures state updates
  }
}
