import 'package:flutter/material.dart';
import 'package:suncloudm/routes/Routes.dart';

class OplMessagePage extends StatefulWidget {
  const OplMessagePage({super.key});

  @override
  State<OplMessagePage> createState() => _OplMessagePageState();
}

class _OplMessagePageState extends State<OplMessagePage> {
  int _tabIndex = 0;
  int _messageSubTabIndex = 0;
  int _todoSubTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/gradientbg.png'), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: const Text(
            '消息',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // 实现一键已读逻辑
              },
              child: const Text('一键已读', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _tabIndex = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _tabIndex == 0
                          ? const Color(0xFF24C18F)
                          : Colors.white,
                      foregroundColor:
                          _tabIndex == 0 ? Colors.white : Colors.grey,
                    ),
                    child: const Text('消息提醒'),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _tabIndex = 1;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _tabIndex == 1
                          ? const Color(0xFF24C18F)
                          : Colors.white,
                      foregroundColor:
                          _tabIndex == 1 ? Colors.white : Colors.grey,
                    ),
                    child: const Text('待办事项'),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            Expanded(
              child: _tabIndex == 0 ? _buildMessagePage() : _buildTodoPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagePage() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _messageSubTabIndex = 0;
                  });
                },
                child: Text(
                  '全部',
                  style: TextStyle(
                    fontWeight: _messageSubTabIndex == 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: _messageSubTabIndex == 0
                        ? Colors.black
                        : Color(0xFF8693AB),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _messageSubTabIndex = 1;
                  });
                },
                child: Text(
                  '未读',
                  style: TextStyle(
                    fontWeight: _messageSubTabIndex == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: _messageSubTabIndex == 1
                        ? Colors.black
                        : Color(0xFF8693AB),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _messageSubTabIndex = 2;
                  });
                },
                child: Text(
                  '已读',
                  style: TextStyle(
                    fontWeight: _messageSubTabIndex == 2
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: _messageSubTabIndex == 2
                        ? Colors.black
                        : Color(0xFF8693AB),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(children: [
            InkWell(
              onTap: () {
                // 处理点击事件
                Routes.instance!.navigateTo(context, Routes.alarmMessagePage);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10), // 设置圆角半径为10
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/workmessageIcon.png'),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('告警消息'),
                      const Text('12:00',
                          style: TextStyle(color: Color(0xFF8692A3))),
                    ],
                  ),
                  subtitle: const Text(
                    '告警内容',
                    style: TextStyle(color: Color(0xFF8692A3)),
                  ),
                  // trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // 处理点击事件
                Routes.instance!
                    .navigateTo(context, Routes.workNotificationPage);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10), // 设置圆角半径为10
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/workmessageIcon.png'),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('工单消息'),
                      const Text('12:00',
                          style: TextStyle(color: Color(0xFF8692A3))),
                    ],
                  ),
                  subtitle: const Text(
                    '消息内容',
                    style: TextStyle(color: Color(0xFF8692A3)),
                  ),
                  // trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10), // 设置圆角半径为10
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/osmessageIcon.png'),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('巡检消息'),
                    const Text('12:00',
                        style: TextStyle(color: Color(0xFF8692A3))),
                  ],
                ),
                subtitle: const Text(
                  '消息内容',
                  style: TextStyle(color: Color(0xFF8692A3)),
                ),
                // trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10), // 设置圆角半径为10
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/schedulingIcon.png'),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('排班消息'),
                    const Text('12:00',
                        style: TextStyle(color: Color(0xFF8692A3))),
                  ],
                ),
                subtitle: const Text(
                  '消息内容',
                  style: TextStyle(color: Color(0xFF8692A3)),
                ),
                // trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _buildTodoPage() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _todoSubTabIndex = 0;
                  });
                },
                child: Text(
                  '待我处理',
                  style: TextStyle(
                    fontWeight: _todoSubTabIndex == 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: _todoSubTabIndex == 0
                        ? Colors.black
                        : Color(0xFF8693AB),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _todoSubTabIndex = 1;
                  });
                },
                child: Text(
                  '我已处理',
                  style: TextStyle(
                    fontWeight: _todoSubTabIndex == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: _todoSubTabIndex == 1
                        ? Colors.black
                        : Color(0xFF8693AB),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 20, // 示例数据数量
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('待办事项 $index'),
              );
            },
          ),
        ),
      ],
    );
  }
}
