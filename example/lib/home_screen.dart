import 'package:easy_localization/easy_localization.dart';
import 'package:example/menu_page.dart';
import 'package:example/page_structure.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static List<MenuItem> mainMenu = [
    MenuItem(tr("payment"), Icons.payment, 0),
    MenuItem(tr("promos"), Icons.card_giftcard, 1),
    MenuItem(tr("notifications"), Icons.notifications, 2),
    MenuItem(tr("help"), Icons.help, 3),
    MenuItem(tr("about_us"), Icons.info_outline, 4),
  ];

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _drawerController = AwesomeDrawerBarController();

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return AwesomeDrawerBar(
      isRTL: true,
      controller: _drawerController,
      type: StyleState.scaleRight, // default,style1,style2,style3,style4,style5
      menuScreen: MenuScreen(
        HomeScreen.mainMenu,
        callback: _updatePage,
        current: _currentPage,
      ),
      mainScreen: MainScreen(),
      borderRadius: 24.0,
      showShadow: true, //default,style1,style3
      angle: 0.0, //default
      slideWidth: MediaQuery.of(context).size.width * (false ? .45 : 0.65), // default
      // slideHeight: MediaQuery.of(context).size.height * (AwesomeDrawerBar.isRTL() ? .45 : -0.17), //default
      // openCurve: Curves.fastOutSlowIn,
      // closeCurve: Curves.bounceIn,
    );
  }

  void _updatePage(index) {
    Provider.of<MenuProvider>(context, listen: false).updateCurrentPage(index);
    _drawerController.toggle();
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final rtl = false;
    return ValueListenableBuilder<DrawerState>(
      valueListenable: AwesomeDrawerBar.of(context).stateNotifier,
      builder: (context, state, child) {
        return AbsorbPointer(
          absorbing: state != DrawerState.closed,
          child: child,
        );
      },
      child: GestureDetector(
        child: PageStructure(),
        onPanUpdate: (details) {
          if (details.delta.dx < 6 && !rtl || details.delta.dx < -6 && rtl) {
            AwesomeDrawerBar.of(context).toggle();
          }
        },
      ),
    );
  }
}

class MenuProvider extends ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void updateCurrentPage(int index) {
    if (index != currentPage) {
      _currentPage = index;
      notifyListeners();
    }
  }
}
