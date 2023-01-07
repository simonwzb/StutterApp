/// 集合工具类
class CollectionUtil {
  /// 获取list的item
  static T? getListItem<T>(List<T> list, int index) {
    if (list == null || index < 0 || index >= list.length) {
      return null;
    }
    return list[index];
  }

  /// 是否为空
  static bool isEmpty<T>(List<T> list) {
    return list == null || list.length == 0;
  }

  /// 集合长度
  static int size<T>(List<T> list) {
    if (list == null) {
      return 0;
    }
    return list.length;
  }

  /// 获取位置
  static int getPosition<T>(List<T> list, T t) {
    if (list == null) {
      return -1;
    }
    return list.indexOf(t);
  }
}
