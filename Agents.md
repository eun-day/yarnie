# 프로젝트 가이드라인

## 1. 기획 및 요구사항 (Product Requirements)
- 이 프로젝트의 전체 기획과 기능 정의는 `@planning/Version 1 기획 29208fa3261c803c8802dd07376168e8.md` 파일을 최우선으로 참고해.
- 모든 구현 사항은 위 문서에 기술된 유저 시나리오를 벗어나지 않아야 해.

## 2. 디자인 및 에셋 (Design & Assets)
  - 피그마 디자인에서 SVG 아이콘을 가져올 때는 항상 `assets/icons/` 폴더에 `.svg` 파일로 저장한다.
  - `AppIcons` 클래스에 문자열로 추가하지 않는다.
  - 파일명은 `snake_case`를 사용한다. (예: `counter_settings.svg`)

## 3. SVG 에셋 호환성 (SVG Compatibility)
- 피그마에서 SVG를 추출할 때, `flutter_svg` 패키지와의 호환성을 위해 다음 규칙을 반드시 준수한다.
- **CSS 변수 제거**: `stroke="var(--stroke-0, ...)"`와 같은 CSS 변수 사용을 금지하고, 실제 색상 값(HEX 코드)으로 직접 명시한다.
- **크기 유연성**: SVG 루트 태그(` <svg> `)에서 `width`, `height` 속성을 제거하여 `viewBox`를 기준으로 유동적으로 크기가 조절되게 한다.
- **단순화**: 불필요한 ` <g> `(그룹) 태그나 `id`, `data-name` 속성 등을 최소화하여 정제된 코드로 저장한다.

## 4. 커뮤니케이션 (Communication)
- 유저와의 모든 대화 및 응답은 **한국어**를 기본으로 사용한다.
- 코드 설명이나 질문에 대한 답변도 한국어로 친절하게 작성한다.