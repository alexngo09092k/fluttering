import '../modules/http.dart';
import 'base_response.dart';

abstract class BaseRepository<T extends BaseResponse> {
  String get baseUrl;

  IClientHttp get client => ClientHttp.instance;

  T handleResponse<Q, R>(ClientResponse<R?> response, {Q? Function(R?)? fromData});
}
