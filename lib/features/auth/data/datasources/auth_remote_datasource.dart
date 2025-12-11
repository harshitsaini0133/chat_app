import '../../../../core/api/api_routes.dart';
import '../../../../core/api/base_repository.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/services/local_storage.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password, String role);
}

class AuthRemoteDataSourceImpl extends BaseRepository
    implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required DioClient dioClient}) : super(dioClient);

  @override
  Future<UserModel> login(String email, String password, String role) async {
    return safeApiCall(
      apiCall: () => dioClient.post(
        ApiConstants.login,
        data: {'email': email, 'password': password, 'role': role},
      ),
      parser: (data) {
        // The parser receives the response data.
        // Based on safeApiCall logic, it might unwrap 'data'.
        // Let's assume the API returns the user object directly or wrapped.
        // If ApiConstants.login returns the user JSON, we parse it.
        // safeApiCall tries to unwrap 'data' key.
        final userModel = UserModel.fromJson(data);
        // Save token and userId on successful login
        LocalStorage().saveToken(userModel.token);
        LocalStorage().saveUserId(userModel.id);
        return userModel;
      },
      resolveData: true, // Let safeApiCall handle wrapping check
    );
  }
}
