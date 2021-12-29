import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';

final localAuthProvider = Provider((_) => LocalAuthentication());

final authProvider = FutureProvider<bool>((ref) async {
  final LocalAuthentication auth = ref.read(localAuthProvider);
  return await auth.authenticate(localizedReason: "any auth");
});
