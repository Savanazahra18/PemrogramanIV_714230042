import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {

  static const String loginStatusKey = 'loginStatusKey';
  static const String loginTimeKey = 'loginTimeKey';
  static const String usernameKey = 'username';
  static const String tokenKey = 'token'; 


  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(loginStatusKey) ?? false;
    String? loginTimeString = prefs.getString(loginTimeKey);

    if (isLoggedIn && loginTimeString != null) {
      try {
        DateTime loginTime = DateTime.parse(loginTimeString);
        final Duration timeDifference = DateTime.now().difference(loginTime);

      
        const Duration maxDuration = Duration(hours: 4);

        if (timeDifference > maxDuration) {
          await logout(); 
          return false;
        }
        return true;
      } catch (e) {
        debugPrint('Error parsing DateTime: $e');
        await logout();
        return false;
      }
    }
    return false;
  }

 
  static Future<void> login(String username, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginStatusKey, true);
    await prefs.setString(loginTimeKey, DateTime.now().toString());
    await prefs.setString(usernameKey, username);
    await prefs.setString(tokenKey, token); 
  }

 
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(loginStatusKey);
    await prefs.remove(loginTimeKey);
    await prefs.remove(usernameKey);
    await prefs.remove(tokenKey); 
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }
}