import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kids_tracking_app/Services/Firebase/firebase_chat_related_services.dart';
import 'package:kids_tracking_app/Services/google_sign_in_services.dart';
import 'package:location/location.dart';

final firebaseAuth = FirebaseAuth.instance;
final googleSignInServices = GoogleSignInServies();
final firebaseFirestore = FirebaseFirestore.instance;
final firebaseChatRelatedServices = FirebaseChatRelatedServices();
final location = Location();

