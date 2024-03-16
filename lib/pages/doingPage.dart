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
  List<Map> _changeImage = [];
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
      pageController: PageController(
        initialPage: _assetIndex,
      ),
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

  _refresh() {
    if (_changeImage.isEmpty) {
      AlertDialog(
        title: Text('aaa'),
      );
    } else {
      setState(() {
        assetList.insert(_changeImage.last['index'], _changeImage.last['assetEntity']);
        assetFileList.insert(_changeImage.last['index'], _changeImage.last['file']);
        _assetIndex = _changeImage.last['index'];
        albumSelectedMap[_changeImage.last['album']].removeLast();
        _changeImage.removeLast();
      });
    }
  }

  void showBottomSheet() {
    //用于在底部打开弹框的效果
    showModalBottomSheet(
        builder: (BuildContext context) {
          //构建弹框中的内容
          return Container(
            height: 260,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(top: 0, left: 0, child: Text('应用图片改变?')),
                Positioned(
                  child: Text('- 移动 ${_changeImage.length} 张图片'),
                  top: 20,
                  left: 0,
                ),
                Align(
                  child: TextButton(
                    onPressed: () {},
                    child: Text('应用(${_changeImage.length})'),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white12)),
                  ),
                  alignment: Alignment.bottomCenter,
                )
              ],
            ),
          );
        },
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [Text(widget.assetPathEntity.name), Text('${_assetIndex + 1}/${assetList.length}')],
        ),
        leading: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            _refresh();
          },
        ),
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
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
                          color: Colors.black26),
                      child: const Center(child: Text('移动到相册'))),
                ),
                Expanded(
                    flex: 4,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...albumList.map((e) {
                          if (e == widget.assetPathEntity) {
                            return ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                  disabledBackgroundColor: Colors.transparent,
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
                            );
                          } else {
                            return ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _changeImage.add({
                                    'album': e.name,
                                    'assetEntity': assetList[_assetIndex],
                                    'index': _assetIndex,
                                    'file': assetFileList[_assetIndex],
                                  });
                                  albumSelectedMap[e.name].add(assetList[_assetIndex]);
                                  assetList.removeAt(_assetIndex);
                                  assetFileList.removeAt(_assetIndex);
                                  if (assetList.length + 1 <= _assetIndex + 1) {
                                    _assetIndex--;
                                  }
                                  // _getImageString();
                                });
                                if (assetList.isEmpty) {
                                  await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                    return DonePage();
                                  }));
                                  _refresh();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                                enableFeedback: false,
                              ),
                              child: Badge(
                                smallSize: 0,
                                label: albumSelectedMap[e.name].isEmpty
                                    ? null
                                    : Text('${albumSelectedMap[e.name].length}'),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.download),
                                    Text(e.name),
                                  ],
                                ),
                              ),
                            );
                          }
                        })
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
                  : Expanded(
                      flex: 3,
                      child: TextButton(
                          onPressed: () {
                            showBottomSheet();
                          },
                          child: Text('${_changeImage.length}张图片'))),
              Expanded(flex: 1, child: TextButton(onPressed: () {}, child: const Text('完成'))),
            ],
          ),
        ],
      ),
    );
  }
}

class DonePage extends StatelessWidget {
  const DonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check,
              size: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '完成!',
              style: TextStyle(fontSize: 30, height: 2, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('是否要应用到你的相册'),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white12)),
              child: const Text(
                '应用',
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
