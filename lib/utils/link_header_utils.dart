// Note: Helper function to extract 'since' value from the Link header

int? extractSinceFromLinkHeader(String? linkHeader) {
  if (linkHeader == null) return null;

  // Link Header: <https://api.github.com/users?per_page=10&since=19>; rel="next", <https://api.github.com/users{?since}>; rel="first"
  // 링크 헤더를 쉼표로 분리하여 여러 링크 중 'rel="next"'가 포함된 것을 찾음
  final parts = linkHeader.split(',');

  for (String part in parts) {
    if (part.contains('rel="next"')) {
      // 'since=' 이후의 숫자 값 추출
      final uriPart = part.split(';')[0]; // ';'로 나누어 URI 부분 추출
      final uri = Uri.parse(
          uriPart.trim().substring(1, uriPart.length - 1)); // <>를 제거하고 URI로 변환

      return int.tryParse(uri.queryParameters['since'] ?? ''); // since 값 반환
    }
  }

  return null; // 'rel="next"'가 없으면 null 반환
}
