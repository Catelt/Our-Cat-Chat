enum Status { none, loading, error, success }

class XHandle<T> {
  String? message;

  T? _data;

  T? get data => _data;

  Status _status = Status.loading;

  Status get status => _status;

  bool get isLoading => _status == Status.loading;

  bool get isSuccess => _status == Status.success;

  bool get isError => _status == Status.error;

  XHandle() {
    _status = Status.none;
  }

  XHandle.loading() {
    this._data = null;
    this.message = '';
    _status = Status.loading;
  }

  XHandle.success(T data) {
    this._data = data;
    this.message = '';
    _status = Status.success;
  }

  XHandle.error(this.message) {
    _data = null;
    _status = Status.error;
  }
}
