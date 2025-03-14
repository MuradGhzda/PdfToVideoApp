# PDF to Video App

## Overview
An innovative Flutter application that converts PDF documents into summarized, narrated videos with background visuals. This tool streamlines content consumption by transforming static PDFs into engaging multimedia experiences.

## Features
- **PDF Import**: Upload and process PDF documents directly in the app
- **AI-Powered Summarization**: Automatically extract key points and create concise summaries
- **Text-to-Speech Narration**: Convert text content to natural-sounding speech
- **Background Visual Generation**: Create relevant visuals to accompany narration
- **Video Export**: Compile all elements into a cohesive video output
- **User-Friendly Interface**: Simple and intuitive UI for seamless user experience

## Technologies Used
- **Frontend**: Flutter/Dart
- **AI Services**: OpenAI API for summarization
- **Speech Synthesis**: TTS (Text-to-Speech) integration
- **Video Processing**: FFmpeg for video composition
- **State Management**: Provider pattern
- **Storage**: Local storage and cloud options

## Project Structure
The app follows a clean architecture approach:
- `lib/screens`: UI components and screen layouts
- `lib/services`: API integrations and external service connections
- `lib/models`: Data models representing app entities
- `lib/utils`: Helper functions and utility classes
- `lib/providers`: State management components

## Installation & Setup
```bash
# Clone the repository
git clone https://github.com/MuradGhzda/PdfToVideoApp.git

# Navigate to the project directory
cd PdfToVideoApp

# Install dependencies
flutter pub get

# Run the application
flutter run
```

### API Configuration
To use the AI functionalities, you'll need to set up API keys in the `secrets.dart` file:
```dart
// Create a file named secrets.dart in the lib/utils directory
const String OPENAI_API_KEY = 'your_openai_api_key';
```

## Usage Guide
1. **Import PDF**: Tap the '+' button to import a PDF from your device
2. **Configure Options**: Set summarization level, narration voice, and visual style
3. **Generate Video**: Press 'Create Video' to begin the conversion process
4. **Preview & Export**: Review the generated video and export to your device

## Current Development Status
This project is currently in active development. Core functionalities are being implemented and refined, with a focus on improving the AI summarization and speech synthesis components.

## Future Enhancements
- Enhanced AI summarization accuracy
- Multiple language support
- Custom voice options for narration
- Advanced visual theming options
- Cloud storage integration
- Batch processing for multiple PDFs

## Contributing
Contributions are welcome! Feel free to fork the repository and submit pull requests.

## Contact
Murad Aghazada - muradagazade@icloud.com

Project Link: [https://github.com/MuradGhzda/PdfToVideoApp](https://github.com/MuradGhzda/PdfToVideoApp)
