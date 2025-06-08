import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solidaritylink_app/main.dart';
import 'package:solidaritylink_app/models/user_model.dart';

import '../../services/auth_service.dart';
import '../../widgets/profile_avatar.dart';
import '../home.dart';

// Halaman profil pengguna yang memungkinkan untuk melihat dan mengedit data diri
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Variabel untuk menentukan apakah dalam mode edit
  bool _isEditing = false;

  // Kunci form untuk validasi input
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _professionController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _provinceController;
  late TextEditingController _bioController;

  // Variabel tambahan untuk dropdown dan date picker
  late String _selectedGender;
  late DateTime _selectedBirthDate;

  // Gambar profil pengguna
  String? _profileImage;

  // List menu yang akan ditampilkan pada halaman profil
  late List<Map<String, dynamic>> _menuItems;

  // Objek pengguna saat ini
  late UserModel _currentUser;

  // List untuk menyimpan data kegiatan
  final List<Map<String, dynamic>> _activities = [
    {
      'id': '1',
      'type': 'donation',
      'title': 'Donasi Bencana Banjir',
      'amount': 'Rp 500.000',
      'date': '12 Maret 2024',
      'description': 'Donasi untuk korban bencana banjir di Jakarta',
    },
    {
      'id': '2',
      'type': 'volunteer',
      'title': 'Relawan Gempa Bumi',
      'amount': '3 hari',
      'date': '5 Maret 2024',
      'description': 'Kegiatan relawan untuk korban gempa bumi di Aceh',
    },
  ];

  // final userAuth = Session().currentUser;

  @override
  void initState() {
    super.initState();

    // Ambil data user dummy sebagai data awal pengguna
    _currentUser = UserModel(
      // id: userAuth!.id,
      // name: userAuth!.name,
      // email: userAuth!.email,
      // password: 'password',
      // image: userAuth!.image,
      // profession: userAuth!.profession,
      // address: userAuth!.address,
      // city: userAuth!.city,
      // province: userAuth!.province,
      // gender: userAuth!.gender,
      // birthDate: userAuth!.birthDate,
      // bio: userAuth!.bio,
      id: 1,
      name: 'User 1',
      email: 'user1@gmail.com',
      password: 'password',
      profession: 'Mahasiswa', // Profesi user
      address: 'Jl. Contoh No. 123', // Alamat lengkap
      city: 'Jakarta', // Kota
      province: 'DKI Jakarta', // Provinsi
      gender: 'Perempuan', // Jenis kelamin
      birthDate: DateTime(2000, 1, 1), // Tanggal lahir
      bio: 'Suka membantu sesama',
    );

    // Inisialisasi controllers dengan data dari _currentUser
    _nameController = TextEditingController(text: _currentUser.name);
    _professionController = TextEditingController(
      text: _currentUser.profession,
    );
    _addressController = TextEditingController(text: _currentUser.address);
    _cityController = TextEditingController(text: _currentUser.city);
    _provinceController = TextEditingController(text: _currentUser.province);
    _bioController = TextEditingController(text: _currentUser.bio);
    _selectedGender = _currentUser.gender!;
    _selectedBirthDate = _currentUser.birthDate!;

    // Daftar menu untuk navigasi aksi pengguna seperti melihat riwayat atau tambah kegiatan
    _menuItems = [
      {
        'title': 'Riwayat Kegiatan',
        'icon': Icons.history,
        'color': Colors.blue,
        'onTap': (BuildContext context) {
          showDialog(
            context: context,
            builder:
                (BuildContext context) => AlertDialog(
                  title: Text(
                    'Riwayat Kegiatan',
                    style: TextStyle(color: Colors.green[900]),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ..._activities.map(
                          (activity) => Column(
                            children: [
                              _buildHistoryItem(
                                activity['title'],
                                activity['amount'],
                                activity['date'],
                                activity['type'] == 'donation'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 20),
                                    color: Colors.blue,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _showEditForm(context, activity);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 20),
                                    color: Colors.red,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _showDeleteConfirmation(
                                        context,
                                        activity,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Tutup',
                        style: TextStyle(color: Colors.green[700]),
                      ),
                    ),
                  ],
                ),
          );
        },
      },
      {
        'title': 'Tambah Kegiatan',
        'icon': Icons.add_circle,
        'color': Colors.green,
        'onTap': (BuildContext context) {
          showDialog(
            context: context,
            builder:
                (BuildContext context) => AlertDialog(
                  title: Text(
                    'Tambah Kegiatan',
                    style: TextStyle(color: Colors.green[900]),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          title: const Text('Donasi'),
                          onTap: () {
                            Navigator.pop(context);
                            _showDonationForm(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.volunteer_activism,
                            color: Colors.orange,
                          ),
                          title: const Text('Relawan'),
                          onTap: () {
                            Navigator.pop(context);
                            _showVolunteerForm(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Batal',
                        style: TextStyle(color: Colors.green[700]),
                      ),
                    ),
                  ],
                ),
          );
        },
      },
    ];
  }

  @override
  void dispose() {
    // Hapus controller saat widget dihapus
    _nameController.dispose();
    _professionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih tanggal lahir
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  // Fungsi untuk menampilkan modal untuk memilih gambar
  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      builder:
          (BuildContext context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Ambil Foto'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur kamera akan segera hadir'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Pilih dari Galeri'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur galeri akan segera hadir'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }

  // Fungsi untuk menampilkan profil
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.green[400],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _isEditing ? 'Edit Profil' : 'Profil',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.green[400]!, Colors.green[300]!],
                  ),
                ),
              ),
            ),
            actions: [
              if (!_isEditing)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.green[400]!, Colors.green[50]!],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Profile Image
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              ProfileAvatar(name: _currentUser.name, size: 120),
                              if (_isEditing)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.green[400],
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Profile Form or Info
                    if (_isEditing)
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildAnimatedFormField(
                              controller: _nameController,
                              label: 'Nama',
                              icon: Icons.person,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nama tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedDropdown(
                              value: _selectedGender,
                              label: 'Jenis Kelamin',
                              icon: Icons.people,
                              items: ['Laki-laki', 'Perempuan'],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedGender = value;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedDatePicker(
                              label: 'Tanggal Lahir',
                              icon: Icons.calendar_today,
                              date: _selectedBirthDate,
                              onTap: () => _selectDate(context),
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedFormField(
                              controller: _professionController,
                              label: 'Profesi',
                              icon: Icons.work,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedFormField(
                              controller: _addressController,
                              label: 'Alamat',
                              icon: Icons.home,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildAnimatedFormField(
                                    controller: _cityController,
                                    label: 'Kota',
                                    icon: Icons.location_city,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildAnimatedFormField(
                                    controller: _provinceController,
                                    label: 'Provinsi',
                                    icon: Icons.map,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedFormField(
                              controller: _bioController,
                              label: 'Bio',
                              icon: Icons.description,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildAnimatedButton(
                                    onPressed: _resetForm,
                                    label: 'Batal',
                                    isOutlined: true,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildAnimatedButton(
                                    onPressed: _saveProfile,
                                    label: 'Simpan',
                                    isOutlined: false,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _currentUser.name,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[900],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _currentUser.profession!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green[700],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildInfoRow(
                                  Icons.location_on,
                                  '${_currentUser.address}, ${_currentUser.city}, ${_currentUser.province}',
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.people,
                                  _currentUser.gender!,
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.calendar_today,
                                  '${_currentUser.birthDate!.day!}/${_currentUser.birthDate!.month}/${_currentUser.birthDate!.year}',
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _currentUser.bio!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.green[800],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 32),

                    // Menu Items
                    ..._menuItems.map((item) => _buildAnimatedMenuCard(item)),

                    const SizedBox(height: 16),

                    // Logout Button
                    _buildAnimatedLogoutButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Membuat widget untuk form
  Widget _buildAnimatedFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.green[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: validator,
      ),
    );
  }

  // Membuat widget untuk dropdown
  Widget _buildAnimatedDropdown({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.green[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items:
            items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
        onChanged: onChanged,
      ),
    );
  }

  // Fungsi untuk membangun pemilih tanggal lahir
  Widget _buildAnimatedDatePicker({
    required String label,
    required IconData icon,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.green[400]),
            const SizedBox(width: 16),
            Text(label, style: TextStyle(color: Colors.green[700])),
            const Spacer(),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: TextStyle(color: Colors.green[900]),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun tombol simpan/batal dengan animasi
  Widget _buildAnimatedButton({
    required VoidCallback onPressed,
    required String label,
    required bool isOutlined,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child:
          isOutlined
              ? OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.green[400]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(label, style: TextStyle(color: Colors.green[400])),
              )
              : ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(label),
              ),
    );
  }

  // Fungsi untuk menampilkan kartu menu
  Widget _buildAnimatedMenuCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => item['onTap'](context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item['icon'], color: item['color'], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.green[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan tombol logout dengan desain dan efek animasi
  Widget _buildAnimatedLogoutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: [Colors.red[400]!, Colors.red[300]!]),
        boxShadow: [
          BoxShadow(
            color: Colors.red[300]!.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder:
                  (BuildContext context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red[400], size: 28),
                        const SizedBox(width: 12),
                        const Text(
                          'Keluar',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    content: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Apakah Anda yakin ingin keluar dari aplikasi?',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [Colors.red[400]!, Colors.red[300]!],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove('userId');
                            await prefs.remove('name');
                            await prefs.remove('email');
                            await prefs.remove('token');

                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MainLayout(child: HomePage()),
                                ),
                                (route) => false,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Berhasil keluar dari aplikasi',
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.green[400],
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.all(8),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Keluar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Keluar dari Aplikasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Menampilkan informasi dalam bentuk baris ikon + teks (untuk gender, lokasi, dll)
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: Colors.green[700]),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: Colors.green[700], fontSize: 14)),
      ],
    );
  }

  // Menampilkan item riwayat dalam bentuk ListTile
  Widget _buildHistoryItem(
    String title,
    String amount,
    String date,
    Color color,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.history, color: color),
      ),
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(
        amount,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Menampilkan item aktivitas dalam bentuk ListTile
  void _showEditForm(BuildContext context, Map<String, dynamic> activity) {
    final titleController = TextEditingController(text: activity['title']);
    final amountController = TextEditingController(text: activity['amount']);
    final descriptionController = TextEditingController(
      text: activity['description'],
    );

    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: Text(
              'Edit ${activity['type'] == 'donation' ? 'Donasi' : 'Kegiatan Relawan'}',
              style: TextStyle(color: Colors.green[900]),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Judul',
                      prefixIcon: Icon(Icons.title, color: Colors.green[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText:
                          activity['type'] == 'donation'
                              ? 'Jumlah Donasi'
                              : 'Durasi',
                      prefixIcon: Icon(
                        activity['type'] == 'donation'
                            ? Icons.attach_money
                            : Icons.timer,
                        color: Colors.green[400],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi',
                      prefixIcon: Icon(
                        Icons.description,
                        color: Colors.green[400],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Batal',
                  style: TextStyle(color: Colors.green[700]),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      amountController.text.isNotEmpty) {
                    setState(() {
                      final index = _activities.indexWhere(
                        (a) => a['id'] == activity['id'],
                      );
                      if (index != -1) {
                        _activities[index] = {
                          ...activity,
                          'title': titleController.text,
                          'amount': amountController.text,
                          'description': descriptionController.text,
                        };
                      }
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Kegiatan berhasil diperbarui'),
                        backgroundColor: Colors.green[400],
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  // Konfirmasi penghapusan kegiatan
  void _showDeleteConfirmation(
    BuildContext context,
    Map<String, dynamic> activity,
  ) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: const Text('Hapus Kegiatan'),
            content: Text(
              'Apakah Anda yakin ingin menghapus "${activity['title']}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Batal',
                  style: TextStyle(color: Colors.green[700]),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _activities.removeWhere((a) => a['id'] == activity['id']);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Kegiatan berhasil dihapus'),
                      backgroundColor: Colors.green[400],
                    ),
                  );
                },
                child: Text('Hapus', style: TextStyle(color: Colors.red[400])),
              ),
            ],
          ),
    );
  }

  // Form tambah donasi
  void _showDonationForm(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: Text(
              'Tambah Donasi',
              style: TextStyle(color: Colors.green[900]),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Judul',
                      prefixIcon: Icon(Icons.title, color: Colors.green[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: 'Jumlah Donasi',
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: Colors.green[400],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi',
                      prefixIcon: Icon(
                        Icons.description,
                        color: Colors.green[400],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Batal',
                  style: TextStyle(color: Colors.green[700]),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      amountController.text.isNotEmpty) {
                    setState(() {
                      _activities.add({
                        'id': DateTime.now().toString(),
                        'type': 'donation',
                        'title': titleController.text,
                        'amount': 'Rp ${amountController.text}',
                        'date':
                            '${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                        'description': descriptionController.text,
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Donasi berhasil ditambahkan'),
                        backgroundColor: Colors.green[400],
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  // Form tambah relawan
  void _showVolunteerForm(BuildContext context) {
    final titleController = TextEditingController();
    final durationController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: Text(
              'Tambah Relawan',
              style: TextStyle(color: Colors.green[900]),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Judul Kegiatan',
                      prefixIcon: Icon(Icons.title, color: Colors.green[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: durationController,
                    decoration: InputDecoration(
                      labelText: 'Durasi',
                      prefixIcon: Icon(Icons.timer, color: Colors.green[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi',
                      prefixIcon: Icon(
                        Icons.description,
                        color: Colors.green[400],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Batal',
                  style: TextStyle(color: Colors.green[700]),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      durationController.text.isNotEmpty) {
                    setState(() {
                      _activities.add({
                        'id': DateTime.now().toString(),
                        'type': 'volunteer',
                        'title': titleController.text,
                        'amount': '${durationController.text} hari',
                        'date':
                            '${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                        'description': descriptionController.text,
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Kegiatan relawan berhasil ditambahkan',
                        ),
                        backgroundColor: Colors.green[400],
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  // Mendapatkan nama bulan dari angka bulan
  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  // Fungsi untuk menyimpan perubahan profil
  void _saveProfile() {
    // Validasi form sebelum menyimpan
    if (_formKey.currentState!.validate()) {
      setState(() {
        // Perbarui data pengguna (_currentUser) dengan data dari input form
        _currentUser = UserModel(
          id: _currentUser.id,
          name: _nameController.text, //Nama baru dari form
          email: _currentUser.email, //Email tetap
          password: 'password',
          image:
              _profileImage ??
              _currentUser.image, //Jika gambar dipilih, gunakan yang baru
          profession: _professionController.text, //Profesi baru dari form
          address: _addressController.text, //Alamat baru dari form
          city: _cityController.text, //Kota baru dari form
          province: _provinceController.text, //Provinsi baru dari form
          gender: _selectedGender, //Jenis kelamin baru dari form
          birthDate: _selectedBirthDate, //Tanggal lahir baru dari form
          bio: _bioController.text, //Deskripsi baru dari form
        );
        _isEditing = false; // Kembali ke mode non-edit
      });

      // Tampilkan pesan bahwa profil berhasil diperbarui
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profil berhasil diperbarui'), // Pesan
          backgroundColor: Colors.green[400], // Warna latar belakang
        ),
      );
    }
  }

  // Fungsi untuk membatalkan pengeditan dan mengembalikan form ke data awal
  void _resetForm() {
    setState(() {
      _isEditing = false; // Kembali ke mode non-edit

      // Mengembalikan data pengguna ke data awal
      _nameController.text = _currentUser.name;
      _professionController.text = _currentUser.profession!;
      _addressController.text = _currentUser.address!;
      _cityController.text = _currentUser.city!;
      _provinceController.text = _currentUser.province!;
      _bioController.text = _currentUser.bio!;
      _selectedGender = _currentUser.gender!;
      _selectedBirthDate = _currentUser.birthDate!;
    });
  }
}
