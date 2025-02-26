import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});

 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'PDF Video Oluşturucu',
     theme: ThemeData(
       colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
       useMaterial3: true,
     ),
     home: const HomePage(),
   );
 }
}

class HomePage extends StatefulWidget {
 const HomePage({super.key});

 @override
 State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 String? selectedPdfPath;
 String extractedText = '';
 String summarizedText = '';
 bool isProcessing = false;
 FlutterTts flutterTts = FlutterTts();
 bool isSpeaking = false;

 @override
 void initState() {
   super.initState();
   initTTS();
 }

 Future<void> initTTS() async {
   await flutterTts.setLanguage("tr-TR");
   await flutterTts.setPitch(1.0);
   await flutterTts.setSpeechRate(0.5);
   await flutterTts.setVolume(1.0);
 }

 Future<void> speakText(String text) async {
   if (isSpeaking) {
     await flutterTts.stop();
     setState(() {
       isSpeaking = false;
     });
   } else {
     setState(() {
       isSpeaking = true;
     });
     await flutterTts.speak(text);
     setState(() {
       isSpeaking = false;
     });
   }
 }

 @override
 void dispose() {
   flutterTts.stop();
   super.dispose();
 }

 Future<String> extractTextFromPDF(String filePath) async {
   try {
     print("PDF okuma başlıyor: $filePath");

     final File file = File(filePath);
     final bytes = await file.readAsBytes();
     print("Dosya bytes olarak okundu: ${bytes.length} bytes");

     final PdfDocument document = PdfDocument(inputBytes: bytes);
     print("PDF dokümanı yüklendi. Sayfa sayısı: ${document.pages.count}");

     String extractedText = '';
     
     for (int i = 0; i < document.pages.count; i++) {
       print("Sayfa ${i + 1} işleniyor");
       final PdfTextExtractor extractor = PdfTextExtractor(document);
       final String pageText = extractor.extractText(startPageIndex: i);
       extractedText += pageText;
       extractedText += '\n\n';
       print("Sayfa ${i + 1} metni çıkarıldı: ${pageText.length} karakter");
     }
     
     document.dispose();
     print("Metin çıkarma tamamlandı. Toplam: ${extractedText.length} karakter");

     return extractedText;
   } catch (e) {
     print('PDF okuma hatası: $e');
     return 'PDF okuma sırasında hata oluştu: $e';
   }
 }

 Future<String> summarizeText(String text) async {
   try {
     setState(() {
       isProcessing = true;
     });
     
     List<String> sentences = text.split('. ');
     List<String> summary = [];
     
     for (int i = 0; i < min(3, sentences.length); i++) {
       if (sentences[i].trim().isNotEmpty) {
         summary.add(sentences[i]);
       }
     }
     
     return summary.join('. ') + '.';
   } catch (e) {
     print('Özet oluşturma hatası: $e');
     return 'Özet oluşturulurken bir hata oluştu: $e';
   } finally {
     setState(() {
       isProcessing = false;
     });
   }
 }

 Future<void> pickPDF() async {
   try {
     FilePickerResult? result = await FilePicker.platform.pickFiles(
       type: FileType.custom,
       allowedExtensions: ['pdf'],
     );

     if (result != null) {
       setState(() {
         selectedPdfPath = result.files.single.path;
       });
       
       final text = await extractTextFromPDF(selectedPdfPath!);
       final summary = await summarizeText(text);
       
       setState(() {
         extractedText = text;
         summarizedText = summary;
       });
     }
   } catch (e) {
     print('Hata: $e');
   }
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text('PDF Video Oluşturucu'),
       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
     ),
     body: SafeArea(
       child: Padding(
         padding: const EdgeInsets.all(16.0),
         child: ListView(
           children: [
             ElevatedButton(
               onPressed: isProcessing ? null : pickPDF,
               child: const Text('PDF Dosyası Seç'),
             ),
             if (selectedPdfPath != null) ...[
               const SizedBox(height: 20),
               Text('Seçilen PDF: ${selectedPdfPath!}'),
               if (summarizedText.isNotEmpty) ...[
                 const SizedBox(height: 20),
                 const Text(
                   'Özet:',
                   style: TextStyle(
                     fontSize: 18,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 const SizedBox(height: 8),
                 Card(
                   child: Padding(
                     padding: const EdgeInsets.all(16.0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(summarizedText),
                         const SizedBox(height: 16),
                         ElevatedButton.icon(
                           onPressed: () => speakText(summarizedText),
                           icon: Icon(isSpeaking ? Icons.stop : Icons.play_arrow),
                           label: Text(isSpeaking ? 'Durdur' : 'Seslendir'),
                         ),
                       ],
                     ),
                   ),
                 ),
               ],
               if (extractedText.isNotEmpty) ...[
                 const SizedBox(height: 20),
                 const Text(
                   'Orijinal Metin:',
                   style: TextStyle(
                     fontSize: 18,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 const SizedBox(height: 8),
                 Card(
                   child: Padding(
                     padding: const EdgeInsets.all(16.0),
                     child: Text(extractedText),
                   ),
                 ),
               ],
             ],
             if (isProcessing)
               const Padding(
                 padding: EdgeInsets.all(20.0),
                 child: Center(
                   child: CircularProgressIndicator(),
                 ),
               ),
           ],
         ),
       ),
     ),
   );
 }
}

//  Future<String> summarizeText(String text) async {
//   const apiKey = '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'; // Yeni API anahtarınızı buraya ekleyin
  
//   try {
//     setState(() {
//       isProcessing = true;
//     });

//     final response = await http.post(
//       Uri.parse('https://api.openai.com/v1/chat/completions'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $apiKey', // API anahtarını düzgün formatta kullan
//       },
//       body: jsonEncode({
//         'model': 'gpt-3.5-turbo',
//         'messages': [
//           {
//             'role': 'system',
//             'content': 'Bu metni özetle ve ana noktaları çıkar. Özet Türkçe olmalı.'
//           },
//           {
//             'role': 'user',
//             'content': text
//           }
//         ],
//       }),
//     );

//     print('API Response Status: ${response.statusCode}'); // Hata ayıklama için
//     print('API Response Body: ${response.body}'); // Hata ayıklama için

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['choices'][0]['message']['content'];
//     } else {
//       throw Exception('Özet oluşturulamadı: ${response.statusCode} - ${response.body}');
//     }
//   } catch (e) {
//     print('Özet oluşturma hatası: $e');
//     return 'Özet oluşturulurken bir hata oluştu: $e';
//   } finally {
//     setState(() {
//       isProcessing = false;
//     });
//   }
// }