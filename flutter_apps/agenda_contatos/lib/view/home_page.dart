import 'dart:io';
import 'package:agenda_contatos/database/helper/contact_helper.dart';
import 'package:agenda_contatos/database/model/contact_model.dart';
import 'package:agenda_contatos/view/contact_page.dart';
import 'package:flutter/material.dart';

enum OrderOptions { orderAZ, orderZA }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda de Contatos"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderAZ,
                child: Text("Ordenar de A-Z"),
              ),
              const PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderZA,
                child: Text("Ordenar de Z-A"),
              ),
            ],
            onSelected: _orderList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].img != null
                        ? FileImage(File(contacts[index].img!))
                        : const AssetImage("assets/imgs/profile2.png")
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? "",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contacts[index].email ?? "",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      contacts[index].phone ?? "",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextButton(
                    child: Text(
                      "Ligar",
                      style: TextStyle(color: Colors.green, fontSize: 20.0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      // Implementar a funcionalidade de ligar se desejar
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Editar",
                      style: TextStyle(color: Colors.blue, fontSize: 20.0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _showContactPage(contact: contacts[index]);
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Excluir",
                      style: TextStyle(color: Colors.red, fontSize: 20.0),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      bool? confirmDelete = await _confirmDelete(context);
                      if (confirmDelete == true &&
                          contacts[index].id != null) {
                        await helper.deleteContact(contacts[index].id!);
                        setState(() {
                          contacts.removeAt(index);
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir Contato"),
        content:
            const Text("Tem certeza que deseja excluir este contato?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Excluir",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactPage({Contact? contact}) async {
    final updatedContact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact)),
    );
    if (updatedContact != null) {
      _loadContacts();
    }
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderAZ:
        contacts.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case OrderOptions.orderZA:
        contacts.sort(
            (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
    }
    setState(() {});
  }
}
