import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences sharedPref;

  static Future cacheInitialization() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  static Future<bool> insertString({required String key,required String value}) async
  {
    return await sharedPref.setString(key, value);
  }

  static Future<bool> insertBool({required String key,required bool value}) async
  {
    return await sharedPref.setBool(key, value);
  }

  static bool? getBool({required String key}) {
    return sharedPref.getBool(key);
  }

  static String? getString({required String key}) {
    return sharedPref.getString(key);
  }

  static Future<bool> removeItem({required String key}) async {
    await sharedPref.remove(key).then((value){
      if( value )
      {
        return true;
      }
      else
      {
        return false;
      }
    });
    return false;
  }

  static Future<bool> clearCache() async {
    await sharedPref.clear().then((value){
      if( value )
      {
        return true;
      }
      else
      {
        return false;
      }
    });
    return false;
  }
}