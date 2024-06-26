import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:siptatif_mobile/services/mahasiswa_service.dart';

class MainMahasiswaScreen extends StatefulWidget {
  const MainMahasiswaScreen({super.key});

  @override
  State<MainMahasiswaScreen> createState() => _MainMahasiswaScreenState();
}

class _MainMahasiswaScreenState extends State<MainMahasiswaScreen> {
  List<String> statusList = ['MENUNGGU', 'SETUJU', 'DITOLAK', ''];
  int statusIndex = 0;

  var searchField = '';
  final _mahasiswaService = MahasiswaService();
  late List mahasiswaData = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMahasiswaData();
  }

  Future<void> fetchMahasiswaData({searchs = '', statuses = ''}) async {
    setState(() {
      isLoading = true;
    });
    _mahasiswaService
        .getTugasAkhir(
            search: searchs == '' ? searchField : searchs,
            status: statuses == '' ? statusList[statusIndex] : statuses)
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.data['response']) {
        setState(() {
          mahasiswaData = value.data['results'] ?? [];
        });
      } else {
        setState(() {
          mahasiswaData = [];
        });
      }
    });
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
            "Waduh mas, datanya kagak ada nih, belom ada list tugas akhir nya mas...",
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 3,
        ),
        ElevatedButton(
            onPressed: () => {fetchMahasiswaData()},
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 12)),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )
              ),
              backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 251, 224, 255)),
              elevation: WidgetStateProperty.all(0.0),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, color: Colors.black,),
                SizedBox(
                  width: 4,
                ),
                Text('Tap to Refresh', style: TextStyle(
                  color: Colors.black
                ),),
              ],
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchMahasiswaData,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 10.0),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (search) => {
                          searchField = search,
                          fetchMahasiswaData(searchs: search),
                        },
                        style: const TextStyle(height: 1),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          hintText: 'Cari berdasar nim, nama, dan judul ta...',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              const Color.fromARGB(255, 173, 195, 255)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  width: 1,
                                )),
                          ),
                        ),
                        onPressed: () {
                          statusIndex = (statusIndex + 1) % statusList.length;
                          String currentStatus = statusList[statusIndex];

                          ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            content: Text(
                                "Filter TA berdasarkan status: ${capitalizeFirstLetterOfEachWord(currentStatus == '' ? 'Semua Data' : currentStatus)}"),
                          ));

                          fetchMahasiswaData(
                              searchs: searchField, statuses: currentStatus);
                        },
                        icon: const Icon(
                          Icons.filter_alt,
                          size: 30,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 8,
                )
              ],
            ),
            Expanded(
              child: isLoading
                  ? Center(
                      child: LoadingAnimationWidget.discreteCircle(
                        color: const Color.fromARGB(255, 241, 199, 93),
                        size: 60,
                      ),
                    )
                  : (mahasiswaData.isEmpty
                      ? _notFound()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 0),
                          itemCount: mahasiswaData.length,
                          itemBuilder: (context, index) {
                            final mhs = mahasiswaData[index];
                            return _templateMhsCard(mhs);
                          },
                        )),
            ),
          ],
        ),
      ),
    );
  }

  Color? _warnaStatusCard(String status, {int shade = 50}) {
    if (status == "SETUJU") {
      return Colors.green[shade];
    } else if (status == "DITOLAK") {
      return Colors.red[shade];
    }
    return Colors.amber[shade];
  }

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

  String convertToJakartaTime(String isoDate) {
    // Parse the ISO 8601 date string to a DateTime object
    DateTime utcDateTime = DateTime.parse(isoDate);

    // Create a Jakarta time zone offset
    Duration jakartaOffset = const Duration(hours: 7);
    DateTime jakartaDateTime = utcDateTime.toUtc().add(jakartaOffset);

    // Format the Jakarta DateTime object to the desired format
    DateFormat dateFormatter =
        DateFormat('d MMMM, yyyy (HH:mm \'WIB\')', 'en_US');
    String formattedDate = dateFormatter.format(jakartaDateTime);

    return formattedDate;
  }

  Card _templateMhsCard(Map<String, dynamic> mhs) {
    return Card(
      elevation: 0,
      color: _warnaStatusCard(mhs['status']),
      margin: const EdgeInsets.symmetric(vertical: 7),
      child: Padding(
        padding: const EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final dataPoint in [
              _generateRowDataPoint(Icons.calendar_month_rounded,
                  convertToJakartaTime(mhs['timestamp'])),
              _generateRowDataPoint(Icons.account_circle_rounded,
                  capitalizeFirstLetterOfEachWord(mhs['nama_mahasiswa'])),
              _generateRowDataPoint(
                  Icons.calendar_view_day_rounded, mhs['nim']),
              const SizedBox(height: 4),
              const Divider(
                height: 1,
                color: Colors.black,
                thickness: 0.8,
              ),
              const SizedBox(height: 4),
              Text('"${mhs['judul_ta']}" [${mhs['no_reg_ta']}]',
                  textAlign: TextAlign.start),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _warnaStatusCard(mhs['status'], shade: 200),
                    ),
                    child: Text(
                      capitalizeFirstLetterOfEachWord(mhs['status']) == 'Setuju'
                          ? 'Disetujui'
                          : capitalizeFirstLetterOfEachWord(mhs['status']),
                      style: const TextStyle(
                        fontFamily: "Montserrat-SemiBold",
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 241, 199, 93)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/form-mahasiswa",
                        arguments: mhs,
                      ).then((value) => {
                            fetchMahasiswaData(),
                          });
                    },
                    icon: const Icon(Icons.remove_red_eye_rounded),
                  ),
                ],
              )
            ])
              dataPoint
          ],
        ),
      ),
    );
  }

  Row _generateRowDataPoint(IconData icon, String label) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        )
      ],
    );
  }
}
