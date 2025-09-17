import 'package:apk_gif/service/giphy_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = "";
  int _offset = 0;
  bool _loadingMore = false;
  bool _isSearching = false;
  List _gifData = [];
  final GiphyService giphyService = GiphyService();

  @override
  void initState() {
    super.initState();
    _loadGifs();
  }

  void _loadGifs() async {
    setState(() {
      _loadingMore = true;
    });
    var newGifs = await giphyService.getGifs(_search, _offset);
    setState(() {
      _loadingMore = false;
      _gifData.addAll((newGifs["data"]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
          "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif",
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (value) {
                setState(() {
                  _search = value;
                  _offset = 0;
                  _gifData.clear();
                  _isSearching = true;
                });
                _loadGifs();
              },
            ),
          ),
          Expanded(
            child: _gifData.isEmpty && !_loadingMore && !_isSearching
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5.0,
                    ),
                  )
                : _createGifTable(),
          ),
        ],
      ),
    );
  }

  Widget _createGifTable() {
    return Container();
  }
}
