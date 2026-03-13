import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_view_tts/web_view_tts.dart';

@RoutePage()
class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  final TextEditingController _urlController = TextEditingController();
  bool _showSearchBar = true;
  bool _isLoading = false;
  double _loadingProgress = 0.0;
  InAppWebViewController? _webViewController;
  int _lastScrollY = 0;
  bool _initialUrlLoaded = false;
  bool _isLocked = false;
  String? _lockedDomain;

  @override
  void initState() {
    super.initState();
    _loadSavedUrl();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _loadUrl(String url) {
    _urlController.text = url;
    _saveUrl(url);
    if (_webViewController != null) {
      _webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
    }
  }

  void _loadSavedUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString('url');
    if (savedUrl != null && savedUrl.isNotEmpty) {
      _urlController.text = savedUrl;
    } else {
      _urlController.text = 'https://www.google.com';
    }
    
    // Load lock state and locked domain
    final isLocked = prefs.getBool('is_locked') ?? false;
    final lockedDomain = prefs.getString('locked_domain');
    
    setState(() {
      _initialUrlLoaded = true;
      _isLocked = isLocked;
      _lockedDomain = lockedDomain;
    });
    
    if (_webViewController != null) {
      _webViewController!.loadUrl(
        urlRequest: URLRequest(url: WebUri(_urlController.text)),
      );
    }
  }

  void _saveUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('url', url);
  }

  void _saveLockState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_locked', _isLocked);
    prefs.setString('locked_domain', _lockedDomain ?? '');
  }

  void _showMoreOptions(BuildContext context, Offset position) {
    if (_webViewController != null) {
      _webViewController!.getUrl().then((currentUrl) async {
        if (currentUrl != null) {
          final canGoBack = await _webViewController!.canGoBack();
          final canGoForward = await _webViewController!.canGoForward();
          
          showMenu(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.white),
            ),
            position: RelativeRect.fromLTRB(
              position.dx - 100,
              50,
              position.dx + 100,
              position.dy + 200,
            ),
            items: [
              PopupMenuItem(
                value: 'options',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: canGoBack ? () async {
                        Navigator.of(context).pop();
                        await _webViewController!.goBack();
                      } : null,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back,
                          color: canGoBack ? null : Colors.grey,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: canGoForward ? () async {
                        Navigator.of(context).pop();
                        await _webViewController!.goForward();
                      } : null,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_forward,
                          color: canGoForward ? null : Colors.grey,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        await _webViewController!.reload();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.refresh),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'lock',
                child: Row(
                  children: [
                    Icon(
                      _isLocked ? Icons.lock : Icons.lock_open,
                    ),
                    const SizedBox(width: 8),
                    Text(_isLocked ? 'Unlock' : 'Lock'),
                  ],
                ),
                onTap: () {
                  setState(() {
                    if (_isLocked) {
                      _isLocked = false;
                      _lockedDomain = null;
                    } else {
                      _isLocked = true;
                      _lockedDomain = Uri.parse(currentUrl.toString()).host;
                    }
                    _saveLockState();
                  });
                },
              ),
            ],
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: _showSearchBar ? 60 : 0,
            child: _showSearchBar
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _urlController,
                            decoration: InputDecoration(
                              hintText: 'Enter URL or search',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              suffixIcon: _urlController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _urlController.clear();
                                        setState(() {});
                                      },
                                      tooltip: 'Clear',
                                    )
                                  : null,
                            ),
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {});
                              }
                            },
                            onSubmitted: (value) {
                              String url = value.trim();
                              if (!url.startsWith('http')) {
                                url = 'https://www.google.com/search?q=$url';
                              }
                              _loadUrl(url);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTapDown: (details) =>
                              _showMoreOptions(context, details.globalPosition),
                          child: const Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          LinearProgressIndicator(
            value: _loadingProgress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(
              Colors.red,
            ),
          ),
          Expanded(
            child: _initialUrlLoaded
                ? InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri(_urlController.text),
                    ),
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
                    },
                    onLoadStart: (controller, url) async {
                      await WebViewTTS.init(controller: controller);
                    },
                    onLoadStop: (controller, url) {
                      setState(() {
                        if (url != null) {
                          _urlController.text = url.toString();
                          _saveUrl(url.toString());
                        }
                      });
                    },
                    onPageCommitVisible: (controller, url) {
                      setState(() {
                        if (url != null) {
                          _urlController.text = url.toString();
                          _saveUrl(url.toString());
                        }
                      });
                    },
                    onTitleChanged: (controller, title) {
                      controller.getUrl().then((url) {
                        if (url != null && mounted) {
                          setState(() {
                            _urlController.text = url.toString();
                            _saveUrl(url.toString());
                          });
                        }
                      });
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                          final url = navigationAction.request.url;
                          if (url != null && mounted) {
                            // Check domain restriction if locked
                            if (_isLocked && _lockedDomain != null) {
                              final newDomain = Uri.parse(url.toString()).host;
                              if (newDomain != _lockedDomain) {
                                // Show snackbar for blocked navigation
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Navigation blocked: Domain restriction is active'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                // Block navigation to different domain
                                return NavigationActionPolicy.CANCEL;
                              }
                            }
                            setState(() {
                              _urlController.text = url.toString();
                              _saveUrl(url.toString());
                            });
                          }
                          return NavigationActionPolicy.ALLOW;
                        },
                    onProgressChanged: (controller, progress) {
                      setState(() {
                        _loadingProgress = progress / 100.0;
                      });
                    },
                    onScrollChanged: (controller, x, y) {
                      // Hide search bar when scrolling down, show when scrolling up
                      debugPrint('Scrolling: y=$y, lastY=$_lastScrollY');
                      final scrollDelta = y - _lastScrollY;
                      if (scrollDelta.abs() > 100) {
                        setState(() {
                          _showSearchBar = scrollDelta <= 0;
                        });
                        _lastScrollY = y;
                      }
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
