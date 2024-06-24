import 'package:flutter/material.dart';
import 'package:siptatif_mobile/services/dosen_service.dart';
import 'package:siptatif_mobile/services/pembimbing_service.dart';

class MainPembimbingScreen extends StatefulWidget {
  const MainPembimbingScreen({super.key});

  @override
  State<MainPembimbingScreen> createState() => _MainPembimbingScreenState();
}

class _MainPembimbingScreenState extends State<MainPembimbingScreen> {
  final PembimbingService _pembimbingService = PembimbingService();
  final DosenService _dataDosenService = DosenService();

  List<dynamic> _pembimbingList = [];
  List<dynamic> _dosenAllList = [];
  dynamic _selectedDosen;
  bool _loadingform = false;

  bool _isLoading = true;
  bool _showForm = false; // Tambahkan variabel ini
  bool _buttonUpdate = false; // Tambahkan variabel ini

  String _inputValue = '';
  // callback dari list
  void _onUpdateButtonPressed(Map<String, dynamic> item) {
    setState(() {
      _showForm = !_showForm;
      _selectedDosen = item;
      _buttonUpdate = !_buttonUpdate;
    });
  }

  void _onDeleteButtonPressed(Map<String, dynamic> item) {
    setState(() {
      _selectedDosen = item;
    });
    _pembimbingService.deletePembimbing(_selectedDosen['nidn']);
  }

  @override
  void initState() {
    super.initState();
    _getAllPembimbing(); // Panggil metode async di dalam initState
    getAllDataDosen();
  }

  void getAllDataDosen() async {
    try {
      await _dataDosenService.getAllDosen().then((value) {
        print(value.data['results']);
        setState(() {
          _dosenAllList = value.data['results'] ?? [];
          if (_dosenAllList.isNotEmpty) {
            _selectedDosen = _dosenAllList[0];
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getAllPembimbing() async {
    try {
      await _pembimbingService.getAllPembimbing().then((value) {
        setState(() {
          _pembimbingList = value.data['results'] ?? [];
          _isLoading = false; // Set _isLoading ke false setelah data dimuat
        });
      });
      // Lakukan pemrosesan lebih lanjut di sini sesuai kebutuhan
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false; // Set _isLoading ke false jika ada error
      });
      // Handle error sesuai kebutuhan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          if (!_showForm) ...[
            TextField(
              decoration: InputDecoration(
                  floatingLabelStyle:
                      TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  hintMaxLines: 1,
                  labelText: "Dosen Pembimbing",
                  labelStyle: TextStyle(color: Colors.black),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.red), // Contoh untuk border error
                  ),
                  fillColor: Colors.blueAccent,
                  focusColor: Colors.black,
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                  hintText: "Search"),
            ),
            Expanded(
              child: RefreshIndicator(
                child: _isLoading // Tampilkan loading jika sedang memuat data
                    ? Center(child: CircularProgressIndicator())
                    : ListPembimbing(_pembimbingList, _onUpdateButtonPressed,
                        _onDeleteButtonPressed),
                onRefresh: _getAllPembimbing,
              ),
              // Tampilkan data jika sudah selesai memuat
            ),
          ] else ...[
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Dosen Pembimbing',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (!_buttonUpdate) ...[
                        DropdownButton<dynamic>(
                          value: _selectedDosen,
                          items: _dosenAllList.map((e) {
                            return DropdownMenuItem<dynamic>(
                              value: e,
                              child: Text(e['nama']),
                            );
                          }).toList(),
                          onChanged: (dynamic? val) {
                            setState(() {
                              _selectedDosen = val;
                            });
                          },
                        ),
                      ] else ...[
                        Text(
                          'Nama',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          child: TextField(
                            controller: TextEditingController(
                                text: _selectedDosen?['nama']),
                            enabled: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              hintText: 'Nama Dosen',
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'NIDN Pembimbing',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    child: TextField(
                      controller:
                          TextEditingController(text: _selectedDosen?['nidn']),
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        hintText: 'NIDN Pembimbing',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'KUOTA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    child: TextField(
                      style: TextStyle(height: 1),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _inputValue = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        hintText: 'KUOTA Pembimbing',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showForm = false;
                          });
                        },
                        child: Text('Kembali'),
                      ),
                      const SizedBox(width: 8),
                      if (_buttonUpdate) ...[
                        ElevatedButton(
                          onPressed: () {
                            _pembimbingService.updatePembimbing(
                                {"kuota": _inputValue},
                                _selectedDosen?['nidn']);
                          },
                          child: Text('Update'),
                        ),
                      ] else ...[
                        ElevatedButton(
                          onPressed: () {
                            _loadingform = true;
                            _pembimbingService.createPembimbing({
                              "nidn": _selectedDosen?['nidn'],
                              "kuota": _inputValue
                            }).then((value) {
                              _loadingform = false;
                              print(value.data['response']);
                              if (value.data['response']) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Sukses'),
                                      content: Text('Data berhasil terkirim!'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _showForm = false;
                                              Navigator.of(context).pop();
                                            }); // Kembali ke layar sebelumnya
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text(
                                          'Terjadi kesalahan saat mengirim data'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _showForm = false;
                                              Navigator.of(context).pop();
                                            }); // Tutup dialog
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            });
                            // Handle kirim action
                          },
                          child: Text('Kirim'),
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            ),
          ],
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showForm = !_showForm;
          });
        },
        child: Icon(_showForm ? Icons.list : Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// list view dari pembimbing
Widget ListPembimbing(
    List<dynamic> pembimbingList,
    Function(Map<String, dynamic>) onEditButtonPressed,
    Function(Map<String, dynamic>) onDeleteButtonPressed) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: pembimbingList.length,
    itemBuilder: (BuildContext context, int index) {
      var pembimbing = pembimbingList[index];
      var ndin = pembimbing['nidn'] ?? '-';
      var nama = pembimbing['nama'] ?? '-';
      var kuota_awal = pembimbing['kuota_awal'] ?? 0;
      var keahlian = pembimbing['keahlian'] ?? 'Keahlian Belum Diisi';

      return Card(
        elevation: 0,
        color: Colors.grey[200],
        margin: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(children: [
                            Icon(
                              Icons.account_circle_rounded,
                              size: 15,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              nama,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ]),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_view_day_rounded,
                                size: 15,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                ndin,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.3,
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                    thickness: 0.8,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    keahlian,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.amber[200],
                        ),
                        child: Text(
                          kuota_awal.toString() + " Kuota Tersedia",
                          style: TextStyle(
                            fontFamily: "Montserrat-SemiBold",
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton.filledTonal(
                        onPressed: () {
                          onEditButtonPressed(pembimbing);
                        },
                        icon: Icon(Icons.edit_note_outlined),
                      ),
                      IconButton.filled(
                        onPressed: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                        'Apakah anda yakin ingin menghapus data dosen pembimbing ini?'),
                                    const SizedBox(height: 15),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.amber[100],
                                          ),
                                          child: const Text(
                                            'Batalkan',
                                            style: TextStyle(
                                                color: Colors.black,
                                                letterSpacing: -0.2),
                                          )),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        onDeleteButtonPressed(pembimbing);
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.red[100],
                                          ),
                                          child: const Text(
                                            'Iya, Saya Yakin',
                                            style: TextStyle(
                                                color: Colors.black,
                                                letterSpacing: -0.2),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.delete_outline_sharp),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
