import 'package:cached_network_image/cached_network_image.dart';
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/utils/WidgetCargandp.dart';
import 'package:capitan_sin_google/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FotosNegocio extends StatefulWidget {
  const FotosNegocio({Key key, @required this.idEmpresa, @required this.index}) : super(key: key);

  final String idEmpresa;
  final String index;

  @override
  _FotosNegocioState createState() => _FotosNegocioState();
}

class _FotosNegocioState extends State<FotosNegocio> {
  @override
  Widget build(BuildContext context) {
    final galeriaBloc = ProviderBloc.galeria(context);
    galeriaBloc.obtenerGalerias(widget.idEmpresa);
    galeriaBloc.changePage(int.parse(widget.index));

    final responsive = Responsive.of(context);
    final _pageController = PageController(viewportFraction: 1, initialPage: int.parse(widget.index));

    return StreamBuilder(
        stream: galeriaBloc.selectPageStream,
        builder: (BuildContext context, AsyncSnapshot snapshotConteo) {
          return StreamBuilder(
              stream: galeriaBloc.galeriaStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    return Scaffold(
                      backgroundColor: Colors.black,
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        actions: [
                          Container(
                            height: responsive.ip(1),
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(2),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey[300],
                              border: Border.all(color: Colors.grey[300]),
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: responsive.wp(5),
                              vertical: responsive.hp(1.3),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  (galeriaBloc.page + 1).toString(),
                                  style: TextStyle(fontSize: responsive.ip(1.5), color: Colors.black),
                                ),
                                Text(
                                  ' / ',
                                  style: TextStyle(fontSize: responsive.ip(1.5), color: Colors.black),
                                ),
                                Text(
                                  '${snapshot.data.length}',
                                  style: TextStyle(fontSize: responsive.ip(1.5), color: Colors.black),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      body: PageView.builder(
                          itemCount: snapshot.data.length,
                          controller: _pageController,
                          onPageChanged: (index) {
                            print(index);
                            galeriaBloc.changePage(index);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onVerticalDragUpdate: (algo) {
                                if (algo.primaryDelta > 7) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: Container(
                                      width: double.infinity,
                                      child: PhotoView(
                                        imageProvider: CachedNetworkImageProvider(
                                          '${snapshot.data[index].getGaleria()}',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  } else {
                    return Center(
                      child: CargandoWidget(),
                    );
                  }
                } else {
                  return Center(
                    child: CargandoWidget(),
                  );
                }
              });
        });
  }
}
