import 'package:hatbazar/viewobject/video.dart';
import 'package:sembast/sembast.dart';
import 'package:hatbazar/db/common/ps_dao.dart' show PsDao;

class VideoDao extends PsDao<Video> {
  VideoDao._() {
    init(Video());
  }
  static const String STORE_NAME = 'Video';
  final String _primaryKey = 'id';

  // Singleton instance
  static final VideoDao _singleton = VideoDao._();

  // Singleton accessor
  static VideoDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(Video object) {
    return object.id;
  }

  @override
  Filter getFilter(Video object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
