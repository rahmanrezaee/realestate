import 'package:badam/model/Image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewPage extends StatefulWidget {
  Map datain;
  ImageViewPage(this.datain);
  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  PhotoViewController cont = PhotoViewController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ImageProperty> image = widget.datain['images'];
    PageController paf = PageController(initialPage: widget.datain['selected']);
    return Scaffold(
      appBar: AppBar(
        title: Text("نمایش عکس ها ملک"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: Container(
          child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(image[index].sourceUrl),
              initialScale: PhotoViewComputedScale.contained * 1,
              heroAttributes: PhotoViewHeroAttributes(tag: image[index].id),
              controller: cont);
        },
        itemCount: image.length,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        pageController: paf,
      )),
    );
    // return Container(
    //     child: PhotoView(
    //   imageProvider: NetworkImage(widget.url)
    // ));
  }
}
