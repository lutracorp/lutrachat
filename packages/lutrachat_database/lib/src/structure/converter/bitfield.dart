import 'package:dartfield/dartfield.dart';
import 'package:drift/drift.dart';

/// Converts the BitField BigInto a format that the database can understand.
final class BitFieldConverter extends TypeConverter<BitField, BigInt> {
  const BitFieldConverter();

  /// Ready to go instance of this converter.
  static const BitFieldConverter instance = BitFieldConverter();

  @override
  BitField fromSql(BigInt fromDb) => BitField(fromDb);

  @override
  BigInt toSql(BitField value) => value.value;
}
