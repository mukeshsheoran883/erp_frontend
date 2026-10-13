import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'BASE_URL_DEV', obfuscate: true)
  static final String baseUrlDev = _Env.baseUrlDev;

  @EnviedField(varName: 'BASE_URL_LIVE', obfuscate: true)
  static final String baseUrlLive = _Env.baseUrlLive;

  @EnviedField(varName: 'IS_RELEASE', obfuscate: true)
  static final bool isRelease = _Env.isRelease;

  @EnviedField(varName: 'LOG_REQUEST', obfuscate: true)
  static final bool logRequest = _Env.logRequest;
}
