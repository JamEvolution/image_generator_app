import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'OPENAI_API_KEY')
  static const String openAiApiKey = _Env.openAiApiKey;

  @EnviedField(varName: 'DEEP_SEEK_API_KEY')
  static const String deepSeekApiKey = _Env.deepSeekApiKey;

  @EnviedField(varName: 'STABLE_DIFFUSION_API_KEY')
  static const String stableDiffusionApiKey = _Env.stableDiffusionApiKey;

  @EnviedField(varName: 'DALL_E_API_KEY')
  static const String dallEApiKey = _Env.dallEApiKey;
} 