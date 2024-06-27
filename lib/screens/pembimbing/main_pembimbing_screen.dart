import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:siptatif_mobile/screens/pembimbing/form_pembimbing_screen.dart';
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
  dynamic _selectedDosenCallback;

  bool _isLoading = true;
  bool _showForm = false;
  bool _editMode = false;
  // Tambahkan variabel ini
  // bool _buttonUpdate = false; // Tambahkan variabel ini

  // String _inputValue = '';
  // String _inputValueKuota = '';
  // callback dari list
  void _onUpdateButtonPressed(Map<String, dynamic> item) {
    setState(() {
      _editMode = true;
    });
    Navigator.pushNamed(context, '/form-pembimbing',
        arguments: {'pembimbing': item, 'editMode': _editMode});
  }

  Future<void> _searchDataPembimbing({searchs = ''}) async {
    _pembimbingService.searchDataPembimbing(search: searchs).then((value) {
      setState(() {});
      if (value.data['response']) {
        setState(() {
          _pembimbingList = value.data['results'];
        });
      } else {
        setState(() {
          _pembimbingList = [];
        });
      }
    });
  }

  void _onDeleteButtonPressed(Map<String, dynamic> item) {
    setState(() {
      _selectedDosenCallback = item;
    });
    _pembimbingService
        .deletePembimbing(_selectedDosenCallback['nidn'])
        .then((value) {
      if (value.data['response']) {
        _searchDataPembimbing();

        var snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Berhasil!',
            message: "${value.data['message']}",

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.success,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      } else {
        var snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'hey, Kamu ngapain ?',
            message: "${value.data['message']}",

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.success,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllPembimbing(); // Panggil metode async di dalam initState
    _searchDataPembimbing();
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
        padding: const EdgeInsets.all(13.0),
        child: Column(children: [
          TextField(
            onChanged: (value) {
              _searchDataPembimbing(searchs: value);
            },
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
                  ? Center(
                      child: LoadingAnimationWidget.discreteCircle(
                        color: const Color.fromARGB(255, 241, 199, 93),
                        size: 60,
                      ),
                    )
                  : (_pembimbingList.isEmpty
                      ? _notFound()
                      : ListPembimbing(_pembimbingList, _onUpdateButtonPressed,
                          _onDeleteButtonPressed)),
              onRefresh: _getAllPembimbing,
            ),
            // Tampilkan data jika sudah selesai memuat
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _editMode = false;
          });
          Navigator.pushNamed(context, "/form-pembimbing", arguments: {
            'pembimbing': null,
            'editMode': _editMode,
          })
              .then((value) => {
                    _searchDataPembimbing(),
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

      return GestureDetector(
        onLongPress: () {
          Scaffold.of(context).showBottomSheet((context) => Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Panggil fungsi onEditButtonPressed dengan pembimbing sebagai argumen
                        onEditButtonPressed(pembimbing);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Panggil fungsi onDeleteButtonPressed dengan pembimbing sebagai argumen
                        onDeleteButtonPressed(pembimbing);
                      },
                    ),
                  ],
                ),
              ));
        },
        child: Card(
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
        ),
      );
    },
  );
}

// not found
Widget _notFound() {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.search_off_rounded,
          size: 80,
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Waduh mas, datanya kagak ada nih, coba cari pake keyword lain yak bro...",
            textAlign: TextAlign.center,
          ),
        )
      ],
    ),
  );
}
