import 'package:dartfield/dartfield.dart';
import 'package:drift/drift.dart';

/// Converts the BitField BigInto a format that the database can understand.
final class BitFieldConverter<BitType extends Enum>
    extends TypeConverter<BitField<BitType>, BigInt> {
  const BitFieldConverter();

  /// Ready to go instance of this converter.
  static const BitFieldConverter instance = BitFieldConverter();

  @override
  BitField<BitType> fromSql(BigInt fromDb) => BitField(fromDb);

  @override
  BigInt toSql(BitField<BitType> value) => value.value;
}
