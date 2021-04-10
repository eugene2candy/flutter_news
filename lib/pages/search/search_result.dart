import 'package:FlutterNews/injection/injector.dart';
import 'package:FlutterNews/pages/search/search_events.dart';
import 'package:FlutterNews/pages/search/search_result_bloc.dart';
import 'package:FlutterNews/repository/notice_repository/model/notice.dart';
import 'package:FlutterNews/util/bloc_provider.dart';
import 'package:FlutterNews/widgets/erro_conection.dart';
import 'package:flutter/material.dart';

class SearchResultPage extends StatefulWidget {
  final String query;

  SearchResultPage(this.query);

  static Widget create(String query) {
    return BlocProvider<SearchResultBloc>(
      bloc: SearchResultBloc(Injector().repository.getNoticeRepository()),
      child: SearchResultPage(query),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return new _SearchResultState();
  }
}

class _SearchResultState extends State<SearchResultPage>
    with TickerProviderStateMixin
    implements BlocView<SearchEvents> {

  SearchResultBloc bloc;
  AnimationController animationController;

  @override
  void initState() {
    animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 350));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (bloc == null) {
      bloc = BlocProvider.of<SearchResultBloc>(context);
      bloc.registerView(this);
      bloc.dispatch(LoadSearch()..data = widget.query);
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.query),
      ),
      body: Stack(
        children: <Widget>[
          _getListViewWidget(),
          _getProgress(),
          _getEmpty(),
          _buildConnectionError()
        ],
      ),
    );
  }

  Widget _getListViewWidget() {
    return FadeTransition(
      opacity: animationController,
      child: StreamBuilder(
          initialData: List<Notice>(),
          stream: bloc.streams.noticies,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var news = snapshot.data;

            return new ListView.builder(
                itemCount: news.length,
                padding: new EdgeInsets.only(top: 5.0),
                itemBuilder: (context, index) {
                  return news[index];
                });
          }),
    );
  }

  Widget _getProgress() {
    return StreamBuilder(
        stream: bloc.streams.progress,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data) {
            return new Container(
              child: new Center(
                child: new CircularProgressIndicator(),
              ),
            );
          } else {
            return new Container();
          }
        });
  }

  Widget _getEmpty() {
    return StreamBuilder(
        stream: bloc.streams.empty,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data) {
            return Container(
              child: new Center(
                child: new Text(bloc.getString("erro_busca")),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Widget _buildConnectionError() {
    return StreamBuilder(
        stream: bloc.streams.error,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data) {
            return ErroConection(tryAgain: () {
              bloc.dispatch(LoadSearch()..data = widget.query);
            });
          } else {
            return Container();
          }
        });
  }

  @override
  void eventViewReceiver(SearchEvents event) {
    if (event is InitAnimation) {
      animationController.forward(from: 0.0);
    }
  }
}
