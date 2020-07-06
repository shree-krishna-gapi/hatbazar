import 'dart:async';
import 'package:hatbazar/api/common/ps_resource.dart';
import 'package:hatbazar/api/common/ps_status.dart';
import 'package:hatbazar/db/favourite_product_dao.dart';
import 'package:hatbazar/db/history_dao.dart';
import 'package:hatbazar/db/user_login_dao.dart';
import 'package:hatbazar/repository/Common/ps_repository.dart';

import 'package:hatbazar/viewobject/user_login.dart';

class DeleteTaskRepository extends PsRepository {
  Future<dynamic> deleteTask(
      StreamController<PsResource<List<UserLogin>>> allListStream) async {
    final FavouriteProductDao _favProductDao = FavouriteProductDao.instance;
    final UserLoginDao _userLoginDao = UserLoginDao.instance;
    final HistoryDao _historyDao = HistoryDao.instance;
    await _favProductDao.deleteAll();
    await _userLoginDao.deleteAll();
    await _historyDao.deleteAll();

    allListStream.sink
        .add(await _userLoginDao.getAll(status: PsStatus.SUCCESS));
  }
}
