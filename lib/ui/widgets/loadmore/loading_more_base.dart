import 'dart:async';

import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum PageState {
  Init, // 现在什么也没做(网络请求前,网络请求完成)
  None, // 现在什么也没做(网络请求前,网络请求完成)
  Refreshing, // 刷新中
  RefreshError, // 刷新中
  Empty, // 空数据
  Loading, // 加载中
  LoadError, // 加载失败
  LoadEnd, // 加载失败
}

/// [DATA] 列表中的数据的数据类型
/// [MODEL] 服务返回的数据结构对应的数据类
abstract class DataLoadBase<DATA, MODEL> extends _DataLoadBloc<DataLoadBase<DATA, MODEL>> {
  DATA mData;

  /// 是否有业务错误
  bool get isRefreshError => _pageState == PageState.RefreshError;

  /// 是否加载中
  bool get isLoading => _pageState == PageState.Loading;

  /// 页面状态
  PageState get pageState => _pageState;

  /// 页面状态
  PageState _pageState = PageState.None;

  bool get hasData {
    if (mData == null) {
      return false;
    }
    if (mData is List) {
      return (mData as List).length > 0;
    }
    return true;
  }

  @mustCallSuper
  Future<bool> obtainData([bool isRefresh = false]) async {
    if (isLoading) return true;
    _pageState = PageState.Loading;
    onStateChanged(this);

    var success = false;
    try {
      success = await _loadData(isRefresh);
      if (success) {
        // 加载数据成功
        _pageState = PageState.None;
      } else {
        // 加载数据业务逻辑错误
        _pageState = PageState.LoadError;
      }
    } catch (e) {
      // 网络异常
      _pageState = PageState.LoadError;
    }

    onStateChanged(this);
    return success;
  }

  /// 加载数据
  Future<bool> _loadData([bool isRefresh = false]) async {
    MODEL model = await getRequest(isRefresh);
    bool success = await handlerData(model, isRefresh);
    return success;
  }

  @protected
  Future<MODEL> getRequest(bool isRefresh);

  /// 重载这个方法,必须在这个方法将数据添加到列表中
  /// [model] 本次请求回来的数据
  /// [isRefresh] 是否清空原来的数据
  @protected
  Future<bool> handlerData(MODEL model, bool isRefresh);
}

/// [DATA] 列表中的数据的数据类型
/// [MODEL] 服务返回的数据结构对应的数据类
abstract class DataLoadMoreBase<DATA, MODEL> extends ListBase<DATA> {
  /// 使用 BehaviorSubject 会保留最后一次的值,所有监听是会受到回调
  final _streamController = new BehaviorSubject<DataLoadMoreBase<DATA, MODEL>>();
  ScrollController scrollController;
  bool isShowFloat = false;

  /// 页面通过监听stream变化更新界面
  Stream<DataLoadMoreBase<DATA, MODEL>> get stream => _streamController.stream;

  void onStateChanged(DataLoadMoreBase<DATA, MODEL> source) {
    if (!_streamController.isClosed) _streamController.add(source);
  }

  void dispose() {
    _streamController.close();
    if (scrollController!=null) {
      scrollController.dispose();
    }
  }

  void initScrollController(ScrollController scrollController) {
      this.scrollController = scrollController;
      scrollController.addListener(() {
          int offset = scrollController.offset.toInt();
          // print('offset = ${offset}');
          if (offset < 1000 && isShowFloat) {
            isShowFloat = false;
            onStateChanged(this);
          } else if (offset > 1000 && !isShowFloat) {
            isShowFloat = true;
            onStateChanged(this);
          }
        });
      }

  void scrollTop() {
    if (scrollController!=null) {
      scrollController.animateTo(0.0,
        duration: new Duration(microseconds: 1000), curve: ElasticInCurve());
    }
  }

  final _mData = <DATA>[];

  @override
  DATA operator [](int index) {
    return _mData[index];
  }

  @override
  void operator []=(int index, DATA value) {
    _mData[index] = value;
  }

  void addDatas(List<DATA> datas) {
     _mData.addAll(datas);
  }

  @override
  int get length => _mData.length;

  @override
  set length(int newLength) => _mData.length = newLength;

  final _pageSize = 4;

  int _currentPage = 1;

  /// 页面状态
  PageState _pageState = PageState.Init;

  //初始化
  bool get isInit => _pageState == PageState.Init;

  //是否刷新中
  bool get isRefreshing => _pageState == PageState.Refreshing;

  /// 是否有数据
  bool get isEmpty => _pageState == PageState.Empty;

   //刷新错误
  bool get isRefreshError => _pageState == PageState.RefreshError;

  /// 加载错误
  bool get isLoadError => _pageState == PageState.LoadError;

  /// 是否加载中
  bool get isLoading => _pageState == PageState.Loading;

   /// 加载错误
  bool get isLoadEnd => _pageState == PageState.LoadEnd;

   /// 待加载
  bool get isNone => _pageState == PageState.None || _pageState == PageState.Init;






  /// 页面状态
  PageState get pageState => _pageState;

  /// 拉取数据
  /// [isRefresh] 是否清空原来的数据
  @mustCallSuper
  Future<bool> obtainData([bool isRefresh = false,bool isReTry = false]) async {
    // print("obtainData start1 pageState = $pageState ");
    if (!isRefresh) {
       if (isLoadEnd || isRefreshing || isLoading) return true;
    }
    if (isInit){
        _pageState = PageState.Init;
    } else {
       _pageState = isRefresh ? isReTry ? PageState.Init : PageState.Refreshing : PageState.Loading;
    }
    onStateChanged(this);
    // print("obtainData start2 pageState = $pageState ");
    var success = false;
    try {
      success = await _loadData(isRefresh);
      //  print("obtainData success = $success");
      // print("obtainData length = $length _pageSize*_currentPage = ${_pageSize*_currentPage}");
      if (success) {
        // 加载数据成功v
        // _pageState = PageState.None;
       _pageState = length>0 ? length == _pageSize*_currentPage ? PageState.None : PageState.LoadEnd : PageState.Empty;
      } else {
        // 加载数据业务逻辑错误
        _pageState = isRefresh ? PageState.RefreshError : PageState.LoadError;
      }
    } catch (e) {
      // 网络异常
      _pageState = isRefresh ? PageState.RefreshError : PageState.LoadError;
    }
    // print("obtainData end pageState = $pageState ");
    onStateChanged(this);
    //  print("obtainData 2");
    return success;
  }

  /// 加载数据
  /// [isRefresh] 是否清空原来的数据
  Future<bool> _loadData([bool isRefresh = false]) async {
    int currentPage =  isRefresh ? 1 : _currentPage+1;
    MODEL model = await getRequest(isRefresh, currentPage, _pageSize);
    bool success = await handlerData(model, isRefresh);
    if (success) _currentPage = currentPage;
    return success;
  }

  /// 是否还有更多数据
  @protected
  bool hasMore();

  /// 构造请求
  /// [isRefresh] 是否清空原来的数据
  /// [currentPage] 将要请求的页码
  /// [pageSize] 每页多少数据
  @protected
  Future<MODEL> getRequest(bool isRefresh, int currentPage, int pageSize);

  /// 重载这个方法,必须在这个方法将数据添加到列表中
  /// [model] 本次请求回来的数据
  /// [isRefresh] 是否清空原来的数据
  @protected
  Future<bool> handlerData(MODEL model, bool isRefresh);
}

/// 数据加载Bloc
class _DataLoadBloc<T> {
  /// 使用 BehaviorSubject 会保留最后一次的值,所有监听是会受到回调
  final _streamController = new BehaviorSubject<T>();

  // final _streamController = new StreamController<LoadingMoreBase<DATA, MODEL>>.broadcast();

  Stream<T> get stream => _streamController.stream;

  void onStateChanged(T source) {
    if (!_streamController.isClosed) _streamController.add(source);
  }

  void dispose() {
    _streamController.close();
  }
}
