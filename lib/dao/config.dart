import 'package:suncloudm/dao/storage.dart';

// const host = "http://192.168.20.187:8616/cny"; //地址  李坤如
// const host = "http://192.168.1.181:32073/cny"; //地址
// const host = "http://60.204.238.185:30507/cny"; //地址
// const host = "http://192.168.20.36:8616/cny"; //地址  周家辉

const host = "https://api.smartwuxi.com/cny"; //地址

// const host = "http://192.168.20.37:8616/cny"; //地址

// const host = "http://192.168.1.126:8616/cny"; //地址
// const host = "http://43.218.117.47:8616/cny"; //地址

String? savedLanguage = GlobalStorage.getLanguage();

var loginType; //登录形态 loginType;

var isOperator = true; //账号角色

var loginUrl = "$host/login"; //发布登录地址

var cnloginUrl = "$host/cnLogin"; //单站登录地址

var appVgetAppMenuTreeersionUrl = "$host/admin/system/user/getAppMenuTree";

var editPasswordUrl = "$host/admin/system/user/editPassword";

//app版本更新
var appVersionUrl = "$host/version/newOne";

//运维班组
var workTeamListUrl = "$host/maintenance/workTeam/workTeamList";

var getWeatherUrl = "$host/micro/singleIndex/weather"; //获取天气

var getItemUrl = "$host/app/cnMonitor/getItem"; //获取项目单独

var getItemInfoUrl = "$host/app/cnMonitor/itemInfo"; //获取项目是否是灌溉，就是项目类型

//boss首页数据
var indexGeneralViewUrl = "$host/app/index/getGeneralView"; //首页数据

var indexNumUrl = "$host/energy/index/resource"; //首页数字数据

var bossHomeTopInfoUrl = "$host/energy/index/topInfo"; //首页boss总体数据

var bossHomeIncomeInfoUrl = "$host/energy/index/incomeOverview"; //首页boss收益数据

var bossHomeInvestInfoUrl = "$host/energy/index/investOverview"; //首页boss投资数据

var bossHomeDeviceListUrl =
    "$host/integratorIndex/deviceTypeDistribution"; //首页boss设备数据

var deviceModelDistributionUrl =
    "$host/integratorIndex/deviceModelDistribution"; //首页boss设备数据详情

//运营商首页
var yysIndexNumUrl = "$host/micro/resource"; //运营商首页数据

var yysHomeTopInfoUrl = "$host/micro/topInfo"; //运营商首页数据

var yysHomeIncomeInfoUrl = "$host/micro/incomeOverview"; //运营商首页数据

var yysHomeIncomeCompareUrl = "$host/micro/revenueAnalysis"; //运营商收益对比

//集成商首页数据
var jcTopNumUrl = "$host/integratorIndex/overview"; //集成商首页数据

var jcHomeTopInfoUrl = "$host/integratorIndex/top"; //集成商首页数据

var jcHomeDistributionUrl = "$host/integratorIndex/distribution"; //集成商首页分布数据

var jcHomeEfficiencyInfoUrl = "$host/integratorIndex/efficiency"; //集成商首页效率数据

//储能单站首页
var cnSingleHomeTopInfoUrl = "$host/fsIndex/fsData"; //单储能上方数据

var cnSingleHomeRunInfoUrl = "$host/fsIndex/fsRunInfo"; //单储能运行数据

var getItemPicUrlInfoUrl = "$host/app/itemInfo/getAllItem"; //单储能项目图片数据

var cnSingleHomeIncomeInfoUrl = "$host/fsIndex/overview"; //单储能收益数据

var cnSingleHomeStatusUrl = "$host/fsIndex/fsStatus"; //单储能状态数据

var cnSingleHomePowerChartUrl = "$host/fsIndex/chargeChart"; //单储能功率图数据

var cnSingleHomeEnergyChartUrl = "$host/fsIndex/chargeEnergy"; //单储能能量图数据

var cnSingleHomeIncomeChartUrl = "$host/fsIndex/overviewIncomeCurve"; //单储能收益图数据

//储能运营商数据
var cnTopNumUrl = "$host/index/cnData"; //储能运营商数据

var cnIncomeInfoUrl = "$host/index/overview"; //储能运营商收益数据

var cnPowerChartUrl = "$host/index/chargeChart"; //储能运营商功率数据

var cnEnergyChartUrl = "$host/index/chargeEnergy"; //储能运营商能量数据

var cnIncomeChartUrl = "$host/index/overviewIncomeCurve"; //储能运营商收益数据

var cnRankListUrl = "$host/index/stationViewList"; //储能运营商排名数据

//微网单站首页
var wwSingleHomeTopInfoUrl = "$host/micro/index/getTopMessage2"; //微网单站首页数据

var wwSingleHomeStationInfoUrl = "$host/micro/singleIndex/overview"; //微网单站首页数据

var wwSingleHomeRunInfoUrl = "$host/micro/index/getTopMessage"; //微网单站中间图例数据

var wwSingleHomePowerChartUrl = "$host/micro/index/loadCure"; //微网单站首页功率图表

var wwSingleHomeEnergyChartUrl = "$host/micro/index/electCure"; //微网单站首页电量图表

//光伏运营商接口
var pvTopNumUrl = "$host/gfIndex/gfData"; //光伏运营商数据

var pvStationListUrl = "$host/common/gfStationList"; //光伏运营商数据

var pvPowerEnergyChartUrl = "$host/gfIndex/chargeChart"; //光伏运营商电功率概览数据

var pvIncomeChartUrl = "$host/gfIndex/profitAndEnergyEcharts"; //光伏运营商收益概览数据

var pvRankListUrl = "$host/gfIndex/ranking"; //光伏运营商排名数据

//光伏单站接口
var pvSingleHomeTopInfoUrl =
    "$host/photovoltaic/overview2/profitAndEnergy"; //光伏单站上方数据

var pvSingleHomeStationInfoUrl =
    "$host/photovoltaic/overview2/stationInfo"; //光伏单站站点数据

var pvSingleHomeRunInfoUrl = "$host/photovoltaic/overview2/middle"; //光伏单站运行数据

var pvSingleHomePowerChartUrl = "$host/photovoltaic/overview2/ep"; //光伏单站功率图表

var pvSingleHomeEnergyChartUrl =
    "$host/photovoltaic/overview2/power"; //光伏单站能量图表

var pvSingleHomeDayFullChartUrl =
    "$host/photovoltaic/overview2/ranking"; //光伏单站日全图

var pvSingleHomeIncomeChartUrl =
    "$host/photovoltaic/overview2/profitAndEnergyEcharts"; //光伏单站收益图表

//灌溉首页
var singleTopInfoUrl = "$host/irrigate/singleIndex/topInfo"; //单灌溉上方数据

var singleCenterUrl = "$host/irrigate/singleIndex/center"; //单灌溉图标数据

var ggSinglePowerChartUrl = "$host/irrigate/singleIndex/power"; //单灌溉功率图表

var airLoopListUrl = "$host/common/airLoopList"; //单灌溉变频器

var monitorInfoUrl = "$host/template/monitorInfo"; //控制参数

var postIssueUrl = "$host/template/appIssue"; //上报问题

var insertOrUpdateUrl = "$host/irrigation/strategy/insertOrUpdate"; //新增或更新

var indexStatusInfoUrl = "$host/app/index/getStatusInfo"; //首页状态数据

var getStrategyInfoUrl = "$host/irrigation/strategy/strategyInfo"; //首页策略数据

var selectPeakUrl = "$host/irrigation/strategy/selectPeak"; //首页策略数据

var indexSYLineChart = "$host/app/index/getMicChart"; //微网-收益概览折线图

var indexPVLineChart = "$host/app/index/getPvChart"; //光伏-电量收益折线图

var indexDSYLineChart = "$host/app/index/getStorageChart"; //储能-电量收益折线图

var strategyUrl = "$host/micro/singleIndex/strategyDetail"; //策略

var strategyHistoryUrl = "$host/micro/strategy/strategyList1"; //历史策略

var priceUrl = "$host/price/listPage"; //电价

var settleListUrl = "$host/app/settleDoc/getListPage"; //结算单

var settleDetailUrl = "$host/micro/doc/micDoc"; //微网结算单信息

var cnSettleDetail = "$host/settlement/settlement"; //微网结算单信息

var cycleListUrl = "$host/incomeNew/cycleList"; //回收周期

var pvHourReportUrl = "$host/app/report/pvHourReport"; //光伏电量小时报表（app）

var storageHourReportUrl = "$host/app/report/storageHourReport"; //储能电量小时报表(app)

var micIncomeUrl = "$host/micro/income/micIncome"; //微电网收益

var cnAndPvIncomeUrl = "$host/micro/income/cnAndPvIncome"; //储能-光伏收益

var cnAppIncomeUrl = "$host/micro/income/cnAppIncome"; //储能收益

var incomeChartUrl = "$host/priceHome/basic/chart"; //收益分析图表

var incomeinfoUrl = "$host/priceHome/basic/info"; //收益概览

var incomeRadarUrl = "$host/priceHome/basic/run"; //收益分析雷达图

var singleIncomeUrl = "$host/app/income/singleIncome"; //单站储能收益分析

var operationRunUrl = "$host/app/income/operationOne"; //单站储能运行指标

var singleIncomeCurveUrl = "$host/app/income/singleIncomeCurve"; //单站储能收益分析曲线

var projectInfoUrl = "$host/app/itemInfo/getItemInfo"; //获取项目信息

var projectListUrl = "$host/common/getItem"; //获取项目列表

//光伏
var pvStationInfo = "$host/app/cnMonitor/stationInfo"; //获取光伏项目信息

var pvInverterEp = "$host/inverter/epInfo"; //逆变器曲线功率

var pvInverterPower = "$host/inverter/powerInfo"; //逆变器曲线功率

var nbqList = "$host/app/cnMonitor/getNbqList"; //逆变器列表

var getycListUrl = "$host/app/inverter/ycList"; //遥测列表

var getDetailNbqUrl = "$host/app/inverter/detailData"; //逆变器曲线

var epChartAls = "$host/photovoltaic/app/ep"; //企业用电曲线

var uiChartAls =
    "$host/photovoltaic/history/stringInverterEchartsInfo"; //组串-功率、电流、电压 (曲线图)

var dwChartAls = "$host/historyChart/gridFactorCurve"; //电网功率因素曲线

var inverterList = "$host/inverter/list"; //逆变器下拉

var commonDropList = "$host/common/airLoopList"; //通用下拉

//告警
var alarmHistoryList = "$host/app/alarm/alarmHistory"; //历史告警

var todayCount = "$host/app/alarm/getTodayCount"; //今日告警

var alarmStationList = "$host/common/stationList"; //告警站点列表

var deviceClassifyList = "$host/synthesis/deviceClassify"; //设备类型

var deviceModeList = "$host/synthesis/modeList"; //设备型号

var deviceList = "$host/synthesis/deviceList"; //设备型号

var fieldList = "$host/synthesis/fieldList"; //设备指标

var alarmList = "$host/app/alarm/alarmList"; //实时告警

//电表
var meterInfo = "$host/electricity/meterInfo"; //电表数据

var eleQuantityCure = "$host/electricity/eleQuantityCure"; //电量

var eleLoadCure = "$host/electricity/eleLoadCure"; //功率

var reactivePowerCure = "$host/electricity/reactivePowerCure"; //功率

var powerFactorCure = "$host/electricity/powerFactorCure"; //功率因素

var eleCurrentCure = "$host/electricity/eleCurrentCure"; //电流

var voltageCure = "$host/electricity/voltageCure"; //电压

//储能检测
var cnMonitorTabListUrl = "$host/app/cnMonitor/tabList"; //tab选项

var cnOverviewHomepageUrl = "$host/app/cnMonitor/cnOverviewHomepage"; //总览页面

var cnEpListUrl = "$host/app/cnMonitor/cnEpList"; //储能监控功率

var cnChargeListUrl = "$host/app/cnMonitor/cnChargeList"; //储能监控电量

var tabDataSelectListUrl = "$host/app/cnMonitor/tabDataSelectList"; //运行数据--下拉列表

var getTabDownDataUrl = "$host/app/cnMonitor/getTabDownData"; //运行状态

var getTabUpDataUrl = "$host/app/cnMonitor/getTabUpData"; //运行数据

var getDXdataUrl = "$host/app/cnMonitor/cellData"; //电芯图表数据

var changeRecordUrl = "$host/app/cnMonitor/changeRecord"; //状态详情

//运维
var oplHomeInfoUrl = "$host/maintenance/index/personnel"; //运维首页

var oplGroupListUrl = "$host/maintenance/common/getGroupByUserId"; //运维班组列表

var workOrderListUrl = "$host/maintenance/workOrder/workOrderList"; //工单列表

//告警消息列表
var alarmListUrl = "$host/alarm/alarmNewData";

var getdetailsByWorkNumberUrl =
    "$host/maintenance/workOrder/detailsByWorkNumber"; //工单详情

var getworkEventListUrl = "$host/maintenance/workEvent/workEventList"; //工单流转详情

var saveWorkEventUrl = "$host/maintenance/workEvent/saveWorkEvent"; //工单流转

var getTeamMemberListUrl =
    "$host/maintenance/workTeam/selectUserById"; //获取班组人员列表

//获取工作类型列表
var getWorkTypeListUrl = "$host/maintenance/type/list"; //获取工作类型列表

var getGroupMemberListUrl = "$host/maintenance/user/list"; //获取班组人员列表

var getGroupListUrl = "$host/maintenance/common/groupList"; //获取班组列表

var getTeamListUrl = "$host/maintenance/common/teamList"; //获取团队列表

//获取站点运维信息列表
var selectStationByIdUrl = "$host/maintenance/workTeam/selectStationById";

var getWorkScheduleUrl = "$host/maintenance/calendar/staffView"; //获取工作列表

var getWorkSummaryUrl = "$host/maintenance/index/workSummary2"; //获取工单汇总

var getAcceptStatisticsUrl =
    "$host/maintenance/index/acceptStatistics"; //获取单量统计

var getWorkRankUrl = "$host/maintenance/index/countRank"; //获取工作列表排名

//修改工单
var updateWorkOrderUrl = "$host/maintenance/workOrder/updateWorkOrder";

//工单消息列表
var workNotificationListUrl = "$host/workNotification/notificationList";

//上传文件
var fileUploadUrl = "$host/file/fileUpload";
