import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

enum ChatModel {
  gptTurbo,

  ///DEPRECATION DATE
  ///June 1st, 2023
  gptTurbo0301,
  gpt_4,

  ///DEPRECATION DATE
  ///June 1st, 2023
  gpt_4_0314,
  gpt_4_32k,

  ///DEPRECATION DATE
  ///June 1st, 2023
  gpt_4_32k_0314
}

extension ChatModelExtension on ChatModel {
  String get name {
    switch (this) {
      case ChatModel.gptTurbo0301:
        return kChatGptTurbo0301Model;
      case ChatModel.gptTurbo:
        return kChatGptTurboModel;
      case ChatModel.gpt_4:
        return kChatGpt4;
      case ChatModel.gpt_4_0314:
        return kChatGpt40314;
      case ChatModel.gpt_4_32k:
        return kChatGpt432k;
      case ChatModel.gpt_4_32k_0314:
        return kChatGpt432k0314;
      default:
        return "";
    }
  }
}

class ChatCompleteText {
  ///ID of the model to use. Currently, only gpt-3.5-turbo and
  /// gpt-3.5-turbo-0301 are supported. [model]
  ///[kChatGptTurboModel]
  ///[kChatGptTurbo0301Model]
  final ChatModel model;

  ///The messages to generate chat completions for,
  /// in the chat format. [messages]
  final List<Map<String, String>> messages;

  ///What sampling temperature to use, between 0 and
  ///2. Higher values like 0.8 will make the output more random,
  ///while lower values like 0.2 will make it more focused and deterministic.
  ///We generally recommend altering this or top_p but not both. [temperature]
  final double? temperature;

  ///An alternative to sampling with temperature, called nucleus sampling,
  /// where the model considers the results of the tokens with top_p probability
  /// mass. So 0.1 means only the tokens comprising the top 10% probability
  /// mass are considered.
  ///We generally recommend altering this or temperature but not both. [topP]
  final double? topP;

  ///How many chat completion choices to generate for each input message. [n]
  final int? n;

  ///If set, partial message deltas will be sent, like in ChatGPT.
  /// Tokens will be sent as data-only server-sent events as they become
  /// available, with the stream terminated by a data: [DONE] message. [stream]
  final bool? stream;

  ///Up to 4 sequences where the API will stop generating further tokens. [stop]
  /// ### example use it
  /// - ["You:"]
  ///Q: Who is Batman?
  ///A: Batman is a fictional comic book character.
  /// - Chat bot
  /// [" Human:", " AI:"]
  final List<String>? stop;

  ///The maximum number of tokens allowed for the generated answer. By default,
  /// the number of tokens the model can return will be (4096 - prompt tokens).
  /// [maxToken]
  final int? maxToken;

  ///Number between -2.0 and 2.0. Positive values penalize new tokens based on
  /// whether they appear in the text so far, increasing the model's likelihood
  /// to talk about new topics. [presencePenalty]
  final double? presencePenalty;

  ///Number between -2.0 and 2.0. Positive values penalize new tokens based on
  /// their existing frequency in the text so far, decreasing the model's
  /// likelihood to repeat the same line verbatim. [frequencyPenalty]
  final double? frequencyPenalty;

  ///Modify the likelihood of specified tokens appearing in the completion.
  /// Accepts a json object that maps tokens
  /// (specified by their token ID in the tokenizer) to an associated bias value
  /// from -100 to 100. Mathematically, the bias is added to the logits generated
  /// by the model prior to sampling. The exact effect will vary per model, but
  /// values between -1 and 1 should decrease or increase likelihood of selection;
  /// values like -100 or 100 should result in a ban or exclusive selection of the
  /// relevant token. [logitBias]
  //final Map<String, dynamic>? logitBias;

  ///A unique identifier representing your end-user, which can help OpenAI
  ///to monitor and detect abuse.[user]
  final String? user;

  ChatCompleteText(
      {required this.model,
      required this.messages,
      this.temperature = .3,
      this.topP = 1.0,
      this.n = 1,
      this.stream = false,
      this.stop,
      this.maxToken = 100,
      this.presencePenalty = .0,
      this.frequencyPenalty = .0,
      this.user = ""});

  Map<String, dynamic> toJson() => Map.of({
        "model": model.name,
        "messages": messages,
        "temperature": temperature,
        "top_p": topP,
        "n": n,
        "stream": stream,
        "stop": stop,
        "max_tokens": maxToken,
        "presence_penalty": presencePenalty,
        "frequency_penalty": frequencyPenalty,
        //"logit_bias": this.logitBias,
        "user": user
      });
}
