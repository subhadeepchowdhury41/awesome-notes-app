class AppRouterInfo {
  final String path;
  final String pagename;
  final String? id;

  AppRouterInfo.home() :
    path = '/',
    pagename = 'Home',
    id = null;

  AppRouterInfo.note(String this.id) :
    path = '/note/$id',
    pagename = 'Note';

  AppRouterInfo.noteCreate() :
    path = '/note/create',
    pagename = 'Create Note',
    id = null;
  
  AppRouterInfo.noteEdit(String this.id) :
    path = '/note/$id/edit',
    pagename = 'Edit Note';
  
  AppRouterInfo.login() :
    path = '/login',
    pagename = 'Login',
    id = null;
  
  AppRouterInfo.register() :
    path = '/register',
    pagename = 'Register',
    id = null;

  AppRouterInfo.profile() :
    path = '/profile',
    pagename = 'Profile',
    id = null;
  AppRouterInfo.profileEdit() :
    path = '/profile/edit',
    pagename = 'Edit Profile',
    id = null;
  
  AppRouterInfo.unknown() :
    path = '/404',
    pagename = '404',
    id = null;
  
  isHome() => path == '/';
  isNote() => path == '/note';
  isLogin() => path == '/login';
  isRegister() => path == '/register';
  isProfile() => path == '/profile';
  isProfileEdit() => path == '/profile/edit';
  isNoteCreate() => path.contains('/note/') && path.contains('/create');
  isNoteEdit() => path.contains('/note/') && path.contains('/edit');
  isUnknown() => path == '/404';
}