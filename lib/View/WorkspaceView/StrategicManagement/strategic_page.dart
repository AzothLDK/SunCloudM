import 'package:suncloudm/View/WorkspaceView/StrategicManagement/strategichistory_page.dart';
import 'package:suncloudm/View/WorkspaceView/StrategicManagement/strategicrunning_page.dart';
import 'package:suncloudm/toolview/imports.dart';

class StrategicPage extends StatefulWidget {
  const StrategicPage({super.key});

  @override
  State<StrategicPage> createState() => _StrategicPageState();
}

class _StrategicPageState extends State<StrategicPage>
    with SingleTickerProviderStateMixin {
  final List<Tab> selTabs = <Tab>[
    Tab(text: S.current.operation_strategy),
    Tab(text: S.current.history),
  ];
  TabController? selController;

  @override
  void initState() {
    super.initState();
    selController = TabController(
      length: selTabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          S.current.strategy_management,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: const [],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Material(
            color: Colors.white,
            child: Theme(
              data: ThemeData(
                  splashColor: Colors.transparent,
                  // 点击时的水波纹颜色设置为透明
                  highlightColor: Colors.transparent,
                  // 点击时的背景高亮颜色设置为透明
                  tabBarTheme:
                      const TabBarThemeData(dividerColor: Colors.transparent)),
              child: TabBar(
                tabs: selTabs,
                unselectedLabelColor: const Color.fromRGBO(104, 104, 104, 1),
                labelColor: const Color.fromRGBO(36, 193, 143, 1),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: const Color.fromRGBO(36, 193, 143, 1),
                labelStyle: const TextStyle(fontSize: 17),
                controller: selController,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: selController,
              children: const [
                StrategicrunningPage(),
                StrategichistoryPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
