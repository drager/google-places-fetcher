library google_places_fetcher.settings;

import 'dart:io';

Map environmentVariables = Platform.environment;

final googleApiKey = environmentVariables['GOOGLE_PLACES_API_KEY'];
