import 'package:demo_frontend/models/note_model.dart';
import 'package:demo_frontend/providers/auth_provider.dart';
import 'package:demo_frontend/providers/notes_provider.dart';
import 'package:demo_frontend/providers/route_provider.dart';
import 'package:demo_frontend/utils/consts.dart';
import 'package:demo_frontend/views/notes/note_create.dart';
import 'package:demo_frontend/views/notes/note_screen.dart';
import 'package:demo_frontend/views/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  final _pageController = PageController();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 111, 52, 193),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page!.round();
      });
    });
    ref.read(notesProvider.notifier).setUserId(ref.read(authProvider).id);
    super.initState();
  }

  String extractText(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, ' ').trim();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 111, 52, 193),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    final notes = ref.watch(notesProvider);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: AppConstants.primaryColor,
              title: Text(
                _currentIndex == 0 ? 'Home' : 'Profile',
                style: const TextStyle(fontWeight: FontWeight.w600),
              )),
          floatingActionButton: _currentIndex == 0
              ? FloatingActionButton(
                  foregroundColor: Colors.white,
                  backgroundColor: AppConstants.primaryColor,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NoteCreateScreen()));
                  },
                  child: const Icon(Icons.add),
                )
              : null,
          bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: AppConstants.primaryColor,
              currentIndex: _currentIndex,
              onTap: (val) {
                setState(() {
                  _pageController.animateToPage(val,
                      curve: Curves.bounceInOut,
                      duration: const Duration(milliseconds: 300));
                  _currentIndex = val;
                });
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Home', tooltip: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                    tooltip: 'Profile'),
              ]),
          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/home-bg.jpg'),
              fit: BoxFit.cover,
            )),
            child: PageView(
              controller: _pageController,
              children: [
                Column(
                  mainAxisAlignment: notes.isEmpty
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(
                            AppConstants.extraSmallSpacing),
                        child: SingleChildScrollView(child: notesList(notes)))
                  ],
                ),
                ProfileScreen(
                  pageController: _pageController,
                )
              ],
            ),
          )),
    );
  }

  Widget notesList(List<Note> notes) {
    return notes.isEmpty
        ? const Center(
            child: Text('No notes found'),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(
                    bottom: AppConstants.extraSmallSpacing),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppConstants.smallBorderRadius),
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.5), width: 0.5))),
                child: ListTile(
                  onTap: () {
                    ref
                        .read(routeProvider)
                        .push(NoteScreen(id: notes[index].id!));
                  },
                  title: Text(notes[index].title!),
                  subtitle: Text(extractText(notes[index].content!)),
                ),
              );
            },
          );
  }
}
