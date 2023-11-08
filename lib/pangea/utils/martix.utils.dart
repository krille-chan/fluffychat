import 'package:matrix/matrix.dart';

class MatrixUtils {
  static String generateUniqueTransactionId(Client client) {
    return client.generateUniqueTransactionId();
  }
}
