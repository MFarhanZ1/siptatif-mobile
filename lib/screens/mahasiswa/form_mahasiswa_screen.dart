import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:siptatif_mobile/services/mahasiswa_service.dart';
import 'package:url_launcher/url_launcher.dart';

class FormMahasiswaScreen extends StatefulWidget {
  const FormMahasiswaScreen({super.key});

  @override
  State<FormMahasiswaScreen> createState() => _FormMahasiswaScreenState();
}

class _FormMahasiswaScreenState extends State<FormMahasiswaScreen> {
  final _mahasiswaService = MahasiswaService();

  String capitalizeFirstLetterOfEachWord(String input) {
    if (input.isEmpty) return input;

    // Split the input string by space to get each word
    List<String> words = input.split(' ');

    // Capitalize the first letter of each word
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    // Join the words back into a single string
    return capitalizedWords.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final mhs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.only(left: 52.0, bottom: 17.0),
          title: Text(
            'Detail TA [${mhs['no_reg_ta']}]',
            style: const TextStyle(
              fontSize: 18, // Sesuaikan ukuran font sesuai kebutuhan
            ),
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: Colors.black12, width: 1.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _mhsData('Nama: ',
                  capitalizeFirstLetterOfEachWord(mhs['nama_mahasiswa'])),
              _mhsData('NIM: ', mhs['nim']),
              _mhsData('Jenis Pendaftaran: ',
                  capitalizeFirstLetterOfEachWord(mhs['jenis_pendaftaran'])),
              _mhsData('Kategori TA: ',
                  capitalizeFirstLetterOfEachWord(mhs['kategori_ta'])),
              _mhsData('Judul Tugas Akhir: ',
                  capitalizeFirstLetterOfEachWord(mhs['judul_ta'])),
              _mhsData('Dosen Pembimbing 1: ', mhs['dosen_pembimbing1']),
              _mhsData('Dosen Pembimbing 2: ',
                  mhs['dosen_pembimbing2'] ?? '(Tidak Memilih)'),
              const SizedBox(
                height: 4,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 47,
                child: TextButton(
                  onPressed: () async {
                    final Uri url = Uri.parse(mhs['berkas']);
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 0, 0, 0)),
                    shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 9,
                      ),
                      Text(
                        'Lihat Berkas Mahasiswa',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 47,
                      child: TextButton(
                        onPressed: () {
                          _showDialogTolak(mhs['no_reg_ta']);
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              const Color.fromARGB(255, 215, 61, 61)),
                          shape: WidgetStateProperty.all(
                              const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                        ),
                        child: const Text(
                          'Tolak Deh',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 47,
                      child: TextButton(
                        onPressed: () {
                          _showDialogSetuju(mhs['no_reg_ta']);
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              const Color.fromARGB(255, 62, 167, 43)),
                          shape: WidgetStateProperty.all(
                              const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                        ),
                        child: const Text(
                          'Saya Setuju',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Column _mhsData(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
          color: const Color.fromARGB(255, 252, 255, 192),
          child: Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  final TextEditingController _catatanController = TextEditingController();
  late SnackBar snackBar;

  void _showDialogTolak(String noRegTa) {
    bool isLoading = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Kejelasan Penolakan!',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
                color: Colors.black),
          ),
          content: TextField(
            controller: _catatanController,
            decoration: const InputDecoration(
              labelText: 'Apa alasan anda menolak?',
            ),
          ),
          actions: [
            StatefulBuilder(builder: (context, setState) {
              return TextButton(
                onPressed: () async {
                  if (_catatanController.text.isEmpty) {
                    Navigator.pop(context);
                    snackBar = SnackBar(
                      /// need to set following properties for best effect of awesome_snackbar_content
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Update TA ditolak!',
                        message:
                            'Silahkan tuliskan alasan penolakan anda terlebih dahulu ya!',
                        contentType: ContentType.help,
                      ),
                    );

                    if (mounted) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                    return;
                  }

                  try {
                    setState(() {
                      isLoading = true;
                    });
                    final result = await _mahasiswaService
                        .updateTugasAkhir(noRegTa: noRegTa, data: {
                      'status': 'DITOLAK',
                      'catatan': _catatanController.text,
                      'nidn_penguji1': null,
                      'nidn_penguji2': null
                    });

                    setState(() {
                      isLoading = false;
                    });
                    // code to be executed after 2 seconds

                    snackBar = SnackBar(
                      /// need to set following properties for best effect of awesome_snackbar_content
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: result.data['response']
                            ? 'Update TA Sukses!'
                            : 'Update TA Gagal!',
                        message: result.data['message'],
                        contentType: result.data['response']
                            ? ContentType.success
                            : ContentType.failure,
                      ),
                    );

                    if (context.mounted) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                  } catch (e) {
                    print("error MAS");
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(isLoading
                      ? const Color.fromARGB(255, 255, 89, 6)
                      : const Color.fromARGB(255, 255, 129, 11)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        15), // Adjust the border radius value as needed
                  )),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isLoading ? Icons.send : Icons.telegram_outlined,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      isLoading ? 'Otw Mengirim...' : 'Kirim ke Mahasiswa',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                          color: Colors.white),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }

  void _showDialogSetuju(String noRegTa) async {
    bool isLoading = false;

    List<Map<String, dynamic>> listPenguji = [];
    String? selectedPenguji1;
    String? selectedPenguji2;

    try {
      final responseListPenguji = await _mahasiswaService.getPenguji();
      setState(() {
        listPenguji = List<Map<String, dynamic>>.from(
            responseListPenguji.data['results']);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Penetapan Penguji!',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
                color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: selectedPenguji1,
                  items: listPenguji
                      .map((penguji) => DropdownMenuItem<String>(
                            value: penguji['nidn'],
                            child: Text(
                              "[${penguji['kuota_terpakai']}/${penguji['kuota_awal']}] ${penguji['nama']}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPenguji1 = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '-- Pilih Penguji 1 --',
                  ),
                ),
                const SizedBox(height: 25),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: selectedPenguji2,
                  items: listPenguji
                      .map((penguji) => DropdownMenuItem<String>(
                            value: penguji['nidn'],
                            child: Text(
                              "[${penguji['kuota_terpakai']}/${penguji['kuota_awal']}] ${penguji['nama']}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPenguji2 = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '-- Pilih Penguji 2 --',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            StatefulBuilder(builder: (context, setState) {
              return TextButton(
                onPressed: () async {
                  if (selectedPenguji1 == null || selectedPenguji2 == null) {
                    Navigator.pop(context);
                    snackBar = SnackBar(
                      /// need to set following properties for best effect of awesome_snackbar_content
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Update TA ditolak!',
                        message:
                            'Silahkan tentukan penguji 1 dan 2 terlebih dahulu ya!',
                        contentType: ContentType.help,
                      ),
                    );

                    if (mounted) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                    return;
                  }

                  try {
                    setState(() {
                      isLoading = true;
                    });
                    final result = await _mahasiswaService
                        .updateTugasAkhir(noRegTa: noRegTa, data: {
                      'status': 'SETUJU',
                      'catatan': 'TA Berhasil di-Verifikasi!',
                      'nidn_penguji1': selectedPenguji1,
                      'nidn_penguji2': selectedPenguji2,
                    });

                    setState(() {
                      isLoading = false;
                    });
                    // code to be executed after 2 seconds

                    snackBar = SnackBar(
                      /// need to set following properties for best effect of awesome_snackbar_content
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: result.data['response']
                            ? 'Update TA Sukses!'
                            : 'Update TA Gagal!',
                        message: result.data['message'],
                        contentType: result.data['response']
                            ? ContentType.success
                            : ContentType.failure,
                      ),
                    );

                    if (context.mounted) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                  } catch (e) {
                    print("error MAS");
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(isLoading
                      ? const Color.fromARGB(255, 64, 109, 10)
                      : const Color.fromARGB(255, 90, 158, 12)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        15), // Adjust the border radius value as needed
                  )),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isLoading ? Icons.send : Icons.add_circle_outline_sharp,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      isLoading ? 'Otw Memperbarui...' : 'Update TA Mahasiswa',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                          color: Colors.white),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
