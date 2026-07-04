enum AppEnvironment { dev, staging, prod }

class AppConfig {
  final AppEnvironment environment;
  final String apiBaseUrl;
  final bool enableLogging;

  AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.enableLogging = true,
  });

  static AppConfig get dev => AppConfig(
        environment: AppEnvironment.dev,
        apiBaseUrl: 'https://dev-api.hasad.ps/api',
      );

  static AppConfig get staging => AppConfig(
        environment: AppEnvironment.staging,
        apiBaseUrl: 'https://staging-api.hasad.ps/api',
      );

  static AppConfig get prod => AppConfig(
        environment: AppEnvironment.prod,
        apiBaseUrl: 'https://api.hasad.ps/api',
        enableLogging: false,
      );
}

class EnvironmentConfig {
  static late AppConfig config;

  static void setEnvironment(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.dev:
        config = AppConfig.dev;
        break;
      case AppEnvironment.staging:
        config = AppConfig.staging;
        break;
      case AppEnvironment.prod:
        config = AppConfig.prod;
        break;
    }
  }
}
