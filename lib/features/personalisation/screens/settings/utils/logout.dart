import 'package:cheezechoice/data/repositories/authentication_repo.dart';
import 'package:cheezechoice/routes/routes.dart';
import 'package:cheezechoice/utils/local_storage/storage_utility.dart';
import 'package:get/get.dart';

Future<void> logout() async {
  await AuthenticationRepository.instance.logout();
  await TLocalStorage.init(AuthenticationRepository.instance.authUser!.uid);
  Get.offAllNamed(TRoutes.signIn);
}
