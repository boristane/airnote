import 'package:airnote/components/loading.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/note.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteView extends StatefulWidget {
  static const routeName = 'view-entry';
  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView>
    with SingleTickerProviderStateMixin {
  NoteViewModel _noteViewModel;
  AnimationController _optionsAnimationController;
  Animation<Offset> _optionsAnimation, _optionsDelayedAnimation;

  bool _isOptionOpened = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getNote();
    });
    _optionsAnimationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _optionsAnimation = Tween<Offset>(begin: Offset(100, 0), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _optionsAnimationController, curve: Curves.easeOutBack))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener(_setOptionsStatus);
  }

  _getNote() async {
    final noteViewModel = Provider.of<NoteViewModel>(context);
    if (this._noteViewModel == noteViewModel) {
      return;
    }
    this._noteViewModel = noteViewModel;
    final id = ModalRoute.of(context).settings.arguments;
    await this._noteViewModel.getCurrentNote(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NoteViewModel>(builder: (context, model, child) {
        if (model.getStatus() == ViewStatus.LOADING) {
          return AirnoteLoadingScreen();
        }
        final note = model.currentNote;
        if (note == null) {
          return AirnoteLoadingScreen();
        }
        final heroTag = "note-image-${note.id}";
        return Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: note.imageUrl,
                      imageBuilder: (context, imageProvider) => NoteHeaderImage(
                        heroTag: heroTag,
                        imageProvider: imageProvider,
                      ),
                      placeholder: (context, url) => NoteHeaderImage(
                        heroTag: heroTag,
                        imageProvider: AssetImage("assets/placeholder.jpg"),
                      ),
                      errorWidget: (context, url, error) => NoteHeaderImage(
                        heroTag: heroTag,
                        imageProvider: AssetImage("assets/placeholder.jpg"),
                      ),
                    ),
                    Positioned(
                      top: 200,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          note.title,
                          style: TextStyle(
                              color: AirnoteColors.white,
                              fontSize: 24,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 330.0,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.0),
                                topLeft: Radius.circular(20.0)),
                            boxShadow: [
                              BoxShadow(
                                color: AirnoteColors.primary.withOpacity(.4),
                                offset: Offset(0.0, -8),
                                blurRadius: 6,
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 50),
                  child: Text(
                    note.content,
                    style: TextStyle(
                        fontSize: 16,
                        height: 1.2,
                        color: AirnoteColors.text.withOpacity(0.8)),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: <Widget>[
                      InkResponse(
                        onTap: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AirnoteColors.white,
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                  color: AirnoteColors.primary.withOpacity(.5),
                                  offset: Offset(1.0, 10.0),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Icon(Icons.arrow_downward,
                              color: AirnoteColors.primary),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    _optionsAnimationController.dispose();
    super.dispose();
  }

  void _setOptionsStatus(AnimationStatus status) {
    setState(() {
      _isOptionOpened = status == AnimationStatus.forward ||
          status == AnimationStatus.completed;
    });
  }

  void _openOptions() {
    _optionsAnimationController.forward();
  }

  void _closeOptions() {
    _optionsAnimationController.reverse();
  }
}

class NoteHeaderImage extends StatelessWidget {
  final String heroTag;
  final ImageProvider imageProvider;

  NoteHeaderImage({Key key, this.heroTag, this.imageProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: imageProvider,
      child: Container(
        height: 340,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: AirnoteColors.grey,
            image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                colorFilter:
                    ColorFilter.mode(AirnoteColors.white, BlendMode.lighten))),
      ),
    );
  }
}
