import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:siptatif_mobile/services/dosen_service.dart';
import 'package:siptatif_mobile/services/penguji_service.dart';

class FormPengujiScreen extends StatefulWidget {
  const FormPengujiScreen({super.key});

  @override
  State<FormPengujiScreen> createState() => _FormPengujiScreenState();
}

class _FormPengujiScreenState extends State<FormPengujiScreen> {
  final TextEditingController _kuotaController = TextEditingController();

  final DosenService _dosenService = DosenService();
  final PengujiService _pengujiService = PengujiService();
  List<dynamic> _dosen = [];
  dynamic _selected;

  Future<void> _resourceDosen() async {
    await _dosenService.getAllDosen().then((value) {
      setState(() {
        _dosen = value.data['results'];
        if (_dosen.isNotEmpty) {
          _selected = _dosen[0]; // Inisialisasi _selected setelah data didapat
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _resourceDosen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: const FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(left: 52.0, bottom: 17.0),
          title: Text(
            'Dosen Penguji',
            style: TextStyle(
              fontSize: 18, // Sesuaikan ukuran font sesuai kebutuhan
            ),
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: Colors.black12, width: 1.0),
        ),
      ),
      body: _dosen.isEmpty
          ? Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: const Color.fromARGB(255, 241, 199, 93),
                size: 60,
              ),
            ) // Menampilkan loading indicator saat data diambil
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Dosen Penguji',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: -0.5,
                    ),
                  ),
                  DropdownButton<dynamic>(
                    value: _selected,
                    isExpanded: true,
                    items: _dosen.map(
                      (value) {
                        return DropdownMenuItem<dynamic>(
                          child: Text(value['nama']),
                          value: value,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selected = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'NIDN Penguji',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextField(
                    controller: TextEditingController(
                        text: _selected?['nidn'] ??
                            '-'), // Menggunakan TextEditingController untuk mengisi NIDN
                    decoration: InputDecoration(
                      enabled: false, // Membuat TextField tidak dapat diedit
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Kuota Penguji',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextField(
                    controller: _kuotaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Kembali'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          _pengujiService.createPenguji({
                            "nidn": _selected?['nidn'],
                            "kuota": _kuotaController.text,
                          }).then((value) {
                            if (value.data['response']) {
                              var snackBar = SnackBar(
                                /// need to set following properties for best effect of awesome_snackbar_content
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Yeay, Data Berhasil dikirim!',
                                  message: "${value.data['message']}",

                                  /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                  contentType: ContentType.success,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);
                              Navigator.pop(context);
                            } else {
                              var snackBar = SnackBar(
                                /// need to set following properties for best effect of awesome_snackbar_content
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Aduh.., Kamu ngapain ?',
                                  message: "${value.data['message']}",

                                  /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                  contentType: ContentType.failure,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);
                              Navigator.pop(context);
                            }
                          });
                        },
                        child: const Text('Kirim'),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
