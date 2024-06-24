import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:siptatif_mobile/services/mahasiswa_service.dart';

class MainMahasiswaScreen extends StatefulWidget {
  const MainMahasiswaScreen({super.key});

  @override
  State<MainMahasiswaScreen> createState() => _MainMahasiswaScreenState();
}

class _MainMahasiswaScreenState extends State<MainMahasiswaScreen> {
  var searchField = '';
  final _mahasiswaService = MahasiswaService();
  late List mahasiswaData = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMahasiswaData();
  }

  Future<void> fetchMahasiswaData({searchs = ''}) async {
    setState(() {
      isLoading = true;
    });
    _mahasiswaService.getTugasAkhir(search: searchs).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.data['response']) {
        setState(() {
          mahasiswaData = value.data['results'];
        });
      } else {
        setState(() {
          mahasiswaData = [];
        });
      }
    });
  }

  Widget _notFound() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80,),
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
                TextField(
                  onChanged: (search) => {
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
        padding: const EdgeInsets.all(13),
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
              Text('"${mhs['judul_ta']}" [${mhs['no_reg_ta']}]', textAlign: TextAlign.start),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _warnaStatusCard(mhs['status'], shade: 200),
                    ),
                    child: Text(
                      mhs['status'],
                      style: const TextStyle(
                        fontFamily: "Montserrat-SemiBold",
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 241, 199, 93)),
                      shape: MaterialStateProperty.all(
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
                      );
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
