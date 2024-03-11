import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';

class ImagePage extends StatefulWidget {
  final String albumName;
  AssetEntity assetEntity;
  final int assetEntityIndex;
  final int assetPathEntityCount;

  ImagePage(
      {super.key,
      required this.assetEntity,
      required this.albumName,
      required this.assetEntityIndex,
      required this.assetPathEntityCount});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          children: [
            Text(
              widget.albumName,
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
            Text(
              '${widget.assetEntityIndex + 1}/${widget.assetPathEntityCount}',
              style: const TextStyle(fontSize: 10, color: Colors.white),
            )
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            color: Colors.white,
            onPressed: () {},
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
              child: FutureBuilder(
            future: widget.assetEntity.originFile,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return PhotoView(
                  imageProvider: FileImage(snapshot.data),
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  enableRotation: false,
                );
              }
            },
          )),
          Positioned(
              bottom: 0,
              child: Container(
                height: 40,
                width: MediaQuery.sizeOf(context).width,
                color: Colors.black,
                child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              '移动',
                              style: TextStyle(fontSize: 15),
                            ))),
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () async{
                              // TODO 检测是否删除,重载页面
                              // var result=PhotoManager.editor.deleteWithIds([widget.assetEntity.id]);
                              // if(await widget.assetEntity.exists){
                              //   print('object');
                              // }
                              //
                            },
                            child: const Text('删除', style: TextStyle(fontSize: 15)))),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
