import 'package:flutter_soloud/flutter_soloud.dart';

class SoundService {
  final SoLoud _soLoud = SoLoud.instance;

  // Пути к ассетам
  static const String _correctPath = 'assets/sounds/correct.mp3';
  static const String _wrongPath = 'assets/sounds/wrong.mp3';
  static const String _neutralPath = 'assets/sounds/neutral.mp3';

  late AudioSource _correctSource;
  late AudioSource _wrongSource;
  late AudioSource _neutralSource;

  SoundService();

  /// Инициализация и предзагрузка звуков
  Future<void> init() async {
    // Инициализируем движок
    await _soLoud.init();

    // Загружаем звуковые ресурсы
    _correctSource = await _soLoud.loadAsset(_correctPath);
    _wrongSource = await _soLoud.loadAsset(_wrongPath);
    _neutralSource = await _soLoud.loadAsset(_neutralPath);
  }

  Future<void> playCorrect({double volume = 1.0}) async {
    await _playSource(_correctSource, volume: volume);
  }

  Future<void> playWrong({double volume = 1.0}) async {
    await _playSource(_wrongSource, volume: volume);
  }

  Future<void> playNeutral({double volume = 1.0}) async {
    await _playSource(_neutralSource, volume: volume);
  }

  Future<void> _playSource(AudioSource src, {double volume = 1.0}) async {
    try {
      await _soLoud.play(src, volume: volume);
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  /// Отключение и освобождение ресурсов
  Future<void> dispose() async {
    // Остановим все и выгрузим источники
    await _soLoud.disposeSource(_correctSource);
    await _soLoud.disposeSource(_wrongSource);
    await _soLoud.disposeSource(_neutralSource);

    // Деинициализируем движок
    _soLoud.deinit();
  }
}
