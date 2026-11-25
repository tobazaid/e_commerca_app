
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce_app/core/utils/app_color.dart';
import 'package:e_commerce_app/feature/auth/login/ui/login_screen.dart';
import 'package:e_commerce_app/feature/order/ui/order_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? get currentUser => auth.currentUser;

  String updatedName = '';

  @override
  void initState() {
    super.initState();
    updatedName = currentUser?.displayName ?? '';
  }

  // Edit Profile
  Future<void> editProfile() async {
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return _EditProfileDialog(
          initialName: updatedName.isNotEmpty
              ? updatedName
              : currentUser?.displayName ?? '',
        );
      },
    );

    if (!mounted || name == null || name.trim().isEmpty) {
      return;
    }

    try {
      await currentUser?.updateDisplayName(name.trim());

      if (!mounted) return;

      setState(() {
        updatedName = name.trim();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: ${e.message}'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong: $e'),
        ),
      );
    }
  }

  // Open Orders
  void openOrders() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const OrderScreen(),
      ),
    );
  }

  // Logout
  Future<void> logout() async {
    try {
      await auth.signOut();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
        ),
      );
    }
  }

  // Logout Confirmation
  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                logout();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = currentUser;

    final userName = updatedName.isNotEmpty
        ? updatedName
        : 'User Name';

    final userEmail = user?.email ?? 'No email found';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Color(0xFF003B73),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 15),

            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(
                Icons.person,
                size: 65,
                color: Color(0xFF003B73),
              ),
            ),

            const SizedBox(height: 15),

            Text(
              userName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003B73),
              ),
            ),

            const SizedBox(height: 5),

            Text(
              userEmail,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 15),

            OutlinedButton.icon(
              onPressed: editProfile,
              icon: const Icon(
                Icons.edit,
                size: 18,
              ),
              label: const Text('Edit Profile'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColor.mainColor,
                side: BorderSide(
                  color: AppColor.mainColor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 30),

            _buildProfileItem(
              icon: Icons.shopping_bag_outlined,
              title: 'My Orders',
              onTap: openOrders,
            ),

            _buildProfileItem(
              icon: Icons.location_on_outlined,
              title: 'My Addresses',
              onTap: () {},
            ),

            _buildProfileItem(
              icon: Icons.payment_outlined,
              title: 'Payment Methods',
              onTap: () {},
            ),

            _buildProfileItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {},
            ),

            _buildProfileItem(
              icon: Icons.help_outline,
              title: 'Help Center',
              onTap: () {},
            ),

            const SizedBox(height: 15),

            _buildProfileItem(
              icon: Icons.logout,
              title: 'Logout',
              iconColor: Colors.red,
              titleColor: Colors.red,
              showArrow: false,
              onTap: showLogoutDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
    bool showArrow = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        leading: Icon(
          icon,
          color: iconColor ?? AppColor.mainColor,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: titleColor ?? const Color(0xFF003B73),
          ),
        ),
        trailing: showArrow
            ? const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              )
            : null,
      ),
    );
  }
}

// Separate Dialog Widget
class _EditProfileDialog extends StatefulWidget {
  final String initialName;

  const _EditProfileDialog({
    required this.initialName,
  });

  @override
  State<_EditProfileDialog> createState() =>
      _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late final TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.initialName,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: TextField(
        controller: nameController,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          labelText: 'Your Name',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              nameController.text.trim(),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
