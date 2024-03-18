import 'dart:async';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaServices {

  // 获取album
  Future loadAlbums(RequestType requestType) async {
    List<AssetPathEntity> albumList = [];
    albumList = await PhotoManager.getAssetPathList(
        type: requestType,
        filterOption: CustomFilter.sql(
            where: "${CustomColumns.base.mediaType} = 1 AND ${CustomColumns.android.relativePath} LIKE '%Pictures%'",
            orderBy: [OrderByItem.desc(CustomColumns.base.createDate)]));
    return albumList;
  }

  // 加载photo
  Future loadAssets(AssetPathEntity assetPathEntity) async {
    var a = await assetPathEntity.assetCountAsync;
    List<AssetEntity> assetList = await assetPathEntity.getAssetListRange(
      start: 0,
      end: await assetPathEntity.assetCountAsync,
    );
    return assetList;
  }
  // 请求权限
  Future requestPermission() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth==true){
      final result=await Permission.manageExternalStorage.request();
      if(result.isGranted){
        // SmartDialog.showToast('已获取权限');
        return true;
      }
      else{
        // SmartDialog.showToast('请给予软件存储权限');
        return false;
      }
    }else{
      // SmartDialog.showToast('请给予软件存储权限');
      return false;
    }
  }


}
