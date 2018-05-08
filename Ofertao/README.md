# iOS Conversation

## News
An Android version is coming up soon! Check it out [here!](https://github.ibm.com/mbigelli/watson-chat-android)

## Summary

This app uses Watson services to create a voice-activated chatbot. Requires a Bluemix account with the following services:

- Speech-to-Text
- Conversation
- Text-to-Speech

Optionally, custom replacements for each of these services may be used by adding them in the Settings (except Speech Recognition, for now, but native iOS SR may be used). If that is the case, the app will still expect the same interface used in Watson services. Refer to the documentation for details:

- [Speech-to-Text Documentation](https://www.ibm.com/watson/developercloud/speech-to-text.html)
- [Conversation Documentation](https://www.ibm.com/watson/developercloud/conversation.html)
- [Text-to-Speech Documentation](https://www.ibm.com/watson/developercloud/text-to-speech.html)

## Speech Recognition

This module transcribes audio from the microphone in order to further process user input. By default, uses Watson Speech-to-Text. Go to Settings -> Speech Recognition to configure this module. Customizations include:

- Speech Recognition technology: Currently, only Watson Speech-to-Text and native iOS recognition are supported
- Input language (to be implemented, currently uses pt-BR)

## Orchestrator

This module understands user input in order to provide and answer. By default, uses Watson Conversation. Go to Settings -> Orchestrator to configure this module. Customizations include:

- Watson Conversation Settings. Requires service credentials. The app will expect the conversation dialog to include a conversation_start node, and will fire its response as soon as the dialog view is opened
- Custom service URL

## Voice Synthesis

This module converts text into natural-sounding speech. By default, uses Watson Text-to-Speech. Go to Settings -> Voice Synthesis to configure this module. Customizations include:

- Custom service URL.
- Language (Watson Text-to-Speech only)
