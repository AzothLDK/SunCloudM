import 'package:flutter/material.dart';
import 'package:suncloudm/View/HomeView/home_page.dart';
import 'package:suncloudm/View/HomeView/white_page.dart';
import 'package:suncloudm/View/OAM/opl_home_page.dart';
import 'package:suncloudm/View/OAM/opl_message_page.dart';
import 'package:suncloudm/View/OAM/opl_mine_page.dart';
import 'package:suncloudm/View/OAM/opl_station_page.dart';
import 'package:suncloudm/View/OAM/opl_workspace_page.dart';
import 'package:suncloudm/View/OAM/withe_page.dart';
import 'package:suncloudm/gen_a/A.dart';
import 'package:suncloudm/generated/l10n.dart';

class OplIndexPage extends StatefulWidget {
  const OplIndexPage({super.key});

  @override
  State<OplIndexPage> createState() => _OplIndexPageState();
}

class _OplIndexPageState extends State<OplIndexPage> {
  late List<Widget> _pages = [];
  final PageController _pageController = PageController();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      const OplHomePage(),
      // const WithePage(),
      // const OplMessagePage(),
      const OplWorkspacePage(),
      const OplStationPage(),
      const OplMinePage(),
    ];
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
      children: _pages,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(_currentIndex);
          });
        },
        // selectedLabelStyle: TextStyle(color: Color(0xFF3BBAAF)),
        // unselectedLabelStyle: TextStyle(color: Color(0xFF7B7D8A)),
        selectedItemColor: const Color(0xFF3BBAAF),
        // 选中图标的颜色
        unselectedItemColor: const Color(0xFF7B7D8A),
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            label: S.current.home,
            // 未选中状态的图片
            icon:
                Image.asset(A.assets_op_home_unseleted, width: 24, height: 24),
            // 选中状态的图片
            activeIcon:
                Image.asset(A.assets_op_home_seleted, width: 24, height: 24),
          ),
          // BottomNavigationBarItem(
          //   label: S.current.message,
          //   icon: Image.asset(A.assets_op_message_unseleted,
          //       width: 24, height: 24),
          //   activeIcon:
          //       Image.asset(A.assets_op_message_seleted, width: 24, height: 24),
          // ),
          BottomNavigationBarItem(
            label: S.current.dashboard,
            icon: Image.asset(A.assets_op_workspace_unseleted,
                width: 24, height: 24),
            activeIcon: Image.asset(A.assets_op_workspace_seleted,
                width: 24, height: 24),
          ),
          BottomNavigationBarItem(
            label: S.current.project,
            icon: Image.asset(A.assets_op_eleStation_unseleted,
                width: 24, height: 24),
            activeIcon: Image.asset(A.assets_op_eleStation_seleted,
                width: 24, height: 24),
          ),
          BottomNavigationBarItem(
            label: S.current.mine,
            icon:
                Image.asset(A.assets_op_mine_unseleted, width: 24, height: 24),
            activeIcon:
                Image.asset(A.assets_op_mine_seleted, width: 24, height: 24),
          )
        ],
      ),
    );
  }
}
