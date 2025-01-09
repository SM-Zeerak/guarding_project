import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';

class DownloadPdf {
  Future<void> requestPermissions() async {
    PermissionStatus status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      print("Permission granted.");
    } else {
      print("Permission denied.");
    }
  }

  Future<void> downloadPdf(
    BuildContext context,
    String assetPath,
    String filename,
    ValueNotifier<double> progressNotifier,
    ValueNotifier<bool> isDownloadingNotifier,
    CancelToken cancelToken,
  ) async {
    await requestPermissions();

    try {
      final directory = Directory('/storage/emulated/0/Download');
      if (!directory.existsSync()) await directory.create(recursive: true);
      final filePath = '${directory.path}/$filename';
      final file = File(filePath);

      if (assetPath.startsWith('http')) {
        Dio dio = Dio();
        try {
          await dio.download(
            assetPath,
            filePath,
            cancelToken: cancelToken,
            onReceiveProgress: (received, total) {
              if (total != -1) {
                double progress = (received / total * 100);
                progressNotifier.value = progress;
              }
            },
            options: Options(
              headers: {
                HttpHeaders.acceptEncodingHeader: "identity",
              },
            ),
          );
          Fluttertoast.showToast(msg: "Downloaded $filename successfully.");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("File downloaded to: $filePath"),
              action: SnackBarAction(
                label: 'Open',
                onPressed: () => OpenFile.open(filePath),
              ),
            ),
          );
        } catch (e) {
          print("Download Error: $e");
          Fluttertoast.showToast(msg: "Failed to download file. Error: $e");
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      isDownloadingNotifier.value = false; // Reset the downloading flag after completion
    }
  }

  void cancelDownload(CancelToken cancelToken) {
    cancelToken.cancel(); // Trigger cancel
  }
}
