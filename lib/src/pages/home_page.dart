import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/pages/tabsInfo/info_page.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/negocios_tab.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> pageList = [];

  @override
  void initState() {
    pageList.add(NegociosTab());
    pageList.add(UserPage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomBloc = ProviderBloc.bottom(context);
    bottomBloc.changePage(0);

    final responsive = Responsive.of(context);
    //bottomBloc.changePageTorneo(0);

    return Scaffold(
      body: StreamBuilder(
        stream: bottomBloc.selectPageStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: responsive.hp(3)),
                child: IndexedStack(
                  index: bottomBloc.page,
                  children: pageList,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(20),
                      topEnd: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    selectedItemColor: Colors.green[400],
                    unselectedItemColor: Colors.red,
                    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                        label: 'Negocios',
                        icon: Icon(FontAwesomeIcons.building),
                      ),
                      BottomNavigationBarItem(
                        label: 'Info',
                        icon: Icon(
                          FontAwesomeIcons.userTie,
                        ),
                      ),
                    ],
                    currentIndex: bottomBloc.page,
                    onTap: (index) => {
                      bottomBloc.changePage(index),
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
