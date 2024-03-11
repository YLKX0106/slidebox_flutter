import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../services/mediaServices.dart';
import 'photoPage.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
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
          'ALBUM',
          style: TextStyle(fontSize: 20, letterSpacing: 2),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const ListTile(
                            title: Text('创建新相册'),
                            subtitle: Text(
                              '在安卓系统值创建一个新相册',
                              // style: TextStyle(color: Colors.black26),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              '取消',
                              // style: TextStyle(color: Colors.grey[600]),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.add)),
        ],
        centerTitle: true,
      ),
      body: Center(
          child: albumList.isEmpty
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                )
              : ListView(
                  children: albumList
                      .map(
                        (AssetPathEntity assetPathEntity) => GestureDetector(
                          child: ListTile(
                              title: Text(assetPathEntity.name),
                              trailing: FutureBuilder(
                                future: _getAlbumCount(assetPathEntity),
                                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  } else {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: TextStyle(fontSize: 12),
                                    );
                                  }
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MediaPicker(assetPathEntity: assetPathEntity)));
                              }),
                        ),
                      )
                      .toList(),
                )),
    );
  }
}
