import 'package:firebase_database/firebase_database.dart';

class User {
  String id;
  String pw;
  String createTiime;

  User(this.id, this.pw, this.createTiime);

  User.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.value['id'],
        pw = snapshot.value['pw'],
        createTiime = snapshot.value['createTiime'];
  toJson() {
    return {
      'id': id,
      'pw': pw,
      'createTiime': createTiime,
    };
  }
}
