import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // https://software-creator.tistory.com/26 참고
import 'package:exam/common.dart';
import 'package:exam/models/weather.dart';
import 'package:exam/models/city.dart';
import 'package:exam/models/fav_city.dart';
import 'package:exam/models/search_keyword.dart';
import 'package:exam/views/intro.dart';
import 'package:exam/views/home.dart';
import 'package:exam/views/search.dart';

void main() => runApp(MyApp());
/// 시작
class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        Common.log4method("MyApp.build");

        return MultiProvider( // 멀티 프로바이더를 사용
            providers: [
                Provider(builder: (context) => CityModel()), // 도시 정보 목록을 가지고 있고 + 한번 읽어오면 변하지 않음!
                ChangeNotifierProvider(builder: (context) => WeatherModel()), // 홈(날씨)화면 표시용 데이터들
                ChangeNotifierProvider(builder: (context) => SearchKeywordModel()), // 홈(날씨)화면 표시용 데이터들
                ChangeNotifierProxyProvider<CityModel, FavoriteCityModel> ( // 즐겨찾는 도시
                    builder: (context, cityModel, previousFavCity) => FavoriteCityModel(cityModel, previousFavCity)
                ),
            ],
            /// 머터리얼앱 사용
            child:  MaterialApp(
                title: 'Weather Provider Demo',
                initialRoute: '/',
                routes: {
                    // '/intro': (context) => IntroPage(), '/': (context) => HomePage(), // 디버깅용으로 인트로 생략시
                    '/': (context) => IntroPage(), // 인트로(스플래시) 화면
                    '/home': (context) => HomePage(), // 홈(현재날씨) 화면
                    '/search': (context) => SearchPage(), // 지역 검색 화면
                },
            ),
        );
    }
}

