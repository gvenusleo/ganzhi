import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ganzhi/global.dart';
import 'package:ganzhi/pages/setting_page.dart';
import 'package:lunar/lunar.dart';
import 'package:selector_wheel/selector_wheel.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Lunar _lunar = Lunar.fromDate(DateTime.now());
  late String _nongli;
  late String _yearGanZhi;
  late String _monthGanZhi;
  late String _dayGanZhi;
  late String _yuexiang;
  final List<String> _suoding = ["年", "月", "日"];

  final Widget _divder = const Divider(
    height: 0,
    indent: 18,
    endIndent: 18,
  );

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("天干地支换算"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingPage(),
                ),
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: DateTime(
              _lunar.getSolar().getYear(),
              _lunar.getSolar().getMonth(),
              _lunar.getSolar().getDay(),
            ),
            firstDay: DateTime(1),
            lastDay: DateTime(9999),
            locale: "zh",
            selectedDayPredicate: (day) {
              return isSameDay(
                  DateTime(
                    _lunar.getSolar().getYear(),
                    _lunar.getSolar().getMonth(),
                    _lunar.getSolar().getDay(),
                  ),
                  day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _lunar = Lunar.fromDate(selectedDay);
              });
              _getData();
            },
            rowHeight: 36,
            daysOfWeekHeight: 24,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              headerPadding: EdgeInsets.all(0),
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              cellMargin: const EdgeInsets.all(0),
              cellPadding: const EdgeInsets.all(0),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.fromLTRB(18, 12, 18, 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      title: const Text("公历"),
                      trailing: Text(
                        "${_lunar.getSolar().getYear()}年${_lunar.getSolar().getMonth()}月${_lunar.getSolar().getDay()}日",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: _setGongli,
                      onLongPress: (prefs.getBool("copyWhenLongPress") ?? true)
                          ? () {
                              final data = ClipboardData(
                                text:
                                    "${_lunar.getSolar().getYear()}年${_lunar.getSolar().getMonth()}月${_lunar.getSolar().getDay()}日",
                              );
                              Clipboard.setData(data);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("已复制到剪贴板"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          : null,
                    ),
                    _divder,
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      title: const Text("农历"),
                      trailing: Text(
                        _nongli,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: _setNongli,
                      onLongPress: (prefs.getBool("copyWhenLongPress") ?? true)
                          ? () {
                              final data = ClipboardData(
                                text: _nongli,
                              );
                              Clipboard.setData(data);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("已复制到剪贴板"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          : null,
                    ),
                    _divder,
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      title: const Text("干支（年）"),
                      trailing: Text(
                        _yearGanZhi,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () => _setGanzhi("年"),
                      onLongPress: (prefs.getBool("copyWhenLongPress") ?? true)
                          ? () {
                              final data = ClipboardData(
                                text: _yearGanZhi,
                              );
                              Clipboard.setData(data);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("已复制到剪贴板"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          : null,
                    ),
                    _divder,
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      title: const Text("干支（月）"),
                      trailing: Text(
                        _monthGanZhi,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () => _setGanzhi("月"),
                      onLongPress: (prefs.getBool("copyWhenLongPress") ?? true)
                          ? () {
                              final data = ClipboardData(
                                text: _monthGanZhi,
                              );
                              Clipboard.setData(data);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("已复制到剪贴板"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          : null,
                    ),
                    _divder,
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      title: const Text("干支（日）"),
                      trailing: Text(
                        _dayGanZhi,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () => _setGanzhi("日"),
                      onLongPress: (prefs.getBool("copyWhenLongPress") ?? true)
                          ? () {
                              final data = ClipboardData(
                                text: _dayGanZhi,
                              );
                              Clipboard.setData(data);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("已复制到剪贴板"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          : null,
                    ),
                    _divder,
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      title: const Text("月相"),
                      trailing: Text(
                        _yuexiang,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onLongPress: (prefs.getBool("copyWhenLongPress") ?? true)
                          ? () {
                              final data = ClipboardData(
                                text: _yuexiang,
                              );
                              Clipboard.setData(data);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("已复制到剪贴板"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      child: Text(
                        "干支锁定查找",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 4,
                        children: [
                          FilterChip(
                            label: const Text("年"),
                            selected: _suoding.contains("年"),
                            onSelected: (value) {
                              if (value == false && _suoding.length == 2) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("干支锁定至少为 2 个"),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }
                              if (_suoding.contains("年")) {
                                setState(() {
                                  _suoding.remove("年");
                                });
                              } else {
                                setState(() {
                                  _suoding.add("年");
                                });
                              }
                            },
                          ),
                          FilterChip(
                            label: const Text("月"),
                            selected: _suoding.contains("月"),
                            onSelected: (value) {
                              if (value == false && _suoding.length == 2) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("干支锁定至少为 2 个"),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }
                              if (_suoding.contains("月")) {
                                setState(() {
                                  _suoding.remove("月");
                                });
                              } else {
                                setState(() {
                                  _suoding.add("月");
                                });
                              }
                            },
                          ),
                          FilterChip(
                            label: const Text("日"),
                            selected: _suoding.contains("日"),
                            onSelected: (value) {
                              if (value == false && _suoding.length == 2) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("干支锁定至少为 2 个"),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }
                              if (_suoding.contains("日")) {
                                setState(() {
                                  _suoding.remove("日");
                                });
                              } else {
                                setState(() {
                                  _suoding.add("日");
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton.outlined(
                            onPressed: () {
                              String result = _getLast();
                              if (result != "success") {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.arrow_back_ios_outlined)),
                        IconButton.outlined(
                          onPressed: () {
                            String result = _getNext();
                            if (result != "success") {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.arrow_forward_ios_outlined),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _getData() {
    setState(() {
      _nongli = _lunar.toString();
      _yearGanZhi = _lunar.getYearInGanZhi();
      _monthGanZhi = _lunar.getMonthInGanZhi();
      _dayGanZhi = _lunar.getDayInGanZhi();
      _yuexiang = _lunar.getYueXiang();
    });
  }

  Future<void> _setGongli() async {
    final control = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.edit_calendar_outlined),
          title: const Text("公历"),
          content: TextField(
            autofocus: true,
            controller: control,
            keyboardType: TextInputType.datetime,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              labelText: "输入公历日期",
              hintText: "2023-10-28",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                try {
                  List<String> dateList = control.text.split("-").toList();
                  final date = DateTime.parse(
                      "${dateList[0].padLeft(4, "0")}-${dateList[1].padLeft(2, "0")}-${dateList[2].padLeft(2, "0")}");
                  if (date.isBefore(DateTime(9999)) &&
                      date.isAfter(DateTime(1))) {
                    setState(() {
                      _lunar = Lunar.fromDate(date);
                    });
                    _getData();
                  } else {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("日期超出范围"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("日期格式错误"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text("确定"),
            ),
          ],
          contentPadding: const EdgeInsets.all(18),
          actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        );
      },
    );
  }

  Future<void> _setNongli() async {
    final control = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.edit_calendar_outlined),
          title: const Text("农历"),
          content: TextField(
            autofocus: true,
            controller: control,
            keyboardType: TextInputType.datetime,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              labelText: "输入农历日期",
              hintText: "2023-09-14",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                try {
                  List<String> dateList = control.text.split("-").toList();
                  Lunar lunar = Lunar.fromYmd(
                    int.parse(dateList[0]),
                    int.parse(dateList[1]),
                    int.parse(dateList[2]),
                  );
                  if (lunar
                          .getSolar()
                          .isBefore(Solar.fromDate(DateTime(9999))) &&
                      lunar.getSolar().isAfter(Solar.fromDate(DateTime(1)))) {
                    setState(() {
                      _lunar = lunar;
                    });
                    _getData();
                  } else {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("日期超出范围"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("日期格式错误"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text("确定"),
            ),
          ],
          contentPadding: const EdgeInsets.all(18),
          actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        );
      },
    );
  }

  Future<void> _setGanzhi(String mode) async {
    List<String> tiangan = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"];
    List<String> dizhi = [
      "子",
      "丑",
      "寅",
      "卯",
      "辰",
      "巳",
      "午",
      "未",
      "申",
      "酉",
      "戌",
      "亥"
    ];
    late String selectedTiangan;
    late String selectedDizhi;
    switch (mode) {
      case "年":
        selectedTiangan = _yearGanZhi.substring(0, 1);
        selectedDizhi = _yearGanZhi.substring(1, 2);
        break;
      case "月":
        selectedTiangan = _monthGanZhi.substring(0, 1);
        selectedDizhi = _monthGanZhi.substring(1, 2);
      case "日":
        selectedTiangan = _dayGanZhi.substring(0, 1);
        selectedDizhi = _dayGanZhi.substring(1, 2);
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.edit_calendar_outlined),
          title: Text("选择干支（$mode）"),
          content: SizedBox(
            height: 140,
            width: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                          surface: Colors.transparent,
                        ),
                  ),
                  child: SelectorWheel(
                    childCount: 10,
                    width: 40,
                    selectedItemIndex: tiangan.indexOf(selectedTiangan),
                    highlightBorderRadius: BorderRadius.circular(8),
                    convertIndexToValue: (int index) {
                      return SelectorWheelValue(
                        label: tiangan[index],
                        value: tiangan[index],
                        index: index,
                      );
                    },
                    onValueChanged: (SelectorWheelValue<String> value) {
                      selectedTiangan = value.value;
                    },
                  ),
                ),
                const SizedBox(
                  width: 60,
                  child: Icon(Icons.add_outlined),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                          surface: Colors.transparent,
                        ),
                  ),
                  child: SelectorWheel(
                    width: 40,
                    childCount: 12,
                    selectedItemIndex: dizhi.indexOf(selectedDizhi),
                    highlightBorderRadius: BorderRadius.circular(8),
                    convertIndexToValue: (int index) {
                      return SelectorWheelValue(
                        label: dizhi[index],
                        value: dizhi[index],
                        index: index,
                      );
                    },
                    onValueChanged: (SelectorWheelValue<String> value) {
                      selectedDizhi = value.value;
                    },
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  switch (mode) {
                    case "年":
                      if ((tiangan.indexOf(selectedTiangan) +
                                  dizhi.indexOf(selectedDizhi)) %
                              2 !=
                          0) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("干支不存在"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      _getLunarByYearGanzhi(selectedTiangan + selectedDizhi);
                      break;
                    case "月":
                      if ((tiangan.indexOf(selectedTiangan) +
                                  dizhi.indexOf(selectedDizhi)) %
                              2 !=
                          0) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("干支不存在"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      String result = _getLunarByMonthGanzhi(
                        selectedTiangan + selectedDizhi,
                      );
                      if (result != "success") {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                      break;
                    case "日":
                      if ((tiangan.indexOf(selectedTiangan) +
                                  dizhi.indexOf(selectedDizhi)) %
                              2 !=
                          0) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("干支不存在"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      String result = _getLunarByDayGanzhi(
                        selectedTiangan + selectedDizhi,
                      );
                      if (result != "success") {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                      return;
                  }
                });
              },
              child: const Text("确定"),
            ),
          ],
        );
      },
    );
  }

  String _getLunarByYearGanzhi(String ganzhi) {
    for (int i = 1; i <= 9999; i++) {
      final Lunar lunar = Lunar.fromYmd(i, 1, 1);
      if (lunar.getYearInGanZhi() == ganzhi) {
        final DateTime date = DateTime(
          lunar.getSolar().getYear(),
          lunar.getSolar().getMonth(),
          lunar.getSolar().getDay(),
        );
        if (date.isAfter(DateTime(1, 1, 1)) &&
            date.isBefore(DateTime(9999, 12, 31))) {
          setState(() {
            _lunar = lunar;
          });
          _getData();
        }
        break;
      }
    }
    return "success";
  }

  String _getLunarByMonthGanzhi(String ganzhi) {
    Lunar lunar = Lunar.fromYmd(_lunar.getYear(), 1, 1);
    while (true) {
      if (lunar.getYearInGanZhi() == _yearGanZhi) {
        if (lunar.getMonthInGanZhi() == ganzhi) {
          setState(() {
            _lunar = lunar;
          });
          _getData();
          return "success";
        } else {
          lunar = lunar.next(1);
        }
      } else {
        lunar = Lunar.fromYmd(lunar.getYear() + 59, 1, 1);
      }
      final date = lunar.getSolar();
      if (date.isBefore(Solar.fromYmd(1, 1, 1)) ||
          date.isAfter(Solar.fromYmd(9999, 12, 31))) {
        return "$_yearGanZhi年不存在$ganzhi月";
      }
    }
  }

  String _getLunarByDayGanzhi(String ganzhi) {
    Lunar lunar = Lunar.fromYmd(_lunar.getYear(), 1, 1);
    while (true) {
      if (lunar.getYearInGanZhi() == _yearGanZhi) {
        if (lunar.getMonthInGanZhi() == _monthGanZhi &&
            lunar.getDayInGanZhi() == ganzhi) {
          setState(() {
            _lunar = lunar;
          });
          _getData();
          return "success";
        } else {
          lunar = lunar.next(1);
        }
      } else {
        lunar = Lunar.fromYmd(lunar.getYear() + 59, 1, 1);
      }
      final date = lunar.getSolar();
      if (date.isBefore(Solar.fromYmd(1, 1, 1)) ||
          date.isAfter(Solar.fromYmd(9999, 12, 31))) {
        return "$_yearGanZhi年$_monthGanZhi月不存在$ganzhi日";
      }
    }
  }

  String _getNext() {
    _suoding.sort(((a, b) => a.compareTo(b)));
    String mode = _suoding.join("");
    switch (mode) {
      case "年日月":
        Lunar lunar = Lunar.fromYmd(_lunar.getYear() + 60, 1, 1);
        while (true) {
          if (lunar.getYearInGanZhi() == _yearGanZhi) {
            if (lunar.getMonthInGanZhi() == _monthGanZhi &&
                lunar.getDayInGanZhi() == _dayGanZhi) {
              setState(() {
                _lunar = lunar;
              });
              _getData();
              return "success";
            } else {
              lunar = lunar.next(1);
            }
          } else {
            lunar = Lunar.fromYmd(lunar.getYear() + 59, 1, 1);
          }
          final date = lunar.getSolar();
          if (date.isBefore(Solar.fromYmd(1, 1, 1)) ||
              date.isAfter(Solar.fromYmd(9999, 12, 31))) {
            return "不存在下一个";
          }
        }
      case "年月":
        Lunar lunar = _lunar.next(1);
        while (true) {
          if (lunar.getYearInGanZhi() == _yearGanZhi) {
            if (lunar.getMonthInGanZhi() == _monthGanZhi) {
              setState(() {
                _lunar = lunar;
              });
              _getData();
              return "success";
            } else {
              lunar = lunar.next(1);
            }
          } else {
            lunar = Lunar.fromYmd(lunar.getYear() + 59, 1, 1);
          }
          final date = lunar.getSolar();
          if (date.isBefore(Solar.fromYmd(1, 1, 1)) ||
              date.isAfter(Solar.fromYmd(9999, 12, 31))) {
            return "不存在下一个";
          }
        }
      case "年日":
        Lunar lunar = _lunar.next(1);
        while (true) {
          if (lunar.getYearInGanZhi() == _yearGanZhi) {
            if (lunar.getDayInGanZhi() == _dayGanZhi) {
              setState(() {
                _lunar = lunar;
              });
              _getData();
              return "success";
            } else {
              lunar = lunar.next(1);
            }
          } else {
            lunar = Lunar.fromYmd(lunar.getYear() + 59, 1, 1);
          }
          final date = lunar.getSolar();
          if (date.isBefore(Solar.fromYmd(1, 1, 1)) ||
              date.isAfter(Solar.fromYmd(9999, 12, 31))) {
            return "不存在下一个";
          }
        }
      case "日月":
        Lunar lunar = _lunar.next(1);
        while (true) {
          if (lunar.getMonthInGanZhi() == _monthGanZhi &&
              lunar.getDayInGanZhi() == _dayGanZhi) {
            setState(() {
              _lunar = lunar;
            });
            _getData();
            return "success";
          } else {
            lunar = lunar.next(1);
          }
          final date = lunar.getSolar();
          if (date.isBefore(Solar.fromYmd(1, 1, 1)) ||
              date.isAfter(Solar.fromYmd(9999, 12, 31))) {
            return "不存在下一个";
          }
        }
      case "":
        return "干支锁定查找为空";
    }
    return "ERROR";
  }

  String _getLast() {
    _suoding.sort(((a, b) => a.compareTo(b)));
    String mode = _suoding.join("");
    switch (mode) {
      case "年日月":
        Lunar lunar = Lunar.fromYmd(_lunar.getYear() - 59, 1, 1).next(-1);
        while (true) {
          if (lunar.getYearInGanZhi() == _yearGanZhi) {
            if (lunar.getMonthInGanZhi() == _monthGanZhi &&
                lunar.getDayInGanZhi() == _dayGanZhi) {
              setState(() {
                _lunar = lunar;
              });
              _getData();
              return "success";
            } else {
              lunar = lunar.next(-1);
            }
          } else {
            lunar = Lunar.fromYmd(lunar.getYear() - 58, 1, 1).next(-1);
          }
          final date = lunar.getSolar();
          if (date.isBefore(Solar.fromYmd(1, 1, 1)) ||
              date.isAfter(Solar.fromYmd(9999, 12, 31))) {
            return "不存在上一个";
          }
        }
      case "年月":
        Lunar lunar = _lunar.next(-1);
        while (true) {
          if (lunar.getYearInGanZhi() == _yearGanZhi) {
            if (lunar.getMonthInGanZhi() == _monthGanZhi) {
              setState(() {
                _lunar = lunar;
              });
              _getData();
              return "success";
            } else {
              lunar = lunar.next(-1);
            }
          } else {
            lunar = Lunar.fromYmd(lunar.getYear() - 58, 1, 1).next(-1);
          }
          final date = lunar.getSolar();
          if (date.isBefore(Solar.fromYmd(1, 1, 1)) ||
              date.isAfter(Solar.fromYmd(9999, 12, 31))) {
            return "不存在下一个";
          }
        }
      case "年日":
        Lunar lunar = _lunar.next(-1);
        while (true) {
          if (lunar.getYearInGanZhi() == _yearGanZhi) {
            if (lunar.getDayInGanZhi() == _dayGanZhi) {
              setState(() {
                _lunar = lunar;
              });
              _getData();
              return "success";
            } else {
              lunar = lunar.next(-1);
            }
          } else {
            lunar = Lunar.fromYmd(lunar.getYear() - 58, 1, 1).next(-1);
          }
          final date = lunar.getSolar();
          if (date.isBefore(Solar.fromYmd(1, 1, 1)) ||
              date.isAfter(Solar.fromYmd(9999, 12, 31))) {
            return "不存在下一个";
          }
        }
      case "日月":
        Lunar lunar = _lunar.next(-1);
        while (true) {
          if (lunar.getMonthInGanZhi() == _monthGanZhi &&
              lunar.getDayInGanZhi() == _dayGanZhi) {
            setState(() {
              _lunar = lunar;
            });
            _getData();
            return "success";
          } else {
            lunar = lunar.next(-1);
          }
          final date = lunar.getSolar();
          if (date.isBefore(Solar.fromYmd(1, 1, 1)) ||
              date.isAfter(Solar.fromYmd(9999, 12, 31))) {
            return "不存在下一个";
          }
        }
      case "":
        return "干支锁定查找为空";
    }
    return "ERROR";
  }
}
