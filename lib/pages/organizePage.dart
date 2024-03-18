import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'doingPage.dart';
import '../services/mediaServices.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class OrganizePage extends StatefulWidget {
  const OrganizePage({super.key});

  @override
  State<OrganizePage> createState() => _OrganizePageState();
}

class _OrganizePageState extends State<OrganizePage> {
  List<AssetPathEntity> albumList = [];
  bool isPermission=false;

  @override
  void initState() {
    if (isPermission == false) {
      _getisPermission();
    }
    _getAlbum();
    super.initState();
  }

  _getisPermission() async {
    final result = await MediaServices().requestPermission();
    isPermission = result;
    if (result == false) {
      SmartDialog.showToast('请给予软件存储权限');
    }
  }

  _getAlbum() {
    MediaServices().loadAlbums(RequestType.image).then(
      (value) {
        setState(() {
          albumList = value;
          albumList.removeAt(0);
        });
        // load recent assets
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    _getAlbum();
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'ORGANIZE',
            style: TextStyle(fontSize: 20, letterSpacing: 2),
          ),
          // backgroundColor: Colors.black,
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.delete))],
          centerTitle: true,
        ),
        body: ListView(
          children: [
            // const ListTile(title: Text('未分类')),
            const ListTile(title: Text('相册')),
            ...albumList.map((e) => GestureDetector(
                  onTap: () async {
                    // print(e);
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => DoingPage(
                                  assetPathEntity: e,
                                )));
                    setState(() {
                      _getAlbum();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.transparent),
                      color: Colors.grey[700],
                    ),
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
                    child: Stack(children: [
                      Text(e.name),
                      FutureBuilder(
                        future: e.assetCountAsync,
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          } else {
                            return Positioned(
                              right: 0,
                              child: Text(
                                snapshot.data.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }
                        },
                      )
                    ]),
                  ),
                )),
          ],
        ));
  }
}
