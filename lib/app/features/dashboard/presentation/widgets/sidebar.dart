import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rockers_admin/app/core/routes/routes.dart';
import 'package:rockers_admin/app/core/theme/theme.dart';
import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late String currentSubRoute;

  @override
  void initState() {
    super.initState();
    currentSubRoute = Routes.songsBoard;
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo-only-guitar-white.png',
            height: 40.0,
            width: 40.0,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Rockers',
                style: heading2Style,
              ),
              Text(
                'Admin',
                style: captionStyle,
              ),
            ],
          )
        ],
      ),
    );
  }

  List<Widget> _menuDivider() {
    return <Widget>[
      const SizedBox(
        height: 10.0,
      ),
      const Divider(
        indent: 30.0,
        endIndent: 30.0,
      ),
      const SizedBox(
        height: 10.0,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.0,
      child: ListView(
        children: [
          _header(),
          ..._menuDivider(),
          MenuItem(
            text: 'Songs',
            icon: Icons.album_outlined,
            isActive: currentSubRoute == Routes.songsBoard,
            onPressed: () {
              setState(() {
                currentSubRoute = Routes.songsBoard;
              });
              context.go(Routes.songsBoard);
            },
          ),
          ..._menuDivider(),
          MenuItem(
            text: 'Trending',
            icon: Icons.local_fire_department_outlined,
            isActive: currentSubRoute == Routes.trendingBoard,
            onPressed: () {
              setState(() {
                currentSubRoute = Routes.trendingBoard;
              });
              context.go(Routes.trendingBoard);
            },
          ),
          MenuItem(
            text: 'Playlists',
            icon: Icons.queue_music_outlined,
            isActive: currentSubRoute == Routes.playlistsBoard,
            onPressed: () {
              setState(() {
                currentSubRoute = Routes.playlistsBoard;
              });
              context.go(Routes.playlistsBoard);
            },
          ),
        ],
      ),
    );
  }
}
