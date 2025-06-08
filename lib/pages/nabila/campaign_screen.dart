import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solidaritylink_app/models/campaign_model.dart';
import 'package:http/http.dart' as http;

import '../../shared/shared_values.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  String? _selectedImage;

  late Future<List<CampaignModel>> futureCampaign;

  Future<List<CampaignModel>> fetchUserCampaign() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/api/campaigns-user'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List campaignList = data['data'];
      return campaignList.map((item) => CampaignModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat campaign: ${response.body}');
    }
  }

  Future<void> createCampaign({
    required String title,
    required String description,
    required String location,
    required String city,
    required String province,
    required BuildContext context,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/api/campaigns'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'location': location,
        'city': city,
        'province': province,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kampanye berhasil dibuat'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        futureCampaign = fetchUserCampaign();
      });

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal membuat campaign'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
      throw Exception('Gagal membuat campaign: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    futureCampaign = fetchUserCampaign();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    super.dispose();
  }

  void _showCreateCampaignForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Buat Kampanye Baru',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Judul Kampanye',
                        prefixIcon: Icon(Icons.title, color: Colors.green[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.green[200]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.green[400]!),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Judul tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi',
                        prefixIcon: Icon(
                          Icons.description,
                          color: Colors.green[400],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.green[200]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.green[400]!),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Deskripsi tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Lokasi',
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: Colors.green[400],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.green[200]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.green[400]!),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lokasi tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              labelText: 'Kota',
                              prefixIcon: Icon(
                                Icons.location_city,
                                color: Colors.green[400],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.green[200]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.green[400]!,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kota tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _provinceController,
                            decoration: InputDecoration(
                              labelText: 'Provinsi',
                              prefixIcon: Icon(
                                Icons.map,
                                color: Colors.green[400],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.green[200]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.green[400]!,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Provinsi tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 16),
                    // Container(
                    //   width: double.infinity,
                    //   height: 200,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.green[200]!),
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child:
                    //       _selectedImage != null
                    //           ? Stack(
                    //             children: [
                    //               ClipRRect(
                    //                 borderRadius: BorderRadius.circular(12),
                    //                 child: Image.network(
                    //                   _selectedImage!,
                    //                   width: double.infinity,
                    //                   height: 200,
                    //                   fit: BoxFit.cover,
                    //                 ),
                    //               ),
                    //               Positioned(
                    //                 top: 8,
                    //                 right: 8,
                    //                 child: Container(
                    //                   decoration: BoxDecoration(
                    //                     color: Colors.black.withOpacity(0.5),
                    //                     shape: BoxShape.circle,
                    //                   ),
                    //                   child: IconButton(
                    //                     icon: const Icon(
                    //                       Icons.close,
                    //                       color: Colors.white,
                    //                     ),
                    //                     onPressed: () {
                    //                       setState(() {
                    //                         _selectedImage = null;
                    //                       });
                    //                     },
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           )
                    //           : Center(
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 Icon(
                    //                   Icons.add_photo_alternate,
                    //                   size: 48,
                    //                   color: Colors.green[400],
                    //                 ),
                    //                 const SizedBox(height: 8),
                    //                 Text(
                    //                   'Unggah Foto',
                    //                   style: TextStyle(
                    //                     color: Colors.green[700],
                    //                     fontSize: 16,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    // ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await createCampaign(
                              title: _titleController.text,
                              description: _descriptionController.text,
                              location: _locationController.text,
                              city: _cityController.text,
                              province: _provinceController.text,
                              context: context,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Buat Kampanye'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kampanye'),
        backgroundColor: Colors.green[400],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[400]!, Colors.green[50]!],
          ),
        ),
        child: FutureBuilder<List<CampaignModel>>(
          future: futureCampaign,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Gagal memuat data'));
            }

            final campaigns = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: campaigns.length,
              itemBuilder: (context, index) {
                final campaign = campaigns[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ClipRRect(
                      //   borderRadius: const BorderRadius.vertical(
                      //     top: Radius.circular(15),
                      //   ),
                      //   child: Image.network(
                      //     campaign.images[0],
                      //     height: 200,
                      //     width: double.infinity,
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              campaign.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              campaign.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: Colors.green[700],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${campaign.location}, ${campaign.city}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                  color: Colors.green[700],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(campaign.createdAt),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    // Implement share functionality
                                  },
                                  icon: Icon(
                                    Icons.share,
                                    color: Colors.green[700],
                                  ),
                                  label: Text(
                                    'Bagikan',
                                    style: TextStyle(color: Colors.green[700]),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Implement donate functionality
                                  },
                                  icon: const Icon(Icons.favorite),
                                  label: const Text('Donasi'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[400],
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateCampaignForm,
        backgroundColor: Colors.green[400],
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Buat Kampanye'),
      ),
    );
  }
}
