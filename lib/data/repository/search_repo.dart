import 'package:xueba/data/api/api_client.dart';

class SearchRepo {
  final ApiClient apiClient;

  SearchRepo({
    required this.apiClient,
  });

  getSearchResult(String search, int page) async {
    return await apiClient.getSearchData("/api/video", search, page);
  }
}
