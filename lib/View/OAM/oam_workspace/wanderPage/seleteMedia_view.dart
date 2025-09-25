import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:suncloudm/View/OAM/oam_workspace/wanderPage/preview_asset_widget.dart';
import 'package:suncloudm/toolview/custom_view.dart';
import 'package:suncloudm/toolview/permissionUtil.dart';
import 'package:suncloudm/generated/l10n.dart';

import 'package:video_player/video_player.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'asset_widget_builder.dart';

class SelectFileData {
  File? file;
  int? type; // 1:image  2:video 3:audio  default:other

  SelectFileData({this.file, this.type});
}

class SelectImageVideo extends StatefulWidget {
  Function? selectBack;
  int? maxLength = 5; //最大选择数量

  SelectImageVideo({super.key, this.selectBack});

  @override
  State<SelectImageVideo> createState() => _SelectImageVideoState();
}

class _SelectImageVideoState extends State<SelectImageVideo>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<AssetEntity> _selectAssetEntityList = [];
  List<File> _backFileList = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.separated(
          itemBuilder: (context, index) {
            if (_selectAssetEntityList.length < widget.maxLength! &&
                index == _selectAssetEntityList.length) {
              return GestureDetector(
                  child: addImageVideoBtn('添加图片/视频', Colors.grey),
                  onTap: () async {
                    // Permission.storage.request();
                    await PermissionUtil.requestStoragePermission();
                    // final permission = Permission.storage;
                    // final status = await permission.status;
                    // debugPrint('>>>Status $status'); /// here it is coming as PermissionStatus.granted
                    // if (status != PermissionStatus.granted) {
                    //   await permission.request();
                    //   if(await permission.status.isGranted){
                    //   } else {
                    //     await permission.request();
                    //   }
                    //   debugPrint('>>> ${await permission.status}');
                    // }
                    // Utils().hideKeyboard(context);

                    // bool _isAuth =
                    //     await PermissionUtil.requestStoragePermission();
                    // if (!_isAuth) {
                    //   WidgetsBinding.instance.addPostFrameCallback((_) {
                    //     Future.delayed(Duration(seconds: 5), () {
                    //       Navigator.of(context).pop();
                    //     });
                    //   });
                    // }
                    _callSelectImageVideo(index);
                  });
            } else {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  GestureDetector(
                      child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),
                          child: ClipRRect(
                            //是ClipRRect，不是ClipRect
                            borderRadius: BorderRadius.circular(8),
                            child: AssetWidgetBuilder(
                                entity: _selectAssetEntityList[index],
                                isDisplayingDetail: true),
                          )),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => GestureDetector(
                            onTap: Navigator.of(context).pop,
                            child: Center(
                                child: PreviewAssetWidget(
                                    _selectAssetEntityList[index])),
                          ),
                        );
                      }),
                  GestureDetector(
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(
                            image: AssetImage('assets/deletephoto.png'
                                ''),
                            width: 20,
                            height: 20,
                            fit: BoxFit.fill,
                          )),
                      onTap: () {
                        _selectAssetEntityList.removeAt(index);
                        _backFileCall();
                      })
                ],
              );
            }
          },
          separatorBuilder: (context, index) => Container(width: 15),
          scrollDirection: Axis.horizontal,
          itemCount: _selectAssetEntityList.length < widget.maxLength!
              ? _selectAssetEntityList.length + 1
              : _selectAssetEntityList.length),
    );
  }

  _backFileCall() async {
    _backFileList.clear();
    if (widget.selectBack != null) {
      for (AssetEntity element in _selectAssetEntityList) {
        File? _file = await element.file;
        _backFileList.add(_file!);
      }
      widget.selectBack!(_backFileList);
    }
    setState(() {});
  }

  //调用图片选择器
  _callSelectImageVideo(int index) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  title: Text(S.current.take_photo_or_record),
                  onTap: () async {
                    final AssetEntity? entity =
                        await CameraPicker.pickFromCamera(
                      context,
                      pickerConfig: const CameraPickerConfig(
                        enableRecording: true,
                        resolutionPreset: ResolutionPreset.high,
                      ),
                    );
                    if (entity != null) {
                      setState(() {
                        _selectAssetEntityList.add(entity);
                        _backFileCall();
                        // _backFileList.add(entity.file)
                      });
                    }
                    Navigator.pop(context); // 关闭选择框
                  },
                ),
                ListTile(
                  title: Text(S.current.album),
                  onTap: () async {
                    List<AssetEntity> resultFileList =
                        await selectAssetEntitys();
                    if (resultFileList.isNotEmpty) {
                      print(resultFileList[0].file.toString());
                      setState(() {
                        _selectAssetEntityList.addAll(resultFileList);
                        _backFileCall();
                      });
                    }
                    Navigator.pop(context); // 关闭选择框
                  },
                ),
                // 添加更多的选项...
              ],
            ),
          );
        });
  }

  Future<List<AssetEntity>> selectAssetEntitys() async {
    Completer<List<AssetEntity>> completer = Completer<List<AssetEntity>>();
    List<AssetEntity> imageFiles = [];
    try {
      List<AssetEntity>? images = await AssetPicker.pickAssets(context);
      if (images != null && images.isNotEmpty) {
        imageFiles = images;
        completer.complete(imageFiles);
      } else {
        completer.complete([]);
      }
    } on Exception catch (e) {
      print(e);
    }
    return completer.future;
  }
}
