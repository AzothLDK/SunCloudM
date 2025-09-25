import 'package:suncloudm/generated/l10n.dart';

class DeviceTypeToName {
  // 创建设备类型映射表
  Map<int, String> deviceTypeMap = {
    1: 'PCS',
    2: 'BMS',
    3: S.current.Cluster,
    4: S.current.ac,
    5: '环境',
    6: '计量表',
    7: '并网表',
    9: '烟雾浓度',
    11: '用户负载表',
    12: '变压器电表',
    13: '关口表',
    14: '除湿机',
    15: S.current.Firefighting,
    18: '光伏并网表',
    19: '充电桩电表',
    20: '逆变器',
    21: 'IO',
    22: '柜内电表',
    23: '辐照仪',
    60: 'ATS',
    61: '柴发控制器',
    62: '柴发电操',
    63: '蜂鸣器',
    64: '快频设备',
    65: 'TMS',
    67: '变频器',
    68: '气象站',
    110: 'VRV空调',
  };

// 根据设备类型ID获取设备名称
  String getDeviceName(int deviceType) {
    // 如果设备类型存在于映射表中，返回对应的设备名称；否则返回默认值
    return deviceTypeMap[deviceType] ?? '未知设备';
  }
}
