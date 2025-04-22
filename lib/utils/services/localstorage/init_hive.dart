import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'keys.dart';

Future initHive() async {
  if (kIsWeb) {
    await Hive.initFlutter();
  } else {
    await Hive.initFlutter();
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }
  await Hive.openBox(Keys.hiveinit);
}
