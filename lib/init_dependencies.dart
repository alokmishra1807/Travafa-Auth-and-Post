import 'package:get_it/get_it.dart';
import 'package:travafa/core/utils/profile_privacy.dart';

import 'package:travafa/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:travafa/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:travafa/features/auth/domain/repository/auth_repository.dart';
import 'package:travafa/features/auth/domain/usecases/login_usecase.dart';
import 'package:travafa/features/auth/domain/usecases/signup_usecase.dart';
import 'package:travafa/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:travafa/features/post/data/datasources/post_remote_datasouce.dart';
import 'package:travafa/features/post/data/repositories/post_repository_imp.dart';
import 'package:travafa/features/post/domain/repository/post_repository.dart';
import 'package:travafa/features/post/domain/usecases/create_post_usecase.dart';
import 'package:travafa/features/post/domain/usecases/delete_post_usercase.dart';
import 'package:travafa/features/post/domain/usecases/get_post_detail_usercase.dart';
import 'package:travafa/features/post/domain/usecases/get_post_usecase.dart';
import 'package:travafa/features/post/presentation/bloc/feed_bloc.dart';
import 'package:travafa/features/post/presentation/bloc/post_detail_bloc.dart';

// NEW imports for profile (you added profile bloc under post feature)

import 'package:travafa/features/post/presentation/bloc/user_profile_bloc.dart';

final serviceLocator = GetIt.instance;

void initDependecies() {
  _initAuth();
  _initPost();
}

void _initAuth() {
  // 🔹 Data source
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // 🔹 Repository
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(), // AuthRemoteDataSource
    ),
  );

  // 🔹 Usecases
  serviceLocator.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(
      serviceLocator(), // AuthRepository
    ),
  );

  serviceLocator.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      serviceLocator(), // AuthRepository
    ),
  );

  // 🔹 Bloc (factory = new instance each time)
  serviceLocator.registerFactory<AuthBloc>(
    () => AuthBloc(
      userSignUp: serviceLocator<SignUpUseCase>(),
      userLogin: serviceLocator<LoginUseCase>(),
    ),
  );
}

void _initPost() {
  // 🔹 Data source (dummy backend for posts)
  serviceLocator.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(),
  );

  // 🔹 Repository
  serviceLocator.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      serviceLocator(), // PostRemoteDataSource
    ),
  );

  // 🔹 Privacy store (in-memory)
  serviceLocator.registerLazySingleton<ProfilePrivacyStore>(
    () => ProfilePrivacyStore(),
  );

  // 🔹 Usecases
  serviceLocator.registerLazySingleton<GetPostsUseCase>(
    () => GetPostsUseCase(
      serviceLocator(), // PostRepository
    ),
  );

  serviceLocator.registerLazySingleton<CreatePostUseCase>(
    () => CreatePostUseCase(
      serviceLocator(), // PostRepository
    ),
  );

  serviceLocator.registerLazySingleton<DeletePostUseCase>(
    () => DeletePostUseCase(
      serviceLocator(), // PostRepository
    ),
  );

  serviceLocator.registerLazySingleton<GetPostDetailUseCase>(
    () => GetPostDetailUseCase(
      serviceLocator(), // PostRepository
    ),
  );

  // 🔹 Blocs
  serviceLocator.registerFactory<FeedBloc>(
    () => FeedBloc(
      getPosts: serviceLocator<GetPostsUseCase>(),
      createPost: serviceLocator<CreatePostUseCase>(),
      deletePost: serviceLocator<DeletePostUseCase>(),
    ),
  );

  serviceLocator.registerFactory<PostDetailBloc>(
    () => PostDetailBloc(
      getPostDetailUseCase: serviceLocator<GetPostDetailUseCase>(),
    ),
  );

  // 🔹 UserProfileBloc (under post feature) - uses PostRepository + ProfilePrivacyStore
  serviceLocator.registerFactory<UserProfileBloc>(
    () => UserProfileBloc(
      postRepository: serviceLocator<PostRepository>(),
      privacyStore: serviceLocator<ProfilePrivacyStore>(),
    ),
  );
}
