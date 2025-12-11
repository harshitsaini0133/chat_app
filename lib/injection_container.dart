import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/dio_client.dart';
import 'core/services/socket_service.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

import 'features/chat/data/datasources/chat_remote_datasource.dart';
import 'features/chat/data/datasources/chat_socket_datasource.dart';
import 'features/chat/data/datasources/chat_socket_datasource_impl.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/get_chats_usecase.dart';
import 'features/chat/domain/usecases/get_messages_usecase.dart';
import 'features/chat/domain/usecases/send_message_usecase.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/chat/presentation/bloc/message_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Register DioClient
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Register SocketService
  sl.registerLazySingleton<SocketService>(() => SocketService());

  // Features - Auth
  // Bloc
  sl.registerFactory(() => AuthBloc(loginUseCase: sl()));

  // Usecases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: sl()),
  );

  // Features - Chat
  // Bloc
  sl.registerFactory(() => ChatBloc(getChatsUseCase: sl()));
  sl.registerFactory(
    () => MessageBloc(getMessagesUseCase: sl(), sendMessageUseCase: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => GetChatsUseCase(sl()));
  sl.registerLazySingleton(() => GetMessagesUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl(), socketDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<ChatSocketDataSource>(
    () => ChatSocketDataSourceImpl(socketService: sl()),
  );
}
