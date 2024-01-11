import 'dart:convert';
import 'package:http/http.dart' as http;

class OneSignalController {
  static final String _appId = '4844d54d-7798-4bff-bebc-47d4c90ff148';
  static final String _apiKey = 'OGVhZGZlOTMtMzNjMy00ODc0LTg2ZTctYTE2YjE2MDI2OTZk';

  Future<void> sendNotification(String title, String message, List<String> playerIds) async {
    //final apiUrl = 'https://onesignal.com/api/v1/notifications';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $_apiKey',
    };

    final request = {
      'app_id': _appId,
      'headings': {'en': title},
      'contents': {'en': message},
     // 'include_player_ids': playerIds,
      'include_external_user_ids': playerIds,
    };

    var response = await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: headers,
      body: json.encode(request),
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully.");
    } else {
      print("Failed to send notification. Status code: ${response.statusCode}");
    }
  }
}
