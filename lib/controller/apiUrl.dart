// ignore_for_file: file_names

class ApiUrls {
  static const String baseUrl = 'https://fc3b-125-164-18-207.ngrok.io';
  static const String loginUrl = '$baseUrl/api/login';
  // order
  static const String getOrder = '$baseUrl/api/order/getall';
  static const String addOrder = '$baseUrl/api/order/create';
  // personel
  static const String getPersonel = '$baseUrl/api/personel/getall';
  static const String addPersonel = '$baseUrl/api/personel/add';
  static const String getAbsen = '$baseUrl/api/personel/absen/getall';
  static const String getAbsenByName = '$baseUrl/api/personel/absen/name';
  static const String updatePersonel = '$baseUrl/api/personel/update';
  static const String deletePersonel = '$baseUrl/api/personel/delete';
  static const String absenPersonel = '$baseUrl/api/personel/absen';
  // peralatan
  static const String getPeralatan = '$baseUrl/api/peralatan/getall';

  static const String addPeralatan = '$baseUrl/api/peralatan/add';
  // daily
  static const String getDaily = '$baseUrl/api/daily/getall';

  static const String addDaily = '$baseUrl/api/daily/add';
  // Index
  static const String getIndex = '$baseUrl/api/indeks/getall';

  static const String addIndex = '$baseUrl/api/indeks/add';
  // Inpeksi
  static const String getInpeksi = '$baseUrl/api/inspeksi/getall';

  static const String addInpeksi = '$baseUrl/api/inspeksi/add';
  // Pemakaian
  static const String getPemakaian = '$baseUrl/api/pemakaian/getall';

  static const String addPemakaian = '$baseUrl/api/pemakaian/add';
}
