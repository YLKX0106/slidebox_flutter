import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

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
            ListTile(title: Text('未分类')),
            ListTile(title: Text('相册')),
            ...albumList.map((e) => Text('${e.name}')),
          ],
        ));
  }
}
