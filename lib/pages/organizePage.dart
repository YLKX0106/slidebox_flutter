import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'doingPage.dart';
import '../services/mediaServices.dart';

class OrganizePage extends StatefulWidget {
  const OrganizePage({super.key});

  @override
  State<OrganizePage> createState() => _OrganizePageState();
}

class _OrganizePageState extends State<OrganizePage> {
  List<AssetPathEntity> albumList = [];

  @override
  void initState() {
    MediaServices().loadAlbums(RequestType.all).then(
      (value) {
        setState(() {
          albumList = value;
        });
        // load recent assets
      },
    );
    super.initState();
  }

  Future<int> _getAlbumCount(AssetPathEntity assetPathEntity) async {
    int count = await assetPathEntity.assetCountAsync;
    return count;
  }

  @override
  Widget build(BuildContext context) {
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
            const ListTile(title: Text('未分类')),
            const ListTile(title: Text('相册')),
            ...albumList.map((e) => GestureDetector(
              onTap: (){
                // print(e);
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>DoingPage(assetPathEntity: e,)));
              },
              child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.red),
                      color: Colors.amber,
                    ),
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 10,left: 5,right: 5),
                    child: Stack(children: [
                      Text(e.name),
                      FutureBuilder(
                        future: _getAlbumCount(e),
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
