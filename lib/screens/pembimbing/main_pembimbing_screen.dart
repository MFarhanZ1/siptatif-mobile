import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:siptatif_mobile/components/loading_dialog_component.dart';
import 'package:siptatif_mobile/services/pembimbing_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MainPembimbingScreen extends StatefulWidget {
  const MainPembimbingScreen({super.key});

  @override
  State<MainPembimbingScreen> createState() => _MainPembimbingScreenState();
}

class _MainPembimbingScreenState extends State<MainPembimbingScreen> {
  final PembimbingService _pembimbingService = PembimbingService();

  List<dynamic> _pembimbingList = [];
  dynamic _selectedDosenCallback;

  bool _isLoading = false;
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
            arguments: {'pembimbing': item, 'editMode': _editMode})
        .then((value) => {
              _searchDataPembimbing(),
            });
  }

  final TextEditingController _searchController = TextEditingController();

  Future<void> _searchDataPembimbing() async {
    setState(() {
      _isLoading = true;
    });
    _pembimbingService
        .searchDataPembimbing(search: _searchController.text)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
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

  void _onDeleteButtonPressed(Map<String, dynamic> item) async {
    setState(() {
      _selectedDosenCallback = item;
    });

    showLoaderDialog(context);
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
            title: 'Waduh, gagal mas!',
            message: "${value.data['message']}",

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }).then((value) => {
              Navigator.pop(context),
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
      setState(() {
        _isLoading = true; // Set _isLoading ke true sebelum data dimuat
      });
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
            controller: _searchController,
            onChanged: (value) {
              _searchDataPembimbing();
            },
            decoration: InputDecoration(
                floatingLabelStyle:
                    TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                hintMaxLines: 1,
                labelText: "Dosen Pembimbing",
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
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
              onRefresh: _searchDataPembimbing,
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
          }).then((value) => {
                _searchDataPembimbing(),
              });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _notFound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.search_off_rounded,
          size: 80,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Waduh mas, datanya kagak ada nih, belom ada list pembimbing nya mas...",
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 3,
        ),
        ElevatedButton(
            onPressed: () => {_searchDataPembimbing()},
            style: ButtonStyle(
              padding:
                  WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 12)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              )),
              backgroundColor:
                  WidgetStateProperty.all(Color.fromARGB(255, 251, 224, 255)),
              elevation: WidgetStateProperty.all(0.0),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.refresh,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  'Tap to Refresh',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ))
      ],
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
      var kuota_tersisa = pembimbing['kuota_tersisa'] ?? 0;
      var kuota_terpakai = pembimbing['kuota_terpakai'] ?? 0;
      var keahlian = pembimbing['keahlian'] ?? 'Keahlian Belum Diisi';

      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
        child: Slidable(
          startActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                padding: EdgeInsets.zero,
                label: 'Edit',
                onPressed: (c) => onEditButtonPressed(pembimbing),
                icon: Icons.edit,
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
              )
            ],
          ),
          endActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                padding: EdgeInsets.zero,
                onPressed: (c) => showDialog<String>(
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
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.amber[100],
                                ),
                                child: const Text(
                                  'Batalkan',
                                  style: TextStyle(
                                      color: Colors.black, letterSpacing: -0.2),
                                )),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onDeleteButtonPressed(pembimbing);
                            },
                            child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.red[100],
                                ),
                                child: const Text(
                                  'Iya, Saya Yakin',
                                  style: TextStyle(
                                      color: Colors.black, letterSpacing: -0.2),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                icon: Icons.delete,
                label: 'Hapus',
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
              )
            ],
          ),
          child: Card(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            elevation: 0,
            color: Colors.grey[200],
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
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.amber[200],
                            ),
                            child: Text(
                              "[${kuota_terpakai.toString()}/${kuota_awal.toString()}] Kuota Tersedia",
                              style: TextStyle(
                                fontFamily: "Montserrat-SemiBold",
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color.fromARGB(255, 214, 185, 255)                         ),
                            child: Text(
                              kuota_tersisa.toString() + " Kuota Tersisa",
                              style: TextStyle(
                                fontFamily: "Montserrat-SemiBold",
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

// not found
