import "package:flutter/material.dart";
import "package:ganzhi/global.dart";

/// 主题状态监听
class ThemeProvider extends ChangeNotifier {
  /// 主题背景
  int themeMode = prefs.getInt("themeMode") ?? 0;

  /// 切换主题背景
  Future<void> changeThemeMode(int mode) async {
    themeMode = mode;
    notifyListeners();
    await prefs.setInt("themeMode", mode);
  }
}
