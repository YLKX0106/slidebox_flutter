import 'package:untitled2/pages/imagePage.dart';

import '../services/mediaServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class MediaPicker extends StatefulWidget {
  final AssetPathEntity assetPathEntity;

  const MediaPicker({super.key, required this.assetPathEntity});

  @override
  State<MediaPicker> createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  AssetPathEntity? selectedAlbum;
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];
  late int _albumCount;

  // List<AssetEntity> selectedAssetList = [];

  @override
  void initState() {
    // TODO: implement initState
    MediaServices().loadAssets(widget.assetPathEntity).then((value) => setState(() {
          assetList = value;
        }));
    super.initState();
  }

  // Future<int> getImageCount(AssetPathEntity path) async {
  //   int count = await path.assetCountAsync;
  //   return count;
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.assetPathEntity.name),
        centerTitle: true,
        // backgroundColor: ColorScheme.onPrimary,
      ),
      body: assetList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: assetList.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                AssetEntity assetEntity = assetList[index];
                return Padding(
                  padding: const EdgeInsets.all(3),
                  child: assetWidget(assetEntity),
                );
              },
            ),
    ));
  }

  Widget assetWidget(AssetEntity assetEntity) => GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ImagePage(
                      assetEntity: assetEntity,
                      albumName: widget.assetPathEntity.name,
                      assetEntityIndex: assetList.indexOf(assetEntity),
                      assetPathEntityCount: assetList.length,
                    )));
      },
      child: AssetEntityImage(
        assetEntity,
        isOriginal: false,
        thumbnailSize: const ThumbnailSize.square(250),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.error,
              color: Colors.red,
            ),
          );
        },
      ));
}
