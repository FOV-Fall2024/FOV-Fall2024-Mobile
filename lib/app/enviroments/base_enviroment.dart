import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_storage_service.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/services/storage_service.dart';
import 'package:get_it/get_it.dart';
//Interfaces
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_attendance_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_auth_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_order_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_payment_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_schedule_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/contracts/i_shift_repository.dart';
//Repositories
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/attendance_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/auth_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/order_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/payment_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/schedule_repository.dart';
import 'package:fov_fall2024_waiter_mobile_app/app/repositories/data/shift_repository.dart';

final getIt = GetIt.instance;

//Setup
void setupDependencyInjection() {
  //Repositories
  getIt.registerLazySingleton<IAttendanceRepository>(
      () => AttendanceRepository());
  getIt.registerLazySingleton<IAuthRepository>(() => AuthRepository());
  getIt.registerLazySingleton<IOrderRepository>(() => OrderRepository());
  getIt.registerLazySingleton<IPaymentRepository>(() => PaymentRepository());
  getIt.registerLazySingleton<IScheduleRepository>(() => ScheduleRepository());
  getIt.registerLazySingleton<IShiftRepository>(() => ShiftRepository());
  //Services
  getIt.registerLazySingleton<IStorageService>(() => StorageService());
}
