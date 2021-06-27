import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HttpService {
  final String TOKEN_PREFIX = "Bearer ";
  final String JW_TOKEN="eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjYWU3MDhhMjUwMGNiOGZmYzIyZDllZDM4YmU4YjM0MSIsInN1YiI6IjYwZDU4OTBkYTZkOTMxMDAyYzg5NTllZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.raK0IC0lQXoGZZ2741JJetilqga-nnksBwJCPwynRew";

  getHeaders() async {
    //Set the cookie to headers
    final headers = {
      'Content-Type': 'application/json;charset=utf-8',
      'Authorization': TOKEN_PREFIX + JW_TOKEN
    };
    return headers;
  }

  Future<Response> makeHttpCall(type, url, payload) async {
    final headers = await getHeaders();
    Response response;
    if (type == "GET") {
      response = await http.get(url, headers: headers);
    } else if (type == "POST") {
      response = await http.post(url, headers: headers, body: payload);
    } else if (type == "PUT") {
      response = await http.put(url, headers: headers, body: payload);
    } else if (type == "DELETE") {
      response = await http.delete(url, headers: headers);
    }

    if (response != null && response.statusCode == 302
        && response.headers['location'] != null
        && response.headers['location'].contains("/login")) {
    } else if (response != null && response.headers["content-type"] != null
        && response.headers["content-type"].contains("text/html")
        && response.body.contains("/auth/login")) {
    } else {

      return response;
    }
  }


  Future<Response> uploadImage(filepath, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(await getHeaders());
    request.files.add(await http.MultipartFile.fromPath('file', filepath));
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return response;
  }
}
