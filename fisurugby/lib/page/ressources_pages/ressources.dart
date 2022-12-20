import 'package:dio/dio.dart';
import 'package:fisurugby/page/ressources_pages/widget/video_player_widget.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';


class RessourcePage extends StatefulWidget {
  const RessourcePage({Key? key}) : super(key: key);

  @override
  _RessourcePageState createState() => _RessourcePageState();
}

class _RessourcePageState extends State<RessourcePage> {
  late Future<ListResult> futureFiles;
  Map<int, double> downloadProgress = {};
  String? urlPreview;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    futureFiles = FirebaseStorage.instance.ref('/files').listAll();
    futureFiles.then((files) {
      if (files.items.isNotEmpty) {
        setPreview(0, files.items.first);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Download Files'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.blue.shade100,
              height: 300,
              child: buildPreview(),
            ),
            FutureBuilder<ListResult>(
              future: futureFiles,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final files = snapshot.data!.items;

                  return Expanded(
                    child: ListView.builder(
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        final file = files[index];
                        final isSelected = index == selectedIndex;
                        final progress = downloadProgress[index];

                        return ListTile(
                          selected: isSelected,
                          selectedTileColor: Colors.blue.shade100,
                          title: Text(
                            file.name,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: progress != null
                              ? LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.black26,
                                )
                              : null,
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.download,
                              color: Colors.black,
                            ),
                            onPressed: () => downloadFile(index, file),
                          ),
                          onTap: () => setPreview(index, file),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error occurred!'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      );

  Future setPreview(int index, Reference file) async {
    final urlFile = await file.getDownloadURL();

    setState(() {
      selectedIndex = index;
      urlPreview = urlFile;
    });
  }

  Widget buildPreview() {
    if (urlPreview != null) {
      if (urlPreview!.contains('.jpg')) {
        return Image.network(
          urlPreview!,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      } else if (urlPreview!.contains('.mp4')) {
        return VideoPlayerWidget(
          key: Key(urlPreview!),
          url: urlPreview!,
        );
      }
    }

    return const Center(child: Text('No Preview'));
  }

  Future downloadFile(int index, Reference ref) async {
    final url = await ref.getDownloadURL();

    /// Visible to User inside Photo Gallery
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/${ref.name}';
    await Dio().download(
      url,
      path,
      onReceiveProgress: (received, total) {
        double progress = received / total;

        setState(() {
          downloadProgress[index] = progress;
        });
      },
    );

    if (url.contains('.mp4')) {
      await GallerySaver.saveVideo(path, toDcim: true);
    } else if (url.contains('.jpg')) {
      await GallerySaver.saveImage(path, toDcim: true);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloaded ${ref.name}')),
    );
  }
}

