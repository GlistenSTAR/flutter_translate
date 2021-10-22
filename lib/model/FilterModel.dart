class FilterModel {
  int order;
  String nameID;
  String nameTH;
  bool checked;

  FilterModel({
    required this.order,
    required this.nameID,
    required this.nameTH,
    required this.checked,
  });

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'nameID': nameID,
      'nameTH': nameTH,
      'checked': checked,
    };
  }

  factory FilterModel.fromJson(Map<String, dynamic> map) {
    if (map.isEmpty)
      return FilterModel(order: 0, nameID: "", nameTH: "", checked: false);

    return FilterModel(
      order: map['order'] ?? 0,
      nameID: map['nameID'] ?? "",
      nameTH: map['nameTH'] ?? "",
      checked: map['checked'] ?? false,
    );
  }

  static List<FilterModel> fromJsonList(jsonList) {
    if (jsonList == null) return [];
    return jsonList
        .map<FilterModel>((obj) => FilterModel.fromJson(obj))
        .toList();
  }

  static List<FilterModel> getLevelMapping() {
    return [
      FilterModel(
          order: 0, nameID: "kindergarten", nameTH: "อนุบาล", checked: false),
      FilterModel(
          order: 1, nameID: "elementary", nameTH: "ประถม", checked: false),
      FilterModel(
          order: 2,
          nameID: "middle_school",
          nameTH: "มัธยมต้น",
          checked: false),
      FilterModel(
          order: 3, nameID: "high_school", nameTH: "มัธยมปลาย", checked: false),
      FilterModel(
          order: 4, nameID: "university", nameTH: "มหาลัย", checked: false),
      FilterModel(
          order: 5, nameID: "general", nameTH: "บุคคลทั่วไป", checked: false)
    ];
  }

  static List<FilterModel> getLocationMapping() {
    return [
      FilterModel(
          order: 0, nameID: "online", nameTH: "ออนไลน์", checked: false),
      FilterModel(order: 1, nameID: "bts", nameTH: "BTS", checked: false),
      FilterModel(order: 2, nameID: "mrt", nameTH: "MRT", checked: false),
      FilterModel(order: 3, nameID: "siam", nameTH: "สยาม", checked: false),
      FilterModel(order: 4, nameID: "chula", nameTH: "จุฬาฯ", checked: false),
      FilterModel(
          order: 5,
          nameID: "tha_phra_chan",
          nameTH: "ท่าพระจันทร์",
          checked: false),
      FilterModel(
          order: 6,
          nameID: "rangsit",
          nameTH: "รังสิต (ฟิวเจอร์, มธ, ม.รังสิต, ม.กรุงเทพ)",
          checked: false),
      FilterModel(
          order: 7,
          nameID: "kaset",
          nameTH: "เกษตร - นวมินทร์",
          checked: false),
      FilterModel(
          order: 8, nameID: "ramintra", nameTH: "รามอินทรา", checked: false),
      FilterModel(
          order: 9, nameID: "khlong_toei", nameTH: "คลองเตย", checked: false),
      FilterModel(
          order: 10, nameID: "khlong_san", nameTH: "คลองสาน", checked: false),
      FilterModel(
          order: 11,
          nameID: "khlong_sam_wa",
          nameTH: "คลองสามสา",
          checked: false),
      FilterModel(
          order: 12, nameID: "khan_na_yao", nameTH: "คันนายาว", checked: false),
      FilterModel(
          order: 13, nameID: "chatuchak", nameTH: "จตุจักร", checked: false),
      FilterModel(
          order: 14, nameID: "chom_thong", nameTH: "จอมทอง", checked: false),
      FilterModel(
          order: 15, nameID: "don_mueang", nameTH: "ดอนเมือง", checked: false),
      FilterModel(
          order: 16, nameID: "din_daeng", nameTH: "ดินแดง", checked: false),
      FilterModel(order: 17, nameID: "dusit", nameTH: "ดุสิต", checked: false),
      FilterModel(
          order: 18, nameID: "taling_chan", nameTH: "ตลิ่งชัน", checked: false),
      FilterModel(
          order: 19,
          nameID: "thawi_watthana",
          nameTH: "ทวีวัฒนา",
          checked: false),
      FilterModel(
          order: 20, nameID: "thung_khru", nameTH: "ทุ่งครุ", checked: false),
      FilterModel(
          order: 21, nameID: "thon_buri", nameTH: "ธนบุรี", checked: false),
      FilterModel(
          order: 22,
          nameID: "bangkok_noi",
          nameTH: "บางกอกน้อย",
          checked: false),
      FilterModel(
          order: 23,
          nameID: "bangkok_yai",
          nameTH: "บางกอกใหญ่",
          checked: false),
      FilterModel(
          order: 24, nameID: "bang_kapi", nameTH: "บางกะปิ", checked: false),
      FilterModel(
          order: 25,
          nameID: "bang_khun_thian",
          nameTH: "บางขุนเทียน",
          checked: false),
      FilterModel(
          order: 26, nameID: "bang_khen", nameTH: "บางเขน", checked: false),
      FilterModel(
          order: 27,
          nameID: "bang_kho_laem",
          nameTH: "บางคอแหลม",
          checked: false),
      FilterModel(
          order: 28, nameID: "bang_kae", nameTH: "บางแค", checked: false),
      FilterModel(
          order: 29, nameID: "bang_sue", nameTH: "บางซื่อ", checked: false),
      FilterModel(
          order: 30, nameID: "bang_na", nameTH: "บางนา", checked: false),
      FilterModel(
          order: 31, nameID: "bang_bon", nameTH: "บางบอน", checked: false),
      FilterModel(
          order: 32, nameID: "bang_phlat", nameTH: "บางพลัด", checked: false),
      FilterModel(
          order: 33, nameID: "bang_rak", nameTH: "บางรัก", checked: false),
      FilterModel(
          order: 34, nameID: "bangyai", nameTH: "บางใหญ่", checked: false),
      FilterModel(
          order: 35, nameID: "bueng_kum", nameTH: "บึงกุ่ม", checked: false),
      FilterModel(
          order: 36, nameID: "pathum_wan", nameTH: "ปทุมวัน", checked: false),
      FilterModel(
          order: 37, nameID: "prawet", nameTH: "ประเวศ", checked: false),
      FilterModel(
          order: 38,
          nameID: "pom_prap_sattru_phai",
          nameTH: "ป้อมปราบศัตรูพ่าย",
          checked: false),
      FilterModel(
          order: 39, nameID: "phaya_thai", nameTH: "พญาไท", checked: false),
      FilterModel(
          order: 40, nameID: "phra_khanong", nameTH: "พระโขนง", checked: false),
      FilterModel(
          order: 41, nameID: "phra_nakhon", nameTH: "พระนคร", checked: false),
      FilterModel(
          order: 42,
          nameID: "phasi_charoen",
          nameTH: "ภาษีเจริญ",
          checked: false),
      FilterModel(
          order: 43, nameID: "min_buri", nameTH: "มีนบุรี", checked: false),
      FilterModel(
          order: 44, nameID: "yan_nawa", nameTH: "ยานนาวา", checked: false),
      FilterModel(
          order: 45, nameID: "ratchathewi", nameTH: "ราชเทวี", checked: false),
      FilterModel(
          order: 46,
          nameID: "rat_burana",
          nameTH: "ราษฎร์บูรณะ",
          checked: false),
      FilterModel(
          order: 47,
          nameID: "lat_krabang",
          nameTH: "ลาดกระบัง",
          checked: false),
      FilterModel(
          order: 48, nameID: "lat_phrao", nameTH: "ลาดพร้าว", checked: false),
      FilterModel(
          order: 49,
          nameID: "wang_thonglang",
          nameTH: "วังทองหลาง",
          checked: false),
      FilterModel(
          order: 50, nameID: "watthana", nameTH: "วัฒนา", checked: false),
      FilterModel(
          order: 51,
          nameID: "srinakarin",
          nameTH: "ศรีนครินทร์",
          checked: false),
      FilterModel(
          order: 52, nameID: "suan_luang", nameTH: "สวนหลวง", checked: false),
      FilterModel(
          order: 53, nameID: "saphan_sung", nameTH: "สะพานสูง", checked: false),
      FilterModel(
          order: 54,
          nameID: "samphanthawong",
          nameTH: "สัมพันธวงศ์",
          checked: false),
      FilterModel(order: 55, nameID: "sathon", nameTH: "สาทร", checked: false),
      FilterModel(
          order: 56, nameID: "sai_mai", nameTH: "สายไหม", checked: false),
      FilterModel(
          order: 57, nameID: "nong_khaem", nameTH: "หนองแขม", checked: false),
      FilterModel(
          order: 58, nameID: "nong_chok", nameTH: "หนองจอก", checked: false),
      FilterModel(
          order: 59, nameID: "lak_si", nameTH: "หลักสี่", checked: false),
      FilterModel(
          order: 60, nameID: "huai_khwang", nameTH: "ห้วยขวาง", checked: false),
      FilterModel(order: 61, nameID: "others", nameTH: "อื่นๆ", checked: false)
    ];
  }
}
