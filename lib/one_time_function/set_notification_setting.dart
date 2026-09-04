import 'package:shared_preferences/shared_preferences.dart';
import 'package:lekra/services/constants.dart';

class NotificationSettingsService {
  static Future<void> setNotificationSettings({
    bool isSoundOn = true,
    String language = "Hindi",
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(AppConstants.soundNotificationIsOn, isSoundOn);
    await prefs.setString(AppConstants.soundNotificationLanguage, language);
  }

  static Future<bool> getSoundStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.soundNotificationIsOn) ?? true;
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.soundNotificationLanguage) ?? "Hindi";
  }
}
