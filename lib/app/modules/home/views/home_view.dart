import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/routes/app_pages.dart';

import '../../../../config/translations/strings_enum.dart';
import '../../../../utils/constants.dart';
import '../../../components/api_error_widget.dart';
import '../../../components/custom_icon_button.dart';
import '../../../components/my_widgets_animator.dart';
import '../controllers/home_controller.dart';
import 'widgets/home_shimmer.dart';
import 'widgets/weather_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: GetBuilder<HomeController>(
            builder: (_) => MyWidgetsAnimator(
              apiCallStatus: controller.apiCallStatus,
              loadingWidget: () => const HomeShimmer(),
              errorWidget: () => ApiErrorWidget(
                retryAction: () => controller.getUserLocation(),
              ),
              successWidget: () => ListView(
                children: [
                  20.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.hello.tr,
                              style: theme.textTheme.displayMedium,
                            ),
                            8.verticalSpace,
                            Text(
                              Strings.discoverTheWeather.tr,
                              style: theme.textTheme.displayMedium,
                            ),
                          ],
                        ),
                      ),
                      20.horizontalSpace,
                      CustomIconButton(
                        onPressed: () => controller.onChangeThemePressed(),
                        icon: GetBuilder<HomeController>(
                          id: controller.themeId,
                          builder: (_) => Icon(
                            controller.isLightTheme
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                            color: theme.iconTheme.color,
                          ),
                        ),
                        borderColor: theme.dividerColor,
                      ),
                      8.horizontalSpace,
                      CustomIconButton(
                        onPressed: () => controller.onChangeLanguagePressed(),
                        icon: SvgPicture.asset(
                          Constants.language,
                          fit: BoxFit.none,
                          color: theme.iconTheme.color,
                        ),
                        borderColor: theme.dividerColor,
                      ),
                    ],
                  ).animate().fade().slideX(
                    duration: 300.ms,
                    begin: -1,
                    curve: Curves.easeInSine,
                  ),
                  24.verticalSpace,
                  SizedBox(
                    height: 170.h,
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        viewportFraction: 1.0,
                        enlargeCenterPage: true,
                      ),
                      itemCount: 3,
                      itemBuilder: (context, itemIndex, pageViewIndex) {
                        return WeatherCard(weather: controller.currentWeather);
                      },
                    ).animate().fade().slideY(
                      duration: 300.ms,
                      begin: 1,
                      curve: Curves.easeInSine,
                    ),
                  ),
                  16.verticalSpace,
                  GetBuilder<HomeController>(
                    id: controller.dotIndicatorsId,
                    builder: (_) => Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: controller.activeIndex,
                        count: 3,
                        effect: WormEffect(
                          activeDotColor: Color.fromARGB(255, 138, 141, 130),
                          dotColor: Color.fromARGB(255, 138, 141, 130),
                          dotWidth: 10.w,
                          dotHeight: 10.h,
                        ),
                      ),
                    ),
                  ),
                  24.verticalSpace,
                  Text(
                    Strings.aroundTheWorld.tr,
                    style: theme.textTheme.displayMedium,
                  ).animate().fade().slideX(
                    duration: 300.ms,
                    begin: -1,
                    curve: Curves.easeInSine,
                  ),
                  16.verticalSpace,
                  ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: controller.weatherAroundTheWorld.length,
                    separatorBuilder: (context, index) => 16.verticalSpace,
                    itemBuilder: (context, index) => WeatherCard(
                      weather: controller.weatherAroundTheWorld[index],
                    ).animate(delay: (100 * index).ms).fade().slideY(
                      duration: 300.ms,
                      begin: 1,
                      curve: Curves.easeInSine,
                    ),
                  ),
                  24.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Get.toNamed(Routes.LOGIN);
            },
            backgroundColor: Color.fromARGB(255, 138, 141, 130),
            child: Icon(Icons.login),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              Get.toNamed(Routes.REGISTRATION);
            },
            child: Icon(Icons.person_add),
            backgroundColor: Color.fromARGB(255, 138, 141, 130),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
            },
            child: Icon(Icons.map),
            backgroundColor: Color.fromARGB(255, 138, 141, 130),
          ),
        ],
      ),
    );
  }
}
