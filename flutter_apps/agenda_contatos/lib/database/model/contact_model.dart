String idColumn = "idColumn";
String nameColumn = "nameColumn";
String emailColumn = "emailColumn";
String phoneColumn = "phoneColumn";
String imageColumn = "imageColumn";
String tableContact = "contactTable";

class Contact {
  Contact({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
  });

  int? id;
  String name;
  String email;
  String phone;
  String? image;

  Contact.fromMap(Map<String, dynamic> map)
    : id = map[idColumn],
      name = map[nameColumn],
      email = map[emailColumn],
      phone = map[phoneColumn],
      image = map[imageColumn];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imageColumn: image,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    if (image !=null){
      map[imageColumn] = image;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, image: $image)";
  }
}
