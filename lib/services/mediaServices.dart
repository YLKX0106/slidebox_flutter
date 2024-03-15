import 'dart:async';

import 'package:photo_manager/photo_manager.dart';

class MediaServices {
  void getPermission() async {
    var permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
      PhotoManager.openSetting();
    }
  }

  // 获取album
  Future loadAlbums(RequestType requestType) async {
    // 请求权限
    var permission = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albumList = [];
    if (permission.isAuth == true) {
      // 获取album
      albumList = await PhotoManager.getAssetPathList(
        type: requestType,
        // TODO 注意筛选器
        filterOption: AdvancedCustomFilter(
          orderBy: [
            OrderByItem.named(
              column: CustomColumns.base.createDate,
              isAsc: false,
            ),
          ],
        ),
      );
    } else {
      PhotoManager.openSetting();
    }
    return albumList;
  }

  // 加载photo
  Future loadAssets(AssetPathEntity assetPathEntity) async {
    var a=await assetPathEntity.assetCountAsync;
    List<AssetEntity> assetList = await assetPathEntity.getAssetListRange(
      start: 0,
      end: await assetPathEntity.assetCountAsync,
    );
    return assetList;
  }
}
