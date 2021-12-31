import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';

final localAuthProvider = Provider((_) => LocalAuthentication());

final authStateProvider = StateProvider<bool>((_) => false);
