import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../config/theme/my_theme.dart';
import '../../../../config/translations/localization_service.dart';
import '../../../../utils/constants.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../data/models/weather_model.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';
import '../../../services/location_service.dart';
import '../views/widgets/location_dialog.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  var currentLanguage = LocalizationService.getCurrentLocal().languageCode;
  late WeatherModel currentWeather;
  List<WeatherModel> weatherAroundTheWorld = [];
  final dotIndicatorsId = 'DotIndicators';
  final themeId = 'Theme';
  ApiCallStatus apiCallStatus = ApiCallStatus.loading;
  var isLightTheme = MySharedPref.getThemeIsLight();
  var activeIndex = 1;

  @override
  void onInit() async {
    super.onInit();
    await checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    if (!await LocationService().hasLocationPermission()) {
      Get.dialog(const LocationDialog());
    } else {
      await getUserLocation();
    }
  }

  Future<void> getUserLocation() async {
    var locationData = await LocationService().getUserLocation();
    if (locationData != null) {
      await getCurrentWeather('${locationData.latitude},${locationData.longitude}');
    }
  }

  Future<void> getCurrentWeather(String location) async {
    await BaseClient.safeApiCall(
      url: Constants.currentWeatherApiUrl,
      requestType: RequestType.get,
      queryParameters: {
        Constants.key: Constants.mApiKey,
        Constants.q: location,
        Constants.lang: currentLanguage,
      },
      onSuccess: (response) async {
        currentWeather = WeatherModel.fromJson(response.data);
        await getWeatherAroundTheWorld();
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  Future<void> getWeatherAroundTheWorld() async {
    weatherAroundTheWorld.clear();
    final cities = ['London', 'Cairo', 'Alaska'];
    
    await Future.forEach(cities, (city) async {
      try {
        final response = await BaseClient.safeApiCall(
          url: Constants.currentWeatherApiUrl,
          requestType: RequestType.get,
          queryParameters: {
            Constants.key: Constants.mApiKey,
            Constants.q: city,
            Constants.lang: currentLanguage,
          },
          onSuccess: (response) {
            weatherAroundTheWorld.add(WeatherModel.fromJson(response.data));
            update();
          },
          onError: (error) => BaseClient.handleApiError(error),
        );
      } catch (error) {
        debugPrint('Error fetching weather for $city: $error');
      }
    });
  }

  void onCardSlided(int index, ScrollNotificationMetrics reason) {
    activeIndex = index;
    update([dotIndicatorsId]);
  }

  void onChangeThemePressed() {
    MyTheme.changeTheme();
    isLightTheme = MySharedPref.getThemeIsLight();
    update([themeId]);
  }
  
  Future<void> onChangeLanguagePressed() async {
    currentLanguage = currentLanguage == 'ar' ? 'en' : 'ar';
    await LocalizationService.updateLanguage(currentLanguage);
    apiCallStatus = ApiCallStatus.loading;
    update();
    await getUserLocation();
  }
}

class ScrollNotificationMetrics {
}

