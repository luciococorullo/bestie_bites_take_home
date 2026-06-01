import 'package:bestie_bites_take_home/features/city_search/data/dtos/city_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CityDto.fromJson', () {
    test('analizza il sample dello spec (Milano) e ignora i campi extra', () {
      // JSON dello spec arricchito coi campi che l'API ritorna davvero ma che
      // non mappiamo (slug, path, population, level…): devono essere ignorati.
      final json = <String, dynamic>{
        'id': 8047,
        'name': 'Milano',
        'description': 'Milano, Lombardia, Italia',
        'latitude': 45.4612939,
        'longitude': 9.172356290785304,
        'country_code': 'IT',
        'structured_formatting': <String, dynamic>{
          'main_text': 'Milano',
          'secondary_text': 'Lombardia, Italia',
        },
        'slug': 'milano',
        'path': 'it/lombardia/milano',
        'population': 1378689,
        'level': 'city',
      };

      final dto = CityDto.fromJson(json);

      expect(dto.id, 8047);
      expect(dto.name, 'Milano');
      expect(dto.countryCode, 'IT');
      expect(dto.structuredFormatting?.mainText, 'Milano');
      expect(dto.structuredFormatting?.secondaryText, 'Lombardia, Italia');
    });

    test('preserva i nomi UTF-8 (Milanówek)', () {
      final dto = CityDto.fromJson(<String, dynamic>{
        'id': 756135,
        'name': 'Milanówek',
        'description': 'Milanówek, Voivodato della Masovia, Polonia',
        'latitude': 52.12,
        'longitude': 20.66,
        'country_code': 'PL',
        'structured_formatting': <String, dynamic>{
          'main_text': 'Milanówek',
          'secondary_text': 'Voivodato della Masovia, Polonia',
        },
      });

      expect(dto.name, 'Milanówek');
      expect(dto.structuredFormatting?.mainText, 'Milanówek');
    });

    test('accetta lat/lng interi (num) esponendoli come double', () {
      final dto = CityDto.fromJson(<String, dynamic>{
        'id': 1,
        'name': 'Test',
        'latitude': 45,
        'longitude': 9,
      });

      expect(dto.latitude, 45.0);
      expect(dto.longitude, 9.0);
    });
  });

  group('CityDto.toEntity', () {
    test('appiattisce structured_formatting in mainText/secondaryText', () {
      final city = CityDto.fromJson(<String, dynamic>{
        'id': 8047,
        'name': 'Milano',
        'description': 'Milano, Lombardia, Italia',
        'latitude': 45.4612939,
        'longitude': 9.172356290785304,
        'country_code': 'IT',
        'structured_formatting': <String, dynamic>{
          'main_text': 'Milano',
          'secondary_text': 'Lombardia, Italia',
        },
      }).toEntity();

      expect(city.id, 8047);
      expect(city.name, 'Milano');
      expect(city.mainText, 'Milano');
      expect(city.secondaryText, 'Lombardia, Italia');
      expect(city.latitude, closeTo(45.4612939, 1e-9));
      expect(city.longitude, closeTo(9.172356290785304, 1e-9));
      expect(city.countryCode, 'IT');
    });

    test('fallback su name/description quando structured_formatting manca', () {
      final city = CityDto.fromJson(<String, dynamic>{
        'id': 2,
        'name': 'Roma',
        'description': 'Roma, Lazio, Italia',
        'latitude': 41.9,
        'longitude': 12.5,
        'country_code': 'IT',
      }).toEntity();

      expect(city.mainText, 'Roma');
      expect(city.secondaryText, 'Roma, Lazio, Italia');
    });

    test('fallback quando i campi di structured_formatting sono vuoti', () {
      final city = CityDto.fromJson(<String, dynamic>{
        'id': 3,
        'name': 'Napoli',
        'description': 'Napoli, Campania, Italia',
        'structured_formatting': <String, dynamic>{
          'main_text': '',
          'secondary_text': '',
        },
      }).toEntity();

      expect(city.mainText, 'Napoli');
      expect(city.secondaryText, 'Napoli, Campania, Italia');
    });

    test('default sicuri per i campi opzionali mancanti', () {
      final city = CityDto.fromJson(<String, dynamic>{
        'id': 4,
        'name': 'Atlantide',
      }).toEntity();

      expect(city.description, '');
      expect(city.countryCode, '');
      expect(city.latitude, 0);
      expect(city.longitude, 0);
      expect(city.mainText, 'Atlantide');
      expect(city.secondaryText, '');
    });
  });
}
