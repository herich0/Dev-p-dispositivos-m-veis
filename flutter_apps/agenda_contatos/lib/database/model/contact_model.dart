String idColumn = "idColumn";
String nameColumn = "nameColumn";
String emailColumn = "emailColumn";
String phoneColumn = "phoneColumn";
String imageColumn = "imageColumn";
String contactTable = "contactTable";

class Contact {
  Contact({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.img,
  });

  int? id;
  String name;
  String email;
  String phone;
  String? img;

  Contact.fromMap(Map<String, dynamic> map)
    : id = map[idColumn],
      name = map[nameColumn],
      email = map[emailColumn],
      phone = map[phoneColumn],
      img = map[imageColumn];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imageColumn: img,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}