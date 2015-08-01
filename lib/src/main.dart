import 'package:google_places_fetcher/google_places_fetcher.dart';


main(List<String> arguments) async {
  var citiesWithCoordinates = await getCoordinatesFromCityNames(cities);
  citiesWithCoordinates.forEach((city) {
    getPlacesIn(city.latitude, city.longitude, 9000);
  });
}
