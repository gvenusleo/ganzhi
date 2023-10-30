import 'package:flutter/material.dart';
import 'package:ganzhi/global.dart';
import 'package:ganzhi/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final List<String> _themeList = [
    "跟随系统",
    "浅色模式",
    "深色模式",
  ];
  bool _copyWhenLongPress = prefs.getBool("copyWhenLongPress") ?? true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("设置"),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 4, bottom: 32),
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text("主题背景"),
            subtitle:
                Text(_themeList[context.watch<ThemeProvider>().themeMode]),
            onTap: _setThemeMode,
          ),
          SwitchListTile(
            value: _copyWhenLongPress,
            onChanged: (value) {
              setState(() {
                _copyWhenLongPress = value;
              });
              prefs.setBool("copyWhenLongPress", value);
            },
            secondary: const Icon(Icons.copy_outlined),
            title: const Text("长按复制"),
            subtitle: const Text("长按结果时自动复制到剪贴板"),
          ),
        ],
      ),
    );
  }

  Future<void> _setThemeMode() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.dark_mode_outlined),
          title: const Text("主题背景"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _themeList
                .asMap()
                .map(
                  (index, value) => MapEntry(
                    index,
                    RadioListTile(
                      title: Text(value),
                      value: index,
                      groupValue: context.watch<ThemeProvider>().themeMode,
                      onChanged: (value) {
                        context.read<ThemeProvider>().changeThemeMode(index);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                )
                .values
                .toList(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("取消"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
        );
      },
    );
  }
}
