import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:store_demo_class/features/auth/domain/models/user_model.dart';

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final userProvider = StateNotifierProvider<UserNotifier, UserModel>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier()
    : super(
        UserModel(
          id: 'error',
          user: FirebaseUserModel(
            email: 'error',
            name: 'error',
            profilePic: 'error',
          ),
        ),
      );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> login(String email) async {
    QuerySnapshot response = await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();

    if (response.docs.isEmpty) {
      print("No se encontró usuario con email $email");
      return;
    }

    if (response.docs.length != 1) {
      print("Se encontraron múltiples usuarios con email $email");
      return;
    }

    state = UserModel(
      id: response.docs[0].id,
      user: FirebaseUserModel.fromJson(
        response.docs[0].data() as Map<String, dynamic>,
      ),
    );
  }

  Future<void> register(String email) async {
    // await _firestore.collection("users").doc(uid).set({"email": email, "name": 'No Name', "profilePic": 'https://www.gravatar.com/avatar/?d=mp'});
    DocumentReference response = await _firestore
        .collection('users')
        .add(
          FirebaseUserModel(
            email: email,
            name: 'Sin nombre',
            profilePic: 'https://www.gravatar.com/avatar/?d=mp',
          ).toMap(),
        );

    DocumentSnapshot snapshot = await response.get();

    state = UserModel(
      id: response.id,
      user: FirebaseUserModel.fromJson(snapshot.data() as Map<String, dynamic>),
    );
  }

  Future<void> updateName(String name) async {
    try {
      await _firestore.collection("users").doc(state.id).update({"name": name});
      state = state.copyWith(user: state.user.copyWith(name: name));
    } catch (e) {
      print("Error al actualizar el nombre: $e");
    }
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    state = UserModel(
      id: 'error',
      user: FirebaseUserModel(
        email: 'error',
        name: 'error',
        profilePic: 'error',
      ),
    );
  }
}
