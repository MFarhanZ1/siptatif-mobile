import 'package:flutter/material.dart';
import 'package:siptatif_mobile/services/pembimbing_service.dart';

class MainPembimbingScreen extends StatefulWidget {
  const MainPembimbingScreen({super.key});

  @override
  State<MainPembimbingScreen> createState() => _MainPembimbingScreenState();
}

class _MainPembimbingScreenState extends State<MainPembimbingScreen> {
  final PembimbingService _pembimbingService = PembimbingService();
  List<dynamic> _pembimbingList = [];
  bool _isLoading = true;
  bool _showForm = false; // Tambahkan variabel ini

  @override
  void initState() {
    super.initState();
    _getAllPenguji(); // Panggil metode async di dalam initState
  }

  Future<void> _getAllPenguji() async {
    try {
      await _pembimbingService.getAllPenguji().then((value) {
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
                    : ListPembimbing(_pembimbingList),
                onRefresh: _getAllPenguji,
              ),
              // Tampilkan data jika sudah selesai memuat
            ),
          ] else
            ...[

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

Widget ListPembimbing(List<dynamic> pembimbingList) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: pembimbingList.length,
    itemBuilder: (BuildContext context, int index) {
      var pembimbing = pembimbingList[index];
      var ndin = pembimbing['nidn'] ?? 'N/A';
      var nama = pembimbing['nama'] ?? 'N/A';
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
                          Navigator.pushNamed(
                            context,
                            "/penguji-update-screen",
                          );
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
                                        'Apakah anda yakin ingin menghapus data dosen penguji ini?'),
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
