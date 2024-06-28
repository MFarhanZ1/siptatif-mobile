import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:siptatif_mobile/components/loading_dialog_component.dart';
import 'package:siptatif_mobile/services/dosen_service.dart';
import 'package:siptatif_mobile/services/penguji_service.dart';

class FormPengujiScreen extends StatefulWidget {
  const FormPengujiScreen({super.key});

  @override
  State<FormPengujiScreen> createState() => _FormPengujiScreenState();
}

class _FormPengujiScreenState extends State<FormPengujiScreen> {
  final TextEditingController _kuotaController = TextEditingController();
  final TextEditingController _kuotaControllerUpdate = TextEditingController();

  final DosenService _dosenService = DosenService();
  final PengujiService _pengujiService = PengujiService();
  List<dynamic> _dosen = [];
  dynamic _selected;

  dynamic _penguji;

  late bool _editMode = false;

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
    _kuotaController.text = "0";
    // TODO: implement initState
    super.initState();
    _resourceDosen();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        _penguji = args['penguji'];
        _editMode = args['editMode'];
        _kuotaControllerUpdate.text =
            args['penguji'] == null ? "0" : _penguji['kuota_awal'].toString();
      });
    });
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
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(left: 52.0, bottom: 17.0),
          title: Text(
            _editMode ? 'Edit Kuota Penguji' : 'Tambah Dosen Penguji',
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
                  Text(
                    _editMode ? 'Dosen penguji' : 'Pilih Dosen Penguji',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: -0.5,
                    ),
                  ),
                  _editMode
                      ? TextField(
                          decoration: InputDecoration(
                            enabled:
                                false, // Membuat TextField tidak dapat diedit
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          enabled: false,
                          controller:
                              TextEditingController(text: _penguji['nama']),
                        )
                      : DropdownButton<dynamic>(
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
                  _editMode
                      ? TextField(
                          controller: TextEditingController(
                              text: _penguji['nidn'] ??
                                  '-'), // Menggunakan TextEditingController untuk mengisi NIDN
                          decoration: InputDecoration(
                            enabled:
                                false, // Membuat TextField tidak dapat diedit
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                      : TextField(
                          controller: TextEditingController(
                              text: _selected?['nidn'] ??
                                  '-'), // Menggunakan TextEditingController untuk mengisi NIDN
                          decoration: InputDecoration(
                            enabled:
                                false, // Membuat TextField tidak dapat diedit
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
                  _editMode
                      ? Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _kuotaControllerUpdate,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onChanged: (value) {
                                  _kuotaControllerUpdate.text = value;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                border: Border.all(
                                  color: Colors.black, // Border color
                                  width: 2.0, // Border width
                                ),
                                borderRadius: BorderRadius.circular(
                                    10), // Optional: to make rounded corners
                              ),
                              width: 60,
                              child: IconButton(
                                color: Colors.red,
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (_kuotaControllerUpdate.text == "0") {
                                    return;
                                  }
                                  _kuotaControllerUpdate.text =
                                      (int.parse(_kuotaControllerUpdate.text) -
                                              1)
                                          .toString();
                                },
                              ),
                            ),
                            const SizedBox(width: 7),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                border: Border.all(
                                  color: Colors.black, // Border color
                                  width: 2.0, // Border width
                                ),
                                borderRadius: BorderRadius.circular(
                                    10), // Optional: to make rounded corners
                              ),
                              width: 60,
                              child: IconButton(
                                color: Colors.green,
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  if (_kuotaControllerUpdate.text == '0') {
                                    return;
                                  }

                                  _kuotaControllerUpdate.text =
                                      (int.parse(_kuotaControllerUpdate.text) +
                                              1)
                                          .toString();
                                },
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _kuotaController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                border: Border.all(
                                  color: Colors.black, // Border color
                                  width: 2.0, // Border width
                                ),
                                borderRadius: BorderRadius.circular(
                                    10), // Optional: to make rounded corners
                              ),
                              width: 60,
                              child: IconButton(
                                color: Colors.red,
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (_kuotaController.text == '0') {
                                    return;
                                  }

                                  _kuotaController.text =
                                      (int.parse(_kuotaController.text) - 1)
                                          .toString();
                                },
                              ),
                            ),
                            const SizedBox(width: 7),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                border: Border.all(
                                  color: Colors.black, // Border color
                                  width: 2.0, // Border width
                                ),
                                borderRadius: BorderRadius.circular(
                                    10), // Optional: to make rounded corners
                              ),
                              width: 60,
                              child: IconButton(
                                color: Colors.green,
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  _kuotaController.text =
                                      (int.parse(_kuotaController.text) + 1)
                                          .toString();
                                },
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Batal'),
                      ),
                      const SizedBox(width: 10),
                      _editMode
                          ? ElevatedButton(
                              onPressed: () {
                                showLoaderDialog(context);
                                _pengujiService.updatePenguji({
                                  "kuota": _kuotaControllerUpdate.text,
                                }, _penguji['nidn']).then((value) {
                                  if (value.data['response']) {
                                    var snackBar = SnackBar(
                                      /// need to set following properties for best effect of awesome_snackbar_content
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Berhasil diupdate!',
                                        message: "${value.data['message']}",

                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.success,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else {
                                    var snackBar = SnackBar(
                                      /// need to set following properties for best effect of awesome_snackbar_content
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Waduh, gagal mas!',
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
                              child: Text("Update"))
                          : ElevatedButton(
                              onPressed: () async {
                                showLoaderDialog(context);
                                await Future.delayed(
                                    const Duration(seconds: 1));
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
                                        title: 'Berhasil dikirim!',
                                        message: "${value.data['message']}",

                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.success,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else {
                                    var snackBar = SnackBar(
                                      /// need to set following properties for best effect of awesome_snackbar_content
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Gagal dikirim!',
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
