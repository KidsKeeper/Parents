import 'package:http/http.dart' as http;

import 'dart:convert';

import '../db/KikeeDB.dart';

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

  print('Server: chekcing the key');

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

kidsLocationGet( int number, int kidsId ) async {
  var result;
  var parentsId = await KikeeDB.instance.getParentsId();

  Map data = { 'kidsId': kidsId, 'parentsId': parentsId };

  String url;
  if( number == 0 ) { // get location
    print('Server: getting kids location');
    url = 'http://3.34.194.177:8088/parents/location/get';

    try {
      final response = await http.post(
        Uri.encodeFull(url),
        headers: headers,
        body: jsonEncode(data)
        );

      result = json.decode(response.body)['ldata'][0];
    }
    catch (e) { print(e); }

    return result;
  }

  else if( number == 1) { // get polygon
    print('Server: getting kids polygon');
    url = 'http://3.34.194.177:8088/parents/polygon/get';

    try {
      final response = await http.post(
        Uri.encodeFull(url),
        headers: headers,
        body: jsonEncode(data)
    );

      result = json.decode(response.body)['pdata'];
      KikeeDB.instance.insertKidsPolygon(result); // 내부 DB에 kids polygon 저장.
    }

    catch (e) { print(e); }
  }
}