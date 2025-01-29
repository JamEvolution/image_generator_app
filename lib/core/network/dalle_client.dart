import '../../features/image_generation/data/models/dalle_request.dart';
import '../../features/image_generation/data/models/dalle_response.dart';
import '../env/env.dart';
import 'base_client.dart';

class DalleClient extends BaseClient {
  DalleClient()
      : super(
          baseUrl: 'https://api.openai.com',
          apiKey: Env.openAiApiKey,
        );

  Future<DalleResponse> generateImage(DalleRequest request) async {
    final response = await post<Map<String, dynamic>>(
      '/v1/images/generations',
      data: request.toJson(),
    );
    return DalleResponse.fromJson(response);
  }
} 