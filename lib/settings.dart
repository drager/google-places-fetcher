library google_places_fetcher.settings;

import 'dart:io';

Map environmentVariables = Platform.environment;

final googleApiKey = environmentVariables['GOOGLE_PLACES_API_KEY'];

final postgresUri = 'postgres://${environmentVariables['DATABASE_USER']}'
    ':${environmentVariables['DATABASE_PASSWORD']}@${environmentVariables['DATABASE_HOST']}:'
    '${environmentVariables['DATABASE_PORT']}/${environmentVariables['DATABASE_NAME']}';
