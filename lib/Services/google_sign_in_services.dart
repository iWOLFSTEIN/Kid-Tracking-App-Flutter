import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Services/Firebase/firebase_create_user_services.dart';
import 'package:kids_tracking_app/Services/Firebase/firebase_messaging_services.dart';

class GoogleSignInServies {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final authResult = await firebaseAuth.signInWithCredential(credential);

    if (authResult.additionalUserInfo!.isNewUser) {
      // databaseServices.createUser(email: authResult.user!.email);
      await createUser(
          userEmail: authResult.user!.email,
          name: authResult.user!.displayName,
          profilePic: authResult.user!.photoURL);
    }
    else{
      uploadDeviceTokenToFirebase(userEmail: authResult.user!.email);
    }

    final User? user = authResult.user;

    assert(!user!.isAnonymous);
    assert(await user!.getIdToken() != null);

    final User? currentUser = firebaseAuth.currentUser;
    assert(user!.uid == currentUser!.uid);

    return currentUser;
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }
}
