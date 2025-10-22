import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:suncloudm/View/HomeView/boss_home_page.dart';
import 'package:suncloudm/View/HomeView/cn_home_page.dart';
import 'package:suncloudm/View/HomeView/cnsingle_home_page.dart';
import 'package:suncloudm/View/HomeView/gg_home_page.dart';
import 'package:suncloudm/View/HomeView/jc_home_page.dart';
import 'package:suncloudm/View/HomeView/pv_home_page.dart';
import 'package:suncloudm/View/HomeView/pvsingle_home_page.dart';
import 'package:suncloudm/View/HomeView/wwsingle_home_page.dart';
import 'package:suncloudm/View/HomeView/yys_home_page.dart';
import 'package:suncloudm/dao/daoX.dart';
import '../dao/storage.dart';
import 'HomeView/OldHomeView/home_page.dart';
import 'LogView/personal_page.dart';
import 'ProjectView/projectlist_page.dart';
import 'WorkspaceView/workspacehome_page.dart';
import 'package:suncloudm/generated/l10n.dart';

class IndexPage extends StatefulWidget {
  final String? path;

  final int showIndex;

  const IndexPage({super.key, this.path, this.showIndex = 0});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int? unreadnum;

  Map userInfo = jsonDecode(
      GlobalStorage.getLoginInfo()!); //"项目类型 1：微网项目 2：储能项目 3：光伏项目 4: 充电桩项目")

  final PageController _pageController = PageController();

  int _currentIndex = 0;

  List<Widget> pages = [];

  Future<String> getAppMenuTree() async {
    Map<String, dynamic> params = {};
    var data = await LoginDao.getAppMenuTree(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      Map datakk = data['data'];
      List menuList = datakk['menuList'];
      return menuList[0]['path'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  getHomePage() {
    if (widget.path == '/home') {
      return const BossHomePage();
    } else if (widget.path == '/home/integrator') {
      return const JcHomePage();
    } else if (widget.path == '/micro/home') {
      return const WwsingleHomePage();
    } else if (widget.path == '/es/home') {
      return const CnsingleHomePage();
    } else if (widget.path == '/es/dashboard') {
      return const CnHomePage();
    } else if (widget.path == '/station/guangai') {
      return const GgHomePage();
    } else if (widget.path == '/pv/dashboard') {
      return const PvHomePage();
    } else if (widget.path == '/monitor/inverter') {
      return const PvsingleHomePage();
    } else if (widget.path == '/micro/cockpit') {
      return const YysHomePage();
    } else {
      return const HomePage();
    }
  }

  @override
  void initState() {
    super.initState();
    getunreadCount();
    pages = [];
    pages = [
      getHomePage(),
      const WorkSpaceHomePage(),
      ProjectListPage(onGoBackToFirst: _goBackToFirst),
      AdminPersionPage()
    ];

    if (widget.showIndex != 0) {
      setState(() {
        _currentIndex = widget.showIndex;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(widget.showIndex);
        }
      });
    }
    // if (widget.itemType == 7) {
    //   pages = [
    //     const GgHomePage(),
    //     // WhitePage(),
    //     const WorkSpaceHomePage(),
    //     ProjectListPage(onGoBackToFirst: _goBackToFirst),
    //     AdminPersionPage()
    //   ];
    // } else {
    //   pages = [
    //     const JcHomePage(),
    //     // WhitePage(),
    //     const WorkSpaceHomePage(),
    //     ProjectListPage(onGoBackToFirst: _goBackToFirst),
    //     AdminPersionPage()
    //   ];
    // }
    // pages = [
    //   const WwsingleHomePage(),
    //   const CnsingleHomePage(),
    //   const BossHomePage(),
    //   const JcHomePage(),
    // ];
  }

  getunreadCount() async {
    // var data = await AdDao.unreadCount();
    // if (data["code"] == 200) {
    //   if (data['data'] != null) {
    //     setState(() {
    //       unreadnum = data['data'];
    //     });
    //   } else {}
    // } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          getunreadCount();
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(_currentIndex);
          });
        },
        selectedItemColor: const Color(0xFF3BBAAF),
        unselectedItemColor: const Color(0xFF7B7D8A),
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            label: S.current.home,
            icon: Icon(Icons.home),
          ),
          // BottomNavigationBarItem(label: "消息", icon: Icon(Icons.message)
          //     // icon: badges.Badge(
          //     //   position: badges.BadgePosition.topEnd(top: -10, end: -15),
          //     //   showBadge: (unreadnum == null ||unreadnum==0)? false : true,
          //     //   badgeContent: Text(
          //     //     unreadnum.toString(),
          //     //     // '10',
          //     //     style: const TextStyle(color: Colors.white,fontSize: 10),
          //     //   ),
          //     //   child: const Icon(Icons.message),
          //     //   badgeStyle: badges.BadgeStyle(
          //     //     padding: EdgeInsets.all(5),
          //     //   ),
          //     // )
          //     ),
          BottomNavigationBarItem(
              label: S.current.dashboard, icon: Icon(Icons.workspaces)),
          BottomNavigationBarItem(
              label: S.current.project, icon: Icon(Icons.work)),
          BottomNavigationBarItem(
              label: S.current.mine, icon: Icon(Icons.person))
        ],
      ),
    );
  }

  Widget _buildBody() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      controller: _pageController,
      children: pages,
    );
  }

  // 定义回到第一页的方法，更新当前索引为0
  void _goBackToFirst(bool guanga) {
    setState(() {
      pages[0] = getHomePage();
      _currentIndex = 0;
      _pageController.jumpToPage(_currentIndex);
    });
  }

  void _replacePage(int index, Widget newPage) {
    setState(() {
      pages[index] = newPage;
    });
  }
}
