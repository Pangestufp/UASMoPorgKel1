class UserModel {
  String uid;
  String namaUMKM;
  String alamatUMKM;

  UserModel({required this.uid, required this.namaUMKM, required this.alamatUMKM});

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'namaUMKM': namaUMKM,
      'alamatUMKM': alamatUMKM,
    };
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      namaUMKM: data['namaUMKM'],
      alamatUMKM: data['alamatUMKM'],
    );
  }
}
