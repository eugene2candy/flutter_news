import 'package:FlutterNews/pages/search/search_cube.dart';
import 'package:FlutterNews/repository/notice_repository/model/notice.dart';
import 'package:FlutterNews/widgets/AnimatedContent.dart';
import 'package:FlutterNews/widgets/erro_conection.dart';
import 'package:cubes/cubes.dart';
import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  final String query;

  SearchView(this.query);

  @override
  Widget build(BuildContext context) {
    return CubeBuilder<SearchCube>(
      initData: query,
      builder: (context, cube) {
        return Scaffold(
          appBar: AppBar(
            title: Text(query),
          ),
          body: Stack(
            children: <Widget>[
              _getListViewWidget(cube),
              _getProgress(cube),
              _getEmpty(cube),
              _buildConnectionError(cube)
            ],
          ),
        );
      },
    );
  }

  Widget _getListViewWidget(SearchCube cube) {
    return cube.noticeList.build<List<Notice>>((value) {
      return AnimatedContent(
        show: value.length > 0,
        child: ListView.builder(
          itemCount: value.length,
          padding: const EdgeInsets.only(top: 5.0),
          itemBuilder: (context, index) {
            return value[index];
          },
        ),
      );
    });
  }

  Widget _getProgress(SearchCube cube) {
    return cube.progress.build<bool>(
      (value) {
        return value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox.shrink();
      },
      animate: true,
    );
  }

  Widget _getEmpty(SearchCube cube) {
    return cube.empty.build<bool>((value) {
      return value
          ? Center(
              child: Text(getString("erro_busca")),
            )
          : SizedBox.shrink();
    });
  }

  Widget _buildConnectionError(SearchCube cube) {
    return cube.error.build((value) {
      return value
          ? ErroConection(tryAgain: () {
              cube.search(query);
            })
          : SizedBox.shrink();
    });
  }
}
