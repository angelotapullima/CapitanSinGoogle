import 'package:cached_network_image/cached_network_image.dart';
import 'package:capitan_sin_google/src/bloc/negocios_bloc.dart';
import 'package:capitan_sin_google/src/bloc/provider_bloc.dart';
import 'package:capitan_sin_google/src/models/negocios_model.dart';
import 'package:capitan_sin_google/src/pages/tabsNegocio/detalle_negocio_page.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MisNegociosPage extends StatelessWidget {
  final _refreshController = RefreshController(initialRefresh: false);

  Future<bool> _refresher(NegociosBloc blocNegocios) {
    print('pedimos letra');
    blocNegocios.obtenerMisNegocios();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final blocNegocios = ProviderBloc.negocitos(context);
    blocNegocios.cargandoFalse();
    blocNegocios.obtenerMisNegocios();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Negocios'),
      ),
      body: SmartRefresher(
          controller: _refreshController,
          onRefresh: () {
            _refresher(blocNegocios);
          },
          child: _listaNegocios(blocNegocios)),
    );
  }

  Widget _listaNegocios(NegociosBloc blocNegocios) {
    return StreamBuilder(
        stream: blocNegocios.misNegociosStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final negocios = snapshot.data;

            return ListView.builder(itemCount: negocios.length, itemBuilder: (context, i) => _crearItem(context, blocNegocios, negocios[i]));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _crearItem(BuildContext context, NegociosBloc blocNegocios, NegociosModelResult negocios) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
          height: 250.0,
          child: Stack(
            children: <Widget>[
              (negocios.foto == null)
                  ? Image(image: AssetImage('assets/img/no-image.png'))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image(image: AssetImage('assets/img/loading.gif'), fit: BoxFit.cover),
                        ),
                        errorWidget: (context, url, error) =>
                            Container(width: double.infinity, height: double.infinity, child: Center(child: Icon(Icons.error))),
                        imageUrl: negocios.getFoto(),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          )),
                        ),
                      ),
                    ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                    child: ListTile(
                        title: Text(
                          '${negocios.nombre} - ${negocios.idEmpresa}',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        subtitle: Text('${negocios.direccion}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0)),
                        onTap: () {} //=> Navigator.pushNamed(context, 'producto', arguments: producto),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 700),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return DetalleNegocio(
                    idEmpresa: negocios.idEmpresa,
                  );
                },
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            )
        //Navigator.pushNamed(context, 'detalleNegocio', arguments: negocios),
        );
  }
}
