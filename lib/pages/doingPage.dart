import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../services/mediaServices.dart';

class DoingPage extends StatefulWidget {
  AssetPathEntity assetPathEntity;

  DoingPage({required this.assetPathEntity, super.key});

  @override
  State<DoingPage> createState() => _DoingPageState();
}

class _DoingPageState extends State<DoingPage> {
  List<AssetEntity> _changeImage = [];
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];
  Set<AssetEntity> assetDeleteList = Set();
  List<File> assetFileList = [];
  int _assetIndex = 0;
  Map albumSelectedMap = {};

  List<PhotoViewGalleryPageOptions> photoGalleryList = [];

  @override
  void initState() {
    MediaServices().loadAlbums(RequestType.all).then(
      (value) {
        setState(() {
          albumList = value;
          albumList.removeAt(0);
          albumList.forEach((element) {
            albumSelectedMap.addAll({element.name: []});
          });
        });
      },
    );
    MediaServices().loadAssets(widget.assetPathEntity).then((value) => setState(() {
          assetList = value;
          _getImageString();
        }));
    super.initState();
  }

  _getImageFile() {
    return PhotoViewGallery(
      pageOptions: assetFileList
          .map((e) => PhotoViewGalleryPageOptions(
                imageProvider: FileImage(e),
                disableGestures: true,
              ))
          .toList(),
      onPageChanged: (index) {
        setState(() {
          _assetIndex = index;
        });
      },
    );
  }

  _getImageString() {
    assetFileList.clear();
    if (assetList.length != assetFileList.length) {
      assetList.forEach((element) async {
        var a = await element.originFile;
        assetFileList.add(a!);
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [Text(widget.assetPathEntity.name), Text('${_assetIndex + 1}/${assetList.length}')],
        ),
        leading: const Icon(Icons.refresh),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          )
        ],
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: assetFileList.isEmpty
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : _getImageFile(),
          ),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.blue),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                          color: Colors.grey),
                      child: const Center(child: Text('移动到相册'))),
                ),
                Expanded(
                    flex: 4,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...albumList.map((e) => ElevatedButton(
                              onPressed: () {
                                albumSelectedMap[e.name].add(assetList[_assetIndex]);
                                assetList.remove(assetList[_assetIndex]);
                                setState(() {
                                  _getImageString();
                                  if(assetList.isEmpty){
                                    // TODO 显示全部分类完成,1.phsh,2.弹窗
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.download),
                                  Text(e.name),
                                ],
                              ),
                            ))
                      ],
                    ))
              ],
            ),
          ),
          Row(
            children: [
              Expanded(flex: 1, child: TextButton(onPressed: () {}, child: const Text('取消'))),
              _changeImage.isEmpty
                  ? const Expanded(flex: 3, child: TextButton(onPressed: null, child: Text('没有待定的图片')))
                  : Expanded(flex: 3, child: TextButton(onPressed: () {}, child: Text('${_changeImage.length}张照片'))),
              Expanded(flex: 1, child: TextButton(onPressed: () {}, child: const Text('完成'))),
            ],
          ),
        ],
      ),
    );
  }
}
