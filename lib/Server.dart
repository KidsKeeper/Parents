import 'package:http/http.dart' as http;

import 'dart:convert';

Map <String, String> headers = {
  'Content-type': 'application/json',
  'Accpet': 'application/json',
};

parentsIdCompare(parentsId) async {
  Map data = { 'parentsId': parentsId };

  print('parentsId comparing');

  const String URL = 'http://3.34.194.177:8088/parents/id/compare';

  try {
    final response = await http.post(
      Uri.encodeFull(URL),
      headers: headers,
      body: jsonEncode(data)
    );

    parentsId = response.body;
  }

  catch (e) { print(e); }

  return int.parse(parentsId);
}

parentsKeyConfirm( parentsId, String name, String key ) async {
  var result;
  const String URL = 'http://3.34.194.177:8088/parents/key/confirm';
  Map data = { 'parentsId': parentsId, 'name': name, 'key': key };

  print('chekcing the key');

  try {
    final response = await http.post(
      Uri.encodeFull(URL),
      headers: headers,
      body: jsonEncode(data)
    );

    result = response.body;
  }

  catch (e) { print(e); }

  return result;
}

kidsLocationGet( int kidsId ) async {
  var result;

  const String URL = 'http://3.34.194.177:8088/parents/location/get';
  Map data = { 'kidsId': kidsId };

  print('getting kids location');

  try {
    final response = await http.post(
        Uri.encodeFull(URL),
        headers: headers,
        body: jsonEncode(data)
    );

    result = json.decode(response.body)['data'][0];
//    result = response.body;
  }

  catch (e) { print(e); }

  return result;
}