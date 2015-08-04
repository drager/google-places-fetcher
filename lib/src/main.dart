import 'package:google_places_fetcher/google_places_fetcher.dart';
import 'dart:async';


main(List<String> arguments) async {
  var citiesWithCoordinates = await getCoordinatesFromCityNames(cities);
  citiesWithCoordinates.forEach((city) {
    new Future.delayed(new Duration(seconds: 4), () async {
      getPlacesIn(city.latitude, city.longitude, 9000);
    });
  });
}
