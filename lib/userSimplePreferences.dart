import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences{
  static late SharedPreferences _preferences;
  //final Future<SharedPreferences> _preferences = SharedPreferences.getInstance();

  static const _keyId = 'id';
  static const _keyUsername = 'username';
  static const _keyFirstName = 'firstName';
  static const _keyLastName = 'lastName';
  static const _keyEmail = 'email';
  static const _keyRole = 'role';
  static const _keyToken = 'token';

  static Future init() async{
    _preferences = await SharedPreferences.getInstance();
  }

  ///Set data
  static Future setId(String id) async{
    await _preferences.setString(_keyId, id);
  }

  static Future setUserName(String username) async{
    await _preferences.setString(_keyUsername, username);
  }

  static Future setFirstName(String firstName) async{
    await _preferences.setString(_keyFirstName, firstName);
  }

  static Future setLastName(String lastName) async{
    await _preferences.setString(_keyLastName, lastName);
  }

  static Future setEmail(String email) async{
    await _preferences.setString(_keyEmail, email);
  }

  static Future setRole(String role) async{
    await _preferences.setString(_keyRole, role);
  }

  static Future setToken(String token) async{
    await _preferences.setString(_keyToken, token);
  }

  ///Get data
  static String? getId() => _preferences.getString(_keyId);

  static String? getUserName() => _preferences.getString(_keyUsername);

  static String? getFirstName() => _preferences.getString(_keyFirstName);

  static String? getLastName() => _preferences.getString(_keyLastName);

  static String? getEmail() => _preferences.getString(_keyEmail);

  static String? getRole() => _preferences.getString(_keyRole);

  static String? getToken() => _preferences.getString(_keyToken);



  ///Remove data
  static removeId() => _preferences.remove(_keyId);

  static removeUserName() => _preferences.remove(_keyUsername);

  static removeFirstName() => _preferences.remove(_keyFirstName);

  static removeLastName() => _preferences.remove(_keyLastName);

  static removeEmail() => _preferences.remove(_keyEmail);

  static removeRole() => _preferences.remove(_keyRole);

  static removeToken() => _preferences.remove(_keyToken);


}