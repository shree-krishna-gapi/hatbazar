import 'package:flutterbuyandsell/api/common/ps_status.dart';

class PsResource<T> {
  PsResource(this.status, this.message, this.data);
  PsStatus status;

  String message;

  T data;

  // @override
  // bool operator ==(dynamic other) {
  //   print('other : ${other.data.hashCode}');
  //   print('me : ${data.hashCode}');
  //   return other.data == data;
  // }

  // @override
  // int get hashCode {
  //   if (data is List) {
  //     final List d = data as List;
  //     int i = d.length;
  //   }
  //   return hash2(data.hashCode, data.hashCode);
  // }

  // get length => null;
}
