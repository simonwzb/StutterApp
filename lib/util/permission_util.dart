import 'package:permission_handler/permission_handler.dart';

/// 权限工具
class PermissionUtil{

  /// 检查权限
  static Future<bool> checkPermission(Permission permission) async {
    bool hasPermission = permission.status == PermissionStatus.granted;
    print("checkPermission $permission, hasPermission=$hasPermission");
    if (hasPermission) {
      return true;
    } else {
      ///提示用户请同意权限申请
      PermissionStatus permissionStatus = await permission.request();
      print("checkPermission request  $permission, permissionStatus=$permissionStatus");

      return permissionStatus == PermissionStatus.granted;
    }
  }

}