# fv_uikit_flutter

`fv_uikit_flutter` là Flutter package/plugin được định hướng để trở thành UI Kit dùng chung cho các ứng dụng Flutter, giúp thống nhất giao diện, tăng khả năng tái sử dụng component và chuẩn hóa cách tổ chức source code theo `Atomic Design`.

Ở thời điểm hiện tại, package đang ở giai đoạn khởi tạo nền tảng plugin đa nền tảng. API public hiện có còn tối giản và chủ yếu phục vụ việc kiểm tra kết nối native qua `MethodChannel`.

## Mô tả

Package này hướng tới các mục tiêu:

- Tập trung các thành phần UI dùng chung ở một nơi duy nhất.
- Chuẩn hóa design token như màu sắc, typography, spacing, radius và elevation.
- Giảm trùng lặp code giữa nhiều màn hình hoặc nhiều ứng dụng.
- Hỗ trợ phát triển theo cấu trúc rõ ràng, dễ mở rộng, dễ test.
- Sẵn sàng tích hợp các bridge native khi cần cho Android, iOS, macOS, Linux và Windows.

## Giới thiệu

Hiện trạng của package:

- Là một Flutter plugin đa nền tảng với cấu hình cho `android`, `ios`, `macos`, `linux`, `windows`.
- Đã có `platform interface`, `method channel` và app `example`.
- API public hiện tại mới có `getPlatformVersion()`.

Định hướng tiếp theo:

- Bổ sung các design token và theme dùng chung.
- Xây dựng bộ `atoms`, `molecules`, `organisms` theo chuẩn `Atomic Design`.
- Chuẩn hóa export public API để các app chỉ import các phần ổn định.
- Tăng coverage test cho widget, theme và platform bridge.

## Cài đặt

### 1. Dùng local path trong quá trình phát triển

```yaml
dependencies:
  fv_uikit_flutter:
    path: ../fv_uikit_flutter
```

Sau đó chạy:

```bash
flutter pub get
```

### 2. Dùng theo version khi package được publish

```yaml
dependencies:
  fv_uikit_flutter: ^0.0.1
```

Lưu ý: cách này chỉ áp dụng khi package đã được publish lên package registry nội bộ hoặc `pub.dev`.

## Sử dụng

### API hiện tại

Ví dụ sử dụng API hiện có của package:

```dart
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

final plugin = FvUikitFlutter();
final version = await plugin.getPlatformVersion();
```

Trong app `example`, package đang được dùng để gọi `getPlatformVersion()` và hiển thị kết quả lên màn hình.

### Định hướng sử dụng trong giai đoạn tiếp theo

Khi UI kit được mở rộng, package sẽ ưu tiên cung cấp:

- Design tokens dùng chung như `colors`, `spacing`, `typography`, `radius`.
- Các widget cơ bản có thể tái sử dụng cao.
- Theme hoặc `ThemeExtension` để đồng bộ giao diện giữa nhiều app.
- Những component tổ hợp được xây từ các phần tử nhỏ hơn, thay vì để widget phát triển tự phát theo từng màn hình.

## Cấu trúc package hiện tại

Hiện tại source code đang ở mức khởi tạo plugin:

```text
lib/
  fv_uikit_flutter.dart
  fv_uikit_flutter_method_channel.dart
  fv_uikit_flutter_platform_interface.dart

android/
ios/
macos/
linux/
windows/

example/
test/
```

Ý nghĩa nhanh:

- `fv_uikit_flutter.dart`: public entrypoint của package.
- `fv_uikit_flutter_platform_interface.dart`: định nghĩa contract cho các implementation theo nền tảng.
- `fv_uikit_flutter_method_channel.dart`: implementation mặc định dùng `MethodChannel`.
- Các thư mục platform: chứa native plugin code cho từng hệ điều hành.
- `example/`: app mẫu để kiểm tra package hoạt động.
- `test/`: unit test cho public API và method channel.

## Cấu trúc package theo chuẩn Atomic Design

Khi package phát triển thành UI kit đầy đủ, cấu trúc khuyến nghị sẽ như sau:

```text
lib/
  fv_uikit_flutter.dart
  src/
    core/
      constants/
      extensions/
      helpers/
      utils/

    tokens/
      colors/
      typography/
      spacing/
      radius/
      shadows/
      icons/

    atoms/
      buttons/
      text/
      icons/
      inputs/
      badges/

    molecules/
      form_fields/
      list_items/
      search_bars/
      cards/

    organisms/
      app_bars/
      headers/
      bottom_sheets/
      dialogs/
      sections/

    templates/
      auth/
      profile/
      dashboard/

    platform/
      channels/
      services/
```

## Nguyên tắc áp dụng Atomic Design

- `tokens`: chứa design token và những định nghĩa nền tảng, không chứa business logic.
- `atoms`: là các phần tử UI nhỏ nhất, có tính tái sử dụng cao và ít phụ thuộc ngữ cảnh.
- `molecules`: tổ hợp từ nhiều `atoms` để giải quyết một tác vụ UI nhỏ.
- `organisms`: tổ hợp lớn hơn từ `atoms` và `molecules`, thường đại diện cho một khối giao diện hoàn chỉnh.
- `templates`: định nghĩa layout hoặc khung trang, tập trung vào cấu trúc hơn là dữ liệu thật.
- `platform`: gom phần bridge native hoặc service đặc thù nền tảng để không trộn lẫn với UI layer.

## Lưu ý khi áp dụng cho UI kit

Với một package UI kit, không phải lúc nào cũng cần đưa `pages/` vào package.

- Nếu package chỉ cung cấp component dùng chung, nên tập trung vào `tokens`, `atoms`, `molecules`, `organisms` và một phần `templates`.
- `pages/` thường phù hợp hơn ở app tiêu thụ package, nơi gắn state, routing và business logic.
- Nếu cần màn hình minh họa hoặc showcase, có thể đặt trong `example/` thay vì export như public API chính thức.

## Nguyên tắc export và mở rộng

Để package dễ bảo trì về sau, nên áp dụng các nguyên tắc sau:

- Chỉ export public API qua `lib/fv_uikit_flutter.dart`.
- Hạn chế để app consumer import trực tiếp sâu vào `lib/src/...`.
- Mỗi layer chỉ phụ thuộc vào layer thấp hơn, tránh import chéo không kiểm soát.
- Widget nên tách rõ phần hiển thị, theme và hành vi để dễ test.
- Mỗi component mới nên đi kèm ví dụ sử dụng và test cơ bản.

## Định hướng phát triển tiếp theo

- Hoàn thiện `description`, `homepage` và metadata trong `pubspec.yaml`.
- Thêm design tokens và theme cơ bản.
- Xây bộ component đầu tiên theo `Atomic Design`.
- Mở rộng `example` thành showcase app cho UI kit.
- Bổ sung guideline đặt tên file, folder và quy tắc export.

## License

Package này hiện đi kèm file [LICENSE](LICENSE).
