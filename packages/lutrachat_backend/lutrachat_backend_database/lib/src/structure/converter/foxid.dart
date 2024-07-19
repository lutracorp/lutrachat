import 'package:drift/drift.dart';
import 'package:foxid/foxid.dart';

/// Converts the FOxID into a format that the database can understand.
final class FOxIDConverter extends TypeConverter<FOxID, String> {
  const FOxIDConverter();

  /// Ready to go instance of this converter.
  static const FOxIDConverter instance = FOxIDConverter();

  /// Generates FOxID in a format understood by the database.
  static String generate() => FOxID.generate().toJson();

  @override
  FOxID fromSql(String fromDb) => FOxID.fromJson(fromDb);

  @override
  String toSql(FOxID value) => value.toJson();
}
