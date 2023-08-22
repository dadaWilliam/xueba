import 'package:xueba/data/api/api_client.dart';

class ClassificationRepo {
  final ApiClient apiClient;

  ClassificationRepo({
    required this.apiClient,
  });

  getClassificationList() async {
    return await apiClient.getData("/api/classification", 1);
  }
}
