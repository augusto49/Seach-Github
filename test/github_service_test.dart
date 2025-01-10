import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:petize/app/shared/models/repo_model.dart';
import 'package:petize/app/shared/models/user_model.dart';
import 'package:petize/app/shared/utils/git_service.dart';
import 'dart:convert';

import 'github_service_test.mocks.dart';
import 'package:http/testing.dart' as http_testing;

@GenerateMocks([http.Client])
void main() {
  late GithubService service;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    service = GithubService();
  });

  group('GithubService', () {
    group('fetchUserProfile', () {
      test(
          'deve retornar um UserProfileModel se a requisição for bem-sucedida (status 200)',
          () async {
        final username = 'testuser';
        final mockResponse = {
          'name': 'Test User',
          'avatar_url': 'https://avatar.com/testuser',
          'followers': 100,
          'following': 200,
          'bio': 'test bio',
          'company': 'test company',
          'location': 'test location',
          'email': 'test@test.com',
          'blog': 'test.com',
          'twitter_username': 'test_twitter',
        };

        when(mockClient
                .get(Uri.parse('https://api.github.com/users/$username')))
            .thenAnswer(
                (_) async => http.Response(json.encode(mockResponse), 200));

        final user = await service.fetchUserProfile(username);

        expect(user, isA<UserProfileModel>());
        expect(user.name, 'Test User');
        expect(user.avatarUrl, 'https://avatar.com/testuser');
        expect(user.followers, 100);
        expect(user.following, 200);
        expect(user.bio, 'test bio');
        expect(user.company, 'test company');
        expect(user.location, 'test location');
        expect(user.email, 'test@test.com');
        expect(user.blog, 'test.com');
        expect(user.twitterUsername, 'test_twitter');
      });

      test(
          'deve lançar uma exceção se a requisição não for bem-sucedida (status != 200)',
          () async {
        final username = 'testuser';
        when(mockClient
                .get(Uri.parse('https://api.github.com/users/$username')))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        expect(() => service.fetchUserProfile(username),
            throwsA(isA<Exception>()));
      });
    });

    group('fetchRepositories', () {
      test(
          'deve retornar uma lista de RepoModel se a requisição for bem-sucedida (status 200)',
          () async {
        final username = 'testuser';
        final page = 1;
        final perPage = 10;
        final sortOption = 'full_name';

        final mockResponse = [
          {
            'name': 'repo1',
            'description': 'description 1',
            'html_url': 'https://repo1.com',
            'stargazers_count': 10,
            'updated_at': '2023-10-27T00:00:00Z'
          },
          {
            'name': 'repo2',
            'description': 'description 2',
            'html_url': 'https://repo2.com',
            'stargazers_count': 20,
            'updated_at': '2023-10-28T00:00:00Z'
          },
        ];
        when(mockClient.get(Uri.parse(
                'https://api.github.com/users/$username/repos?page=$page&per_page=$perPage&sort=$sortOption')))
            .thenAnswer(
                (_) async => http.Response(json.encode(mockResponse), 200));

        final repos = await service.fetchRepositories(
            username, page, perPage, sortOption);

        expect(repos, isA<List<RepoModel>>());
        expect(repos.length, 2);
        expect(repos[0].name, 'repo1');
        expect(repos[0].description, 'description 1');
        expect(repos[0].htmlUrl, 'https://repo1.com');
        expect(repos[0].stargazersCount, 10);
        expect(repos[0].updatedAt, '2023-10-27T00:00:00Z');
        expect(repos[1].name, 'repo2');
        expect(repos[1].description, 'description 2');
        expect(repos[1].htmlUrl, 'https://repo2.com');
        expect(repos[1].stargazersCount, 20);
        expect(repos[1].updatedAt, '2023-10-28T00:00:00Z');
      });

      test(
          'deve lançar uma exceção se a requisição não for bem-sucedida (status != 200)',
          () async {
        final username = 'testuser';
        final page = 1;
        final perPage = 10;
        final sortOption = 'full_name';
        when(mockClient.get(Uri.parse(
                'https://api.github.com/users/$username/repos?page=$page&per_page=$perPage&sort=$sortOption')))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        expect(
            () =>
                service.fetchRepositories(username, page, perPage, sortOption),
            throwsA(isA<Exception>()));
      });
    });
  });
}
