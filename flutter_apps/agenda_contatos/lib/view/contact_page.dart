import 'dart:io';
import 'package:agenda_contatos/database/helper/contact_helper.dart';
import 'package:agenda_contatos/database/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  final ImagePicker _picker = ImagePicker();
  final ContactHelper _helper = ContactHelper();

  final phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editContact = Contact(name: "", email: "", phone: "", img: "");
    } else {
      _editContact = widget.contact;
      _nameController.text = _editContact?.name ?? "";
      _emailController.text = _editContact?.email ?? "";
      _phoneController.text = _editContact?.phone ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(_editContact?.name?.isNotEmpty == true
            ? _editContact!.name
            : "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveContact,
        backgroundColor: Colors.blue,
        child: Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: _selectImage,
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _editContact?.img != null &&
                            _editContact!.img!.isNotEmpty
                        ? FileImage(File(_editContact!.img!))
                        : const AssetImage("assets/imgs/profile2.png")
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (text) {
                _userEdited = true;
                _editContact?.name = text;
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
              onChanged: (text) {
                _userEdited = true;
                _editContact?.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Telefone"),
              onChanged: (text) {
                _userEdited = true;
                _editContact?.phone = text;
              },
              keyboardType: TextInputType.phone,
              inputFormatters: [phoneMask],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _editContact?.img = image.path;
      });
    }
  }

  void _saveContact() {
    final email = _emailController.text.trim();
    final phone = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Validação de nome
    if (_editContact?.name == null || _editContact!.name!.isEmpty) {
      _showMessage("Nome é obrigatório");
      return;
    }

    // Validação de e-mail (regex simples)
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (email.isNotEmpty && !emailRegex.hasMatch(email)) {
      _showMessage("Email inválido");
      return;
    }

    // Validação de tamanho do telefone
    if (phone.length < 10 || phone.length > 11) {
      _showMessage("Telefone deve ter 10 ou 11 dígitos");
      return;
    }

    // Salvar
    if (_editContact?.id != null) {
      _helper.updateContact(_editContact!);
    } else {
      _helper.saveContact(_editContact!);
    }
    Navigator.pop(context, _editContact);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
