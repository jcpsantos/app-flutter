import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';

const apiCategoria = {
  'nome': 'Moeda',
  'rota': 'moeda',
};

class Api{
  final HttpClient _httpClient = HttpClient();
  final String _url = 'flutter.udacity.com';

  Future<List> getUnidades(String categoria) async{
    final uri = Uri.https(_url, '/$categoria');
    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null || jsonResponse['unidades']==null){
      print('Erro ao trazer as unidades');
      return null;
    }
    return jsonResponse['unidades'];
  }

  Future<double> convert(
    String categoria, String total, String entUnidade, String saidaUnidade) async {
      final uri = Uri.https(_url, '/$categoria/convert',
      {'amount': total, 'from': entUnidade, 'to': saidaUnidade});
      final jsonResponse = await _getJson(uri);
      if (jsonResponse == null || jsonResponse['status'] == null){
        print('Erro ao fazer a conversão');
        return null;
      }else if (jsonResponse['status'] == 'error'){
        print(jsonResponse['messagem']);
        return null;
      }
      return jsonResponse['conversão'].toDouble();
    }

    Future<Map<String, dynamic>> _getJson(Uri uri) async {
      try{
        final httpRequest = await _httpClient.getUrl(uri);
        final httpResponse = await httpRequest.close();
        if (httpResponse.statusCode != HttpStatus.OK){
          return null;
        }
        final responseBody = await httpResponse.transform(utf8.decoder).join();
        return json.decode(responseBody);
      } on Exception catch (e){
        print('$e');
        return null;
      }
    }
}