import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/view/tutor/chat/chat_view.dart';
import 'package:tutor/view/tutor/home/home_view.dart';
import 'package:tutor/view/student/notification/notification_page.dart';
import 'package:tutor/view/tutor/profile/profile_view.dart';
import 'package:tutor/view/tutor/schedule/schedule_view.dart';

class MainTutor extends StatefulWidget {
  MainTutor({Key? key}) : super(key: key);

  @override
  _MainTutorState createState() => _MainTutorState();
}

class _MainTutorState extends State<MainTutor> {
  late int _selectedIndex;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _selectedIndex = 0;
    _screens = [
      HomeView(),
      ChatView(),
      ScheduleView(),
      ProfileView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left: 8.0),
          padding: EdgeInsets.all(4),
          alignment: Alignment.centerLeft,
          child: Image.asset("images/logo_small.png"),
        ),
        leadingWidth: 80,
        actions: [
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NotificationPage(),
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(right: 8.0),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.asset("images/ring_circle.png"),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("TutorIDs")
                        .doc(Globals.currentUser!.uid)
                        .collection("GeneralNotifications")
                        .where("is_readed", isEqualTo: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          return CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 7,
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: PersistentTabView(
        context,
        screens: _screens,
        items: [
          _getBottomMenuItem("หน้าหลัก", Icons.format_list_bulleted_outlined),
          _getBottomMenuItem("ค้นหา", Icons.chat_outlined),
          _getBottomMenuItem("ตารางสอน", Icons.today_outlined),
          _getBottomMenuItem("โปรไฟล์", Icons.person_outline),
        ],
        confineInSafeArea: true,
        backgroundColor: COLOR.LIGHT_GREY,
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style6,
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: COLOR.LIGHT_GREY,
      //   items: [
      //     _getBottomMenuItem("หน้าหลัก", "images/tab/list.png"),
      //     _getBottomMenuItem("ค้นหา", "images/tab/chat.png"),
      //     _getBottomMenuItem("ตารางสอน", "images/tab/calendar.png"),
      //     _getBottomMenuItem("โปรไฟล์", "images/tab/user.png"),
      //   ],
      //   selectedLabelStyle: GoogleFonts.prompt(
      //     color: COLOR.BLUE,
      //     fontSize: 9,
      //   ),
      //   unselectedLabelStyle: GoogleFonts.prompt(
      //     color: COLOR.DARK,
      //     fontSize: 8,
      //   ),
      //   // selectedItemColor: COLOR.YELLOW,
      //   // unselectedItemColor: COLOR.DARK,
      //   type: BottomNavigationBarType.fixed,
      //   onTap: (i) {
      //     setState(() {
      //       _selectedIndex = i;
      //     });
      //   },
      //   currentIndex: _selectedIndex,
      // ),
    );
  }

  PersistentBottomNavBarItem _getBottomMenuItem(String title, IconData icon) {
    return PersistentBottomNavBarItem(
      icon: Icon(icon),
      title: title,
      activeColorPrimary: COLOR.YELLOW,
      inactiveColorPrimary: COLOR.DARK,
      textStyle: GoogleFonts.prompt(
        color: COLOR.BLUE,
        fontSize: 9,
      ),
    );
  }
}
