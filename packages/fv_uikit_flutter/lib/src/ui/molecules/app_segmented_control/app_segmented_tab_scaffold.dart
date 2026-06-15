import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

class AppSegmentedTabScaffoldItem {
  final AppSegmentedControlItem controlItem;
  final Widget content;

  /// Tùy chỉnh Lazy Load riêng cho tab này.
  /// - `true`: Chỉ build khi người dùng chọn tab này lần đầu.
  /// - `false`: Build ngay khi màn hình chính mở ra (Eager load).
  /// - `null`: Kế thừa giá trị mặc định từ [AppSegmentedTabScaffold.lazyLoad].
  final bool? lazyLoad;

  const AppSegmentedTabScaffoldItem({
    required this.controlItem,
    required this.content,
    this.lazyLoad,
  });
}

class AppSegmentedTabScaffold extends StatefulWidget {
  final List<AppSegmentedTabScaffoldItem> tabs;
  final AppSegmentedControlStyle style;
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;

  /// Cấu hình Lazy Load mặc định cho tất cả các tab (mặc định là `true`).
  final bool lazyLoad;

  /// Bật/tắt hiệu ứng slide trái/phải khi chuyển tab (mặc định là `true`).
  final bool animated;

  /// Thời gian của hiệu ứng chuyển tab (mặc định là 280ms).
  final Duration animationDuration;

  /// Màu sắc cho tab active, inactive và padding cho thanh điều khiển.
  final Color? activeColor;
  final Color? inactiveColor;
  final EdgeInsetsGeometry? padding;

  const AppSegmentedTabScaffold({
    super.key,
    required this.tabs,
    this.style = AppSegmentedControlStyle.tablet,
    this.initialIndex = 0,
    this.onTabChanged,
    this.lazyLoad = true,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 280),
    this.activeColor,
    this.inactiveColor,
    this.padding,
  });

  @override
  State<AppSegmentedTabScaffold> createState() => _AppSegmentedTabScaffoldState();
}

class _AppSegmentedTabScaffoldState extends State<AppSegmentedTabScaffold> {
  late int _currentIndex;
  late List<bool> _activatedTabs;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    _activatedTabs = List.generate(widget.tabs.length, (index) {
      final tab = widget.tabs[index];
      final isTabLazy = tab.lazyLoad ?? widget.lazyLoad;
      return index == _currentIndex || !isTabLazy;
    });
  }

  @override
  void didUpdateWidget(covariant AppSegmentedTabScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    final tabsChanged = widget.tabs.length != oldWidget.tabs.length;
    final indexChanged = widget.initialIndex != oldWidget.initialIndex;

    if (tabsChanged || indexChanged) {
      setState(() {
        if (tabsChanged) {
          _activatedTabs = List.generate(widget.tabs.length, (index) {
            final tab = widget.tabs[index];
            final isTabLazy = tab.lazyLoad ?? widget.lazyLoad;
            return index == widget.initialIndex || !isTabLazy;
          });
        }
        if (indexChanged) {
          _currentIndex = widget.initialIndex;
          if (_currentIndex >= 0 && _currentIndex < _activatedTabs.length) {
            _activatedTabs[_currentIndex] = true;
          }
        }
      });
    }
  }

  void _onTabSelected(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
      _activatedTabs[index] = true;
    });
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSegmentedControl(
          items: widget.tabs.map((tab) => tab.controlItem).toList(),
          selectedIndex: _currentIndex,
          style: widget.style,
          onSelected: _onTabSelected,
          activeColor: widget.activeColor,
          inactiveColor: widget.inactiveColor,
          padding: widget.padding,
        ),
        const SizedBox(height: SpacingTokens.gapM),
        Expanded(
          child: _AnimatedIndexedStack(
            index: _currentIndex,
            animated: widget.animated,
            duration: widget.animationDuration,
            children: List.generate(widget.tabs.length, (index) {
              if (_activatedTabs[index]) {
                return widget.tabs[index].content;
              }
              return const SizedBox.shrink();
            }),
          ),
        ),
      ],
    );
  }
}

/// Widget nội bộ: Stack tùy chỉnh hỗ trợ hiệu ứng slide trái/phải khi
/// chuyển index. Giữ nguyên state của tất cả tab đã được kích hoạt bằng
/// cách dùng [Offstage] cho các tab ẩn (không xóa khỏi cây widget).
///
/// Cấu trúc cây luôn nhất quán tại mỗi vị trí:
///   Offstage → AnimatedBuilder → FractionalTranslation → content
/// Điều này đảm bảo Flutter không dispose element khi chuyển trạng thái,
/// tránh việc gọi lại initState và refetch API.
class _AnimatedIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final bool animated;
  final Duration duration;

  const _AnimatedIndexedStack({
    required this.index,
    required this.children,
    required this.animated,
    required this.duration,
  });

  @override
  State<_AnimatedIndexedStack> createState() => _AnimatedIndexedStackState();
}

class _AnimatedIndexedStackState extends State<_AnimatedIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _inSlide;
  late Animation<Offset> _outSlide;

  int _previousIndex = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.index;

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _previousIndex = widget.index;
          _isAnimating = false;
        });
        _controller.reset();
      }
    });

    _inSlide = const AlwaysStoppedAnimation(Offset.zero);
    _outSlide = const AlwaysStoppedAnimation(Offset.zero);
  }

  @override
  void didUpdateWidget(covariant _AnimatedIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.index != widget.index) {
      if (widget.animated) {
        final direction = widget.index > oldWidget.index ? 1.0 : -1.0;

        _inSlide = Tween<Offset>(
          begin: Offset(direction, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

        _outSlide = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(-direction, 0),
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

        setState(() {
          _previousIndex = oldWidget.index;
          _isAnimating = true;
        });

        _controller.forward(from: 0);
      } else {
        setState(() {
          _previousIndex = widget.index;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        // Cấu trúc nhất quán tại MỌI vị trí — không bao giờ thay đổi type:
        //   Offstage → AnimatedBuilder → FractionalTranslation → content
        // Chỉ thay đổi thuộc tính (offstage, translation), không thay đổi type.
        children: List.generate(widget.children.length, (index) {
          final isActive = index == widget.index;
          final isExiting = index == _previousIndex && _isAnimating;

          return Offstage(
            // Chỉ hiện tab đang active hoặc đang trong animation thoát ra
            offstage: !isActive && !isExiting,
            child: AnimatedBuilder(
              animation: _controller,
              // `child` được cache bởi AnimatedBuilder — content không rebuild
              // khi animation chạy, giữ nguyên state bên trong.
              child: widget.children[index],
              builder: (context, child) {
                Offset offset = Offset.zero;
                if (_isAnimating) {
                  if (isActive) offset = _inSlide.value;
                  if (isExiting) offset = _outSlide.value;
                }
                return FractionalTranslation(
                  translation: offset,
                  child: child,
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

