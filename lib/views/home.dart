import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exam/common.dart';
import 'package:exam/networks/weather_api.dart';
import 'package:exam/networks/weather_response.dart';
import 'package:exam/models/weather.dart';
import 'package:exam/views/home/fav_list.dart';

class HomePage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        Common.log4method("HomePage.build");

        final int cityId = Provider.of<WeatherModel>(context, listen: false).cityId;
        WeatherNetwork.getData4CityId(cityId).then( (WeatherResponse weatherResponse){
            Provider.of<WeatherModel>(context, listen: false).setNowWeater(weatherResponse);
        });

        return Scaffold(
            body: _HomeBody(),
            backgroundColor: Color.fromRGBO(37, 97, 161, 1.0),
            appBar: AppBar(
                title: Text("날씨"),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async { // 버튼 누르면 검색 화면으로 전환
                            final cityId = await Navigator.pushNamed(context, "/search");
                            // Common.log4panic(cityId);
                            if(cityId == null) return;
                            WeatherNetwork.getData4CityId(cityId).then( (WeatherResponse weatherResponse){
                                Provider.of<WeatherModel>(context, listen: false).setNowWeater(weatherResponse);
                            });
                        }
                    ),
                ],
            ),
        );
    }
}

/// 홈 내용
class _HomeBody extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        Common.log4method("HomePage > _HomeBody.build");

        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Expanded(
                    child: Consumer<WeatherModel>(
                        builder: (context, weatherModel, child) {
                            Common.log4method("HomePage > _HomeBody.build > Consumer<WeatherModel>");

                            return (weatherModel.nowWeather != null) ? _WeatherWidget(weatherModel.nowWeather) :
                                Center(child: CircularProgressIndicator()); // 로딩 화면인 척..
                        }
                    ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    child: FavoriteCityList(),
                )
            ],
        );
    }
}

/// 날씨 화면이 보여지는 부분
class _WeatherWidget extends StatelessWidget {
    final Weather _nowWeather;
    _WeatherWidget(this._nowWeather);

    @override
    Widget build(BuildContext context) {

        return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Image.asset("assets/images/${_nowWeather.icon.substring(0,2)}.png"),
                    // 온도
                    Text(
                        "${_nowWeather.temp.toStringAsFixed(2) }°C",
                        style: TextStyle(color: Colors.white, fontSize: 80.0)
                    ),
                    // 도시-국가
                    Text(
                        "${_nowWeather.cityName} - ${_nowWeather.countryCode}",
                        style: TextStyle(color: Colors.white70)
                    ),
                ],
            )
        );
    }
}