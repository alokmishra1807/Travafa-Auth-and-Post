import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travafa/features/post/data/model/post_model.dart';
import 'package:travafa/features/post/domain/usecases/get_post_detail_usercase.dart';


part 'post_detail_event.dart';
part 'post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final GetPostDetailUseCase _getPostDetailUseCase;

  PostDetailBloc({
    required GetPostDetailUseCase getPostDetailUseCase,
  })  : _getPostDetailUseCase = getPostDetailUseCase,
        super(PostDetailInitial()) {
    on<LoadPostDetailEvent>(_onLoadPostDetail);
  }

  Future<void> _onLoadPostDetail(
    LoadPostDetailEvent event,
    Emitter<PostDetailState> emit,
  ) async {
    emit(PostDetailLoading());

    final res = await _getPostDetailUseCase(
      GetPostDetailParams(postId: event.postId),
    );

    res.fold(
      (failure) => emit(PostDetailError(failure.message)),
      (post) => emit(PostDetailLoaded(post)),
    );
  }
}

