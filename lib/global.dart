import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 应用版本号
String version = "v0.0.2";

/// 持久化存储
late SharedPreferences prefs;

/// 全局初始化
Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 下面的代码无法在 Web 上运行
  // if (Platform.isAndroid) {
  //   SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     systemNavigationBarColor: Colors.transparent,
  //     systemNavigationBarDividerColor: Colors.transparent,
  //   );
  //   SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  //   SystemChrome.setEnabledSystemUIMode(
  //     SystemUiMode.edgeToEdge,
  //   );
  // }
  prefs = await SharedPreferences.getInstance();
}
