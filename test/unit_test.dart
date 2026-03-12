import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/authentification/domain/repositories/auth_repository.dart';
import 'package:pro_dictant/features/authentification/domain/usecases/login.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late Login useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = Login( authRepository: mockRepository,);
  });

  const email = 'test@test.com';
  const password = '123456';

  group('LoginUseCase', () {
    test('should return UserEntity when login is successful', () async {
      // arrange
      when(() => mockRepository.login(
            email: email,
            password: password,
          )).thenAnswer((_) async => Right(Future<void>));

      // act
      final result = await useCase(
        email: email, password: password,
      );

      // assert
      expect(result, Right(Future<void>));

      verify(() => mockRepository.login(
            email: email,
            password: password,
          )).called(1);

      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthFailure when login fails', () async {
      // arrange
      when(() => mockRepository.login(
            email: email,
            password: password,
          )).thenAnswer((_) async => Left(AuthFailure(code: 'wrong-password')));

      // act
      final result = await useCase(
        email: email,
        password: password,
      );

      expect(result, Left(AuthFailure(code: 'wrong-password')));

      verify(() => mockRepository.login(
            email: email,
            password: password,
          )).called(1);

      verifyNoMoreInteractions(mockRepository);
    });
  });
}
