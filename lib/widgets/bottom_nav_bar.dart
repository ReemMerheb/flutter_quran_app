import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/models/bottomnav_state.dart';


class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = Provider.of<BottomNavProvider>(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: bottomNavProvider.selectedIndex,
      onTap: (index) {
        bottomNavProvider.updateIndex(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: _buildIcon('assets/Icon1.png', 0, context),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/Icon2.png', 1, context),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/Icon3.png', 2, context),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/Icon4.png', 3, context),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon('assets/Icon5.png', 4, context),
          label: '',
        ),
      ],
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    );
  }

  Widget _buildIcon(String assetPath, int index, BuildContext context) {
    final bottomNavProvider = Provider.of<BottomNavProvider>(context);
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        bottomNavProvider.selectedIndex == index ? Colors.purple : Colors.transparent,
        BlendMode.srcATop,
      ),
      child: Image.asset(assetPath, width: 30),
    );
  }
}
