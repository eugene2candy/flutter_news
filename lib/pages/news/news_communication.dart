import 'package:FlutterNews/repository/notice_repository/model/notice.dart';
import 'package:bsev/bsev.dart';

class NewsCommunication extends Communication {
  BehaviorSubjectCreate<bool> errorConection = BehaviorSubjectCreate();
  BehaviorSubjectCreate<bool> progress = BehaviorSubjectCreate();
  BehaviorSubjectCreate<List<Notice>> noticies = BehaviorSubjectCreate();
  BehaviorSubjectCreate<List<String>> categoriesName = BehaviorSubjectCreate();

  @override
  void dispose() {
    progress.close();
    errorConection.close();
    noticies.close();
    categoriesName.close();
    super.dispose();
  }
}
