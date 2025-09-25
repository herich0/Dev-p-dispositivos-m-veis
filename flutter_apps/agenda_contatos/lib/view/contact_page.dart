import 'package:agenda_contatos/database/helper/contact_helper.dart';
import 'package:agenda_contatos/database/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;
  const ContactPage({Key? key, this.contact}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact? _editContact;
  bool _userEdited = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _imgController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final ContactHelper helper = ContactHelper();

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editContact = Contact(name: "", email: "", phone: "", image: "");
    } else {
      _editContact = widget.contact;
      _nameController.text = _editContact?.name ?? "";
      _emailController.text = _editContact?.email ?? "";
      _phoneController.text = _editContact?.phone ?? "";
      _imgController.text = _editContact?.image ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  Future<void> _selectImage() async {

  }

  void _saveContact(){}
}