import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_v1/consts/consts.dart';
import 'package:to_do_list_v1/models/taks.dart';

class TaksRepository {
  late SharedPreferences sharedPreferences;
  final Consts consts = Consts();

  Future<List<Taks>> getTaksList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString =
        sharedPreferences.getString(consts.taksListKey) ?? '[]';
    List jsonDecoded = jsonDecode(jsonString) as List;
    return jsonDecoded.map((e) => Taks.fromJson(e)).toList();
  }

  void saveTaksList(List<Taks> taks) {
    final String jsonString = json.encode(taks);
    sharedPreferences.setString('taks_list', jsonString);
  }
}
