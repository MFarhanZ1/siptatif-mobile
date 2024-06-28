import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:siptatif_mobile/components/loading_dialog_component.dart';
import 'package:siptatif_mobile/services/dosen_service.dart';
import 'package:siptatif_mobile/services/penguji_service.dart';

class MainPengujiScreen extends StatefulWidget {
  const MainPengujiScreen({super.key});

  @override
  State<MainPengujiScreen> createState() => _MainPengujiScreenState();
}

class _MainPengujiScreenState extends State<MainPengujiScreen> {
  final PengujiService _pengujiService = PengujiService();
  final DosenService _dataDosenService = DosenService();

  List<dynamic> _pengujiList = [];
  dynamic _selectedDosenCallback;
  bool _isLoading = false;
  bool _editMode = true;

  final TextEditingController _searchController = TextEditingController();
  Future<void> _searchDataPenguji() async {
    setState(() {
      _isLoading = true;
    });
    _pengujiService
        .searchDataPenguji(search: _searchController.text)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value.data['response']) {
        setState(() {
          _pengujiList = value.data['results'];
        });
      } else {
        setState(() {
          _pengujiList = [];
        });
      }
    });
  }

  Future<void> _getAllPenguji() async {
    try {
      setState(() {
        _isLoading = true; // Set _isLoading ke true sebelum data dimuat
      });
      await _pengujiService.getAllPenguji().then((value) {
        setState(() {
          _pengujiList = value.data['results'] ?? [];
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

  void _onUpdateButtonPressed(Map<String, dynamic> item) {
    setState(() {
      _editMode = true;
    });
    Navigator.pushNamed(context, '/form-penguji', arguments: {
      'penguji': item,
      'editMode': _editMode
    }).then((value) => {
          _searchDataPenguji(),
        });
    // setState(() {
    //   _showForm = true;
    //   _selectedDosenCallback = item;
    //   _buttonUpdate = true;
    // });
  }

  void _onDeleteButtonPressed(Map<String, dynamic> item) {
    setState(() {
      _selectedDosenCallback = item;
    });
    showLoaderDialog(context);

    _pengujiService.deletePenguji(_selectedDosenCallback['nidn']).then((value) {
      if (value.data['response']) {
        _searchDataPenguji();
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
            title: 'Gagal !',
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
    // TODO: implement initState
    super.initState();
    _searchDataPenguji();
    _getAllPenguji();
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
                _searchDataPenguji();
              },
              decoration: InputDecoration(
                  floatingLabelStyle:
                      TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  hintMaxLines: 1,
                  labelText: "Dosen Penguji",
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
                    : (_pengujiList.isEmpty
                        ? _notFound()
                        : ListPenguji(_pengujiList, _onUpdateButtonPressed,
                            _onDeleteButtonPressed)),
                onRefresh: _searchDataPenguji,
              ),
              // Tampilkan data jika sudah selesai memuat
            ),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _editMode = false;
          });
          Navigator.pushNamed(context, "/form-penguji",
                  arguments: {'penguji': null, 'editMode': _editMode})
              .then((value) => {
                    _searchDataPenguji(),
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
            "Waduh mas, datanya kagak ada nih, belom ada list penguji nya mas...",
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 3,
        ),
        ElevatedButton(
            onPressed: () => {_searchDataPenguji()},
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

Widget ListPenguji(
    List<dynamic> pengujiList,
    Function(Map<String, dynamic>) onEditButtonPressed,
    Function(Map<String, dynamic>) onDeleteButtonPressed) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: pengujiList.length,
    itemBuilder: (BuildContext context, int index) {
      var penguji = pengujiList[index];
      var ndin = penguji['nidn'] ?? '-';
      var nama = penguji['nama'] ?? '-';
      var kuota_awal = penguji['kuota_awal'] ?? 0;
      var kuota_tersisa = penguji['kuota_tersisa'] ?? 0;
      var kuota_terpakai = penguji['kuota_terpakai'] ?? 0;
      var keahlian = penguji['keahlian'] ?? 'Keahlian Belum Diisi';

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
                onPressed: (c) => onEditButtonPressed(penguji),
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
                              onDeleteButtonPressed(penguji);
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
            elevation: 0,
            color: Colors.grey[200],
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                              color: const Color.fromARGB(255, 255, 229, 152),
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
                              color: Color.fromARGB(255, 244, 174, 255),
                            ),
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
