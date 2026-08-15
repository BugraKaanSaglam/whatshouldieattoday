import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yemek_tarifi_app/global/app_images.dart';

class FoodImage extends StatefulWidget {
  final List<String>? imageUrls;
  final bool isSingleImage;
  final String? cacheKey;
  final int cacheWidth;
  final int cacheHeight;

  const FoodImage({
    super.key,
    required this.imageUrls,
    this.isSingleImage = true,
    this.cacheKey,
    this.cacheWidth = 640,
    this.cacheHeight = 640,
  });

  @override
  FoodImageState createState() => FoodImageState();
}

class FoodImageState extends State<FoodImage> {
  static final BaseCacheManager _cacheManager = CacheManager(
    Config(
      'recipeImagesCache',
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 400,
    ),
  );
  static final LinkedHashMap<String, ImageProvider> _memoryImageCache =
      LinkedHashMap<String, ImageProvider>();
  static const int _memoryCacheLimit = 150;

  int _currentIndex = 0;
  final PageController _pageController = PageController();
  List<String> validImages = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _processImages();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _precacheImages();
      _initialized = true;
    }
  }

  void _processImages() {
    validImages = <String>[];
    if (widget.imageUrls != null && widget.imageUrls!.isNotEmpty) {
      validImages = widget.imageUrls!.where((url) => _isValidUrl(url)).toList();
    }
    if (validImages.isEmpty) {
      validImages.add(AppImages.defaultFood);
    }
  }

  @override
  void didUpdateWidget(covariant FoodImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.imageUrls, widget.imageUrls) ||
        oldWidget.cacheKey != widget.cacheKey ||
        oldWidget.isSingleImage != widget.isSingleImage ||
        oldWidget.cacheWidth != widget.cacheWidth ||
        oldWidget.cacheHeight != widget.cacheHeight) {
      _currentIndex = 0;
      if (_pageController.hasClients) _pageController.jumpToPage(0);
      _processImages();
      _precacheImages();
    }
  }

  bool _isValidUrl(String url) {
    if (url.startsWith("assets/")) return true;
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }

  Future<void> _precacheImages() async {
    if (!mounted) return;
    final futures = <Future<void>>[];
    final int precacheCount = validImages.length > 4 ? 4 : validImages.length;
    for (int i = 0; i < precacheCount; i++) {
      final url = validImages[i];
      try {
        if (url.startsWith("assets/")) {
          futures.add(precacheImage(AssetImage(url), context));
        } else {
          futures.add(precacheImage(_networkProvider(url, index: i), context));
        }
      } catch (_) {}
    }
    try {
      await Future.wait(futures);
    } catch (_) {}
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildImageWidget(String imageUrl, {int? index}) {
    if (imageUrl.startsWith("assets/")) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        cacheWidth: widget.cacheWidth,
        cacheHeight: widget.cacheHeight,
        errorBuilder: (_, _, _) => Image.asset(
          AppImages.defaultFood,
          fit: BoxFit.cover,
          cacheWidth: widget.cacheWidth,
          cacheHeight: widget.cacheHeight,
        ),
      );
    }
    final cacheKey = _cacheKeyFor(imageUrl, index: index);
    final ImageProvider? cachedProvider = _memoryImageCache[cacheKey];
    if (cachedProvider != null) {
      return Image(
        image: cachedProvider,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      cacheKey: cacheKey,
      cacheManager: _cacheManager,
      memCacheWidth: widget.cacheWidth,
      memCacheHeight: widget.cacheHeight,
      maxWidthDiskCache: widget.cacheWidth,
      maxHeightDiskCache: widget.cacheHeight,
      useOldImageOnUrlChange: true,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      fit: BoxFit.cover,
      imageBuilder: (context, provider) {
        _storeInMemoryCache(cacheKey, provider);
        return Image(
          image: provider,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
        );
      },
      placeholder: (context, url) => const ColoredBox(
        color: Color(0xFFF1F5F9),
        child: Center(
          child: Icon(
            Icons.restaurant_rounded,
            color: Color(0xFFCBD5E1),
            size: 28,
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        if (index != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted &&
                index < validImages.length &&
                validImages[index] != AppImages.defaultFood) {
              setState(() {
                validImages[index] = AppImages.defaultFood;
              });
            }
          });
        }
        return Image.asset(
          AppImages.defaultFood,
          fit: BoxFit.cover,
          cacheWidth: widget.cacheWidth,
          cacheHeight: widget.cacheHeight,
        );
      },
    );
  }

  CachedNetworkImageProvider _networkProvider(String url, {int? index}) {
    return CachedNetworkImageProvider(
      url,
      cacheKey: _cacheKeyFor(url, index: index),
      cacheManager: _cacheManager,
      maxWidth: widget.cacheWidth,
      maxHeight: widget.cacheHeight,
    );
  }

  String _cacheKeyFor(String url, {int? index}) {
    final String base = widget.cacheKey ?? _stripQuery(url);
    final String dimensions = '${widget.cacheWidth}x${widget.cacheHeight}';
    final String indexedBase = !widget.isSingleImage && index != null
        ? '$base-$index'
        : base;
    return '$indexedBase-$dimensions';
  }

  void _storeInMemoryCache(String key, ImageProvider provider) {
    _memoryImageCache.remove(key);
    _memoryImageCache[key] = provider;
    if (_memoryImageCache.length > _memoryCacheLimit) {
      _memoryImageCache.remove(_memoryImageCache.keys.first);
    }
  }

  String _stripQuery(String url) {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) return url;
    return uri.replace(query: '', fragment: '').toString();
  }

  @override
  Widget build(BuildContext context) {
    if (validImages.isEmpty) {
      return Image.asset(
        AppImages.defaultFood,
        fit: BoxFit.cover,
        cacheWidth: widget.cacheWidth,
        cacheHeight: widget.cacheHeight,
      );
    }
    if (widget.isSingleImage) {
      return _buildImageWidget(validImages.first);
    }
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            key: ValueKey(validImages.length),
            controller: _pageController,
            itemCount: validImages.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) =>
                _buildImageWidget(validImages[index], index: index),
          ),
        ),
        if (validImages.length > 1)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                validImages.length,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: _currentIndex == i ? 12.0 : 8.0,
                  height: _currentIndex == i ? 12.0 : 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == i
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
