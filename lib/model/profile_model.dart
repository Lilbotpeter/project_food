class PersonModel {
  //Field
  late String email, pathImage, name, phone, uid;

  //Method
  PersonModel(this.email, this.name, this.pathImage, this.phone, this.uid);

  PersonModel.fromMap(Map<String, dynamic> dataMap) {
    email = dataMap['Email'];
    pathImage = dataMap['ImageP'];
    name = dataMap['Name'];
    phone = dataMap['Phone'];
    uid = dataMap['Uid'];
  } //setter

  Map<String, dynamic> toJson() => {
        'Email': email,
        'ImageP': pathImage,
        'Name': name,
        'Phone': phone,
        'Uid': uid,
      };
}
