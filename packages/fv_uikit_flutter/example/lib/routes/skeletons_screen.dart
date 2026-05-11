import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

class SkeletonsScreen extends StatelessWidget {
  const SkeletonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DocsScaffold(
      title: const DocsText(en: 'Skeleton', vi: 'Skeleton'),
      description: const DocsText(
        en:
            'Use skeleton placeholders to preserve layout and perceived speed while data is still loading.',
        vi:
            'Dùng skeleton placeholder để giữ layout và cải thiện cảm nhận tốc độ khi dữ liệu vẫn đang tải.',
      ),
      doc: widgetDocFor('skeleton'),
      children: const [
        ExampleSection(
          title: DocsText(en: 'Text lines', vi: 'Dòng văn bản'),
          description: DocsText(
            en: 'Useful for headings, paragraphs, and metadata rows.',
            vi: 'Phù hợp cho tiêu đề, đoạn văn và các dòng metadata.',
          ),
          child: _SkeletonTextExample(),
        ),
        SizedBox(height: SpacingTokens.gapL),
        ExampleSection(
          title: DocsText(en: 'List item', vi: 'Dòng danh sách'),
          description: DocsText(
            en: 'A common avatar and content placeholder for feeds.',
            vi: 'Placeholder phổ biến cho avatar và nội dung trong danh sách.',
          ),
          child: _SkeletonListExample(),
        ),
        SizedBox(height: SpacingTokens.gapL),
        ExampleSection(
          title: DocsText(en: 'Card block', vi: 'Khối card'),
          description: DocsText(
            en: 'Combine multiple shapes to mirror a card layout.',
            vi: 'Kết hợp nhiều shape để mô phỏng bố cục card.',
          ),
          child: _SkeletonCardExample(),
        ),
      ],
    );
  }
}

class _SkeletonTextExample extends StatelessWidget {
  const _SkeletonTextExample();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSkeleton(width: 180, height: 24),
        SizedBox(height: SpacingTokens.gapS),
        AppSkeleton(height: 14),
        SizedBox(height: SpacingTokens.gapXS),
        AppSkeleton(width: 260, height: 14),
        SizedBox(height: SpacingTokens.gapXS),
        AppSkeleton(width: 220, height: 14),
      ],
    );
  }
}

class _SkeletonListExample extends StatelessWidget {
  const _SkeletonListExample();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _SkeletonListTile(),
        SizedBox(height: SpacingTokens.gapM),
        _SkeletonListTile(),
      ],
    );
  }
}

class _SkeletonListTile extends StatelessWidget {
  const _SkeletonListTile();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        AppSkeleton(width: 48, height: 48, shape: BoxShape.circle),
        SizedBox(width: SpacingTokens.gapM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSkeleton(width: 140, height: 16),
              SizedBox(height: SpacingTokens.gapXS),
              AppSkeleton(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkeletonCardExample extends StatelessWidget {
  const _SkeletonCardExample();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorTokens.white,
        borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
        border: Border.all(color: ColorTokens.borderSecondary),
      ),
      child: const Padding(
        padding: EdgeInsets.all(SpacingTokens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSkeleton(height: 160),
            SizedBox(height: SpacingTokens.gapM),
            AppSkeleton(width: 180, height: 20),
            SizedBox(height: SpacingTokens.gapS),
            AppSkeleton(height: 14),
            SizedBox(height: SpacingTokens.gapXS),
            AppSkeleton(width: 240, height: 14),
            SizedBox(height: SpacingTokens.gapM),
            Row(
              children: [
                Expanded(child: AppSkeleton(height: 40)),
                SizedBox(width: SpacingTokens.gapS),
                Expanded(child: AppSkeleton(height: 40)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
