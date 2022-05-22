import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:notion_api_sample/entities/model/item_model.dart';
import 'package:notion_api_sample/repositories/notion/failure_message.dart';

// http
// class NotionRepository {
//   static const String _baseUrl = 'https://api.notion.com/v1/';

//   final http.Client _client;

//   NotionRepository({http.Client? client}) : _client = client ?? http.Client();

//   void dispose() {
//     _client.close();
//   }

//   Future<List<Item>> fetchNotionItems() async {
//     try {
//       final url =
//           '${_baseUrl}databases/${dotenv.env['NOTION_DATABASE_ID']}/query';
//       final response = await _client.post(
//         Uri.parse(url),
//         headers: {
//           HttpHeaders.authorizationHeader:
//               'Bearer ${dotenv.env['NOTION_API_KEY']}',
//           'Notion-Version': '2022-02-22',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body) as Map<String, dynamic>;
//         print(data);
//         return (data['results'] as List).map((e) => Item.fromMap(e)).toList()
//           ..sort((a, b) => b.date.compareTo(a.date));
//       } else {
//         throw FailureMessage(message: 'Something went wrong!');
//       }
//     } catch (_) {
//       throw FailureMessage(message: 'Something went wrong!');
//     }
//   }
// }

// dio
class NotionRepository {
  static const baseUrl = 'https://api.notion.com/v1/';
  Dio dio = Dio();
  Future<List<Item>> fetchNotionItems() async {
    final url = '${baseUrl}databases/${dotenv.env["NOTION_DATABASE_ID"]}/query';
    try {
      dio.interceptors.addAll(<Interceptor>[
        // リクエスト・レスポンスのログを表示
        HeaderInterceptor(),
        LogInterceptor(),
      ]);
      Response<String> response = await dio.post(
        url,
      );
      print(response.data);
      if (response.statusCode == 200) {
        final responseBody = response.data;
        final data = jsonDecode(responseBody!) as Map<String, dynamic>;
        return (data['results'] as List).map((e) => Item.fromMap(e)).toList()
          ..sort(
            ((a, b) => b.date.compareTo(a.date)),
          );
      } else {
        throw FailureMessage(message: 'エラーが発生しました');
      }
    } on DioError catch (err) {
      throw FailureMessage(message: '${err.message}');
    }
  }
}

/// ヘッダーに認証情報などを付加する
class HeaderInterceptor extends Interceptor {
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Dio 経由のすべてのリクエストヘッダーに付加したい
    options.headers['Authorization'] = 'Bearer ${dotenv.env["NOTION_API_KEY"]}';
    options.headers['Notion-Version'] = '2022-02-22';
    return handler.next(options);
  }
}
