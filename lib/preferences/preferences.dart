import 'package:seriesapp/utils/enum.dart';
import 'package:seriesapp/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static final String sTabIndex = 'tabIndex';
  static int _tabIndex = 0;
  static int get tabIndex => _prefs.getInt(sTabIndex) ?? _tabIndex;
  static set tabIndex(int index) {
    _tabIndex = index;
    _prefs.setInt(sTabIndex, index);
  }

  static final String sTypeIndex = 'typeIndex';
  static int _typeIndex = 0;
  static int get typeIndex {
    int t = _prefs.getInt(sTypeIndex) ?? _typeIndex;
    Utils.typeFilter = t == 0 ? ETypeFilter.tv : ETypeFilter.movie;
    return t;
  }

  static set typeIndex(int index) {
    _typeIndex = index;
    _prefs.setInt(sTypeIndex, index);
  }

  static final String sOrderTV = 'orderTV';
  static int _orderTV = 11;
  static int get orderTV => _prefs.getInt(sOrderTV) ?? _orderTV;

  static set orderTV(int index) {
    _orderTV = index;
    _prefs.setInt(sOrderTV, index);
  }

  static final String sOrderMovie = 'orderMovie';
  static int _orderMovie = 13;
  static int get orderMovie => _prefs.getInt(sOrderMovie) ?? _orderMovie;

  static set orderMovie(int index) {
    _orderMovie = index;
    _prefs.setInt(sOrderMovie, index);
  }

  static const String _sbackUp = 'backUp';
  static String _backUp = '';
  static String get backUp => _prefs.getString(_sbackUp) ?? _backUp;
  static set backUp(String value) {
    _backUp = value;
    _prefs.setString(_sbackUp, _backUp);
  }

  static const String _sEmail = 'email';
  static String _email = '';
  static String get email => _prefs.getString(_sEmail) ?? _email;
  static set email(String value) {
    _email = value;
    _prefs.setString(_sEmail, value);
  }

  static const String _sPassBackUp = 'passBackUp';
  static String _passBackUp = '';
  static String get passBackUp => _prefs.getString(_sPassBackUp) ?? _passBackUp;
  static set passBackUp(String value) {
    _passBackUp = value;
    _prefs.setString(_sPassBackUp, value);
  }

  static const String _sLicense = 'license';
  static String _license = '';
  static String get license => _prefs.getString(_sLicense) ?? _license;
  static set license(String value) {
    _license = value;
    _prefs.setString(_sLicense, value);
  }

  static const String _sAdulto = 'adulto';
  static bool _adulto = false;
  static bool get adulto => _prefs.getBool(_sAdulto) ?? _adulto;
  static set adulto(bool value) {
    _adulto = value;
    _prefs.setBool(_sAdulto, value);
  }

  static const String _sImagesInDark = 'imagesInDark';
  static bool _imagesInDark = false;
  static bool get imagesInDark => _prefs.getBool(_sImagesInDark) ?? _imagesInDark;
  static set imagesInDark(bool value) {
    _imagesInDark = value;
    _prefs.setBool(_sImagesInDark, value);
  }
}
