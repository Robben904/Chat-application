import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/view/videoplayerscreenurl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../utils/remoteservices.dart';

class FilePreviewUrl extends StatefulWidget {
  FilePreviewUrl({
    Key? key,
    required this.file,
  }) : super(key: key);
  String file;

  @override
  State<FilePreviewUrl> createState() => _FilePreviewUrlState();
}

class _FilePreviewUrlState extends State<FilePreviewUrl> {
  @override
  Widget build(BuildContext context) {
    return getFilePreview(
      RemoteServices.initialUrl + "/chats/files/" + widget.file,
    );
  }

  // /file/foldernam/a.jpg

  Widget getFilePreview(String file) {
    String path = file;
    if (path.isImageFileName) {
      return Image.network(file);
    } else if (path.isVideoFileName) {
      return VideoPlayerScreenUrl(file: file);
    } else if (path.isPDFFileName) {
      return SfPdfViewer.network(file);
    } else {
      return SizedBox(
        height: 100,
        width: Get.width,
        child: Row(
          children: [Icon(Icons.file_open_rounded), Text(path.split('/').last)],
        ),
      );
    }
  }
}
