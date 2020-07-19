import 'package:hatbazar/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';
//import 'default_icon.dart';
import 'video/default_photo.dart';
class Video extends PsObject<Video> {
  Video({
    this.id,
    this.title,
    this.videoUrl,
    this.description,
    this.date,
    this.time,
    this.defaultPhoto,
  });
  String id;
  String title;
  String videoUrl;
  String description;
  String date;
  String time;
  DefaultPhoto defaultPhoto;
  @override
  bool operator ==(dynamic other) => other is Video && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  Video fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Video(
        id: dynamicData['id'],
        title: dynamicData['title'],
        videoUrl: dynamicData['vid_url'],
        description: dynamicData['description'],
        date: dynamicData['added_date'],
        time: dynamicData['added_date_str'],
        defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Video object) {

    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['title'] = object.title;
      data['vid_url'] = object.videoUrl;
      data['description'] = object.description;
      data['added_date'] = object.date;
      data['added_date_str'] = object.time;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
//      print(data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Video> fromMapList(List<dynamic> dynamicDataList) {
    final List<Video> videoList = <Video>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          videoList.add(fromMap(dynamicData));
        }
      }
    }
    return videoList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Video> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Video data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
