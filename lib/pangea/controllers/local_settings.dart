import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/class_model.dart';

class LocalSettings {
  late PangeaController _pangeaController;

  LocalSettings(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  bool userLanguageToolSetting(ToolSetting setting) =>
      _pangeaController.pStoreService.read(setting.toString()) ?? true;

  // bool get userEnableIT =>
  //     _pangeaController.pStoreService.read(ToolSetting.interactiveTranslator.toString()) ?? true;

  // bool get userEnableIGC =>
  //     _pangeaController.pStoreService.read(ToolSetting.interactiveGrammar.toString()) ?? true;

  // bool get userImmersionMode =>
  //     _pangeaController.pStoreService.read(ToolSetting.immersionMode.toString()) ?? true;

  // bool get userTranslationsTool =>
  //     _pangeaController.pStoreService.read(ToolSetting.translations.toString()) ?? true;

  // bool get userDefinitionsTool =>
  //     _pangeaController.pStoreService.read(ToolSetting.definitions.toString()) ?? true;
}
