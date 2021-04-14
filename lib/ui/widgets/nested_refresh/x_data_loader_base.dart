import 'dart:async';

import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:neighbours/models/Model.dart';
import 'package:rxdart/rxdart.dart';

/// [DATA] 列表中的数据的数据类型
/// [MODEL] 服务返回的数据结构对应的数据类
abstract class DataLoadMoreBase<DATA, MODEL> extends ListBase<DATA> {
  /// 使用 BehaviorSubject 会保留最后一次的值,所有监听是会受到回调
  final _streamController =
      new BehaviorSubject<DataLoadMoreBase<DATA, MODEL>>();
  ScrollController scrollController;
  EasyRefreshController refreshController;
  bool isRefreshError = false;
  bool isRefreshEmpty = false;

  /// 页面通过监听stream变化更新界面
  Stream<DataLoadMoreBase<DATA, MODEL>> get stream => _streamController.stream;

  void onStateChanged(DataLoadMoreBase<DATA, MODEL> source) {
    if (!_streamController.isClosed) _streamController.add(source);
  }

  void init(EasyRefreshController refreshController) {
    this.refreshController = refreshController;
  }

  void dispose() {
    _streamController.close();
    if (refreshController != null) {
      refreshController.dispose();
      refreshController = null;
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

  /// 加载数据
  /// [isRefresh] 是否清空原来的数据
  Future<void> loadData([bool isRefresh = false]) async {
    int currentPage = isRefresh ? 1 : _currentPage + 1;
    if (refreshController != null) {
      refreshController.finishLoad(success: true);
      if (isRefresh) {
        refreshController.finishLoad(noMore: false);
      }
    }

    Model model = await getRequest(isRefresh, currentPage, _pageSize);
    bool success = await handlerData(model, isRefresh);

    if (isRefresh) {
      isRefreshError = false;
      isRefreshEmpty = false;
    }

    isRefreshEmpty = isEmpty;
    var noMore = length < _pageSize * currentPage;
    var empty = length == 0;

    print(
        "loadData: isRefresh == $isRefresh; success == $success; noMore == $noMore; empty == $empty");
    if (refreshController != null) {
      if (success) {
        _currentPage = currentPage;

        if (isRefresh) {
          refreshController.finishRefresh(success: success);
          if (noMore) {
            refreshController.finishLoad(noMore: noMore);
          }
        } else {
          refreshController.finishLoad(noMore: noMore);
        }
      } else {
        if (isRefresh) {
          isRefreshError = true;
          refreshController.finishRefresh(success: success);
        } else {
          refreshController.finishLoad(success: success);
        }
      }
    }
    onStateChanged(this);
  }

  /// 构造请求
  /// [isRefresh] 是否清空原来的数据
  /// [currentPage] 将要请求的页码
  /// [pageSize] 每页多少数据
  @protected
  Future<Model> getRequest(bool isRefresh, int currentPage, int pageSize);

  Future<bool> handlerData(Model model, bool isRefresh) async {
    if (isRefresh) clear();
    if (model == null || model.isError()) {
      return false;
    }
    addAll((model.data as List<dynamic>).map((d) {
      return d as DATA;
    }));
    return true;
  }
}
