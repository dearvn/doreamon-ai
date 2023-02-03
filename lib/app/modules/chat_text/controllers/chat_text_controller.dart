import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../common/headers.dart';
import '../../../model/text_completion_model.dart';
import 'dart:convert' show utf8;

class ChatTextController extends GetxController {
  //TODO: Implement ChatTextController

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  List<TextCompletionData> messages = [];

  var state = ApiState.notFound.obs;

  getTextCompletion(String query) async {
    addMyMessage();

    state.value = ApiState.loading;

    try {
      Map<String, dynamic> rowParams = {
        "model": "text-davinci-003",
        "prompt": query,
        "temperature": 0.7,
        "max_tokens": 2049, // max-limit = 2049
        "top_p": 1,
        "best_of": 1,
        "echo": true,
      };

      final encodedParams = json.encode(rowParams);

      final response = await http.post(Uri.parse(endPoint("completions")),
          body: encodedParams, headers: headerBearerOption(OPEN_AI_KEY));

      print("Errorrrrrrrrrrrrrrr  ${response.body}");

      if (response.statusCode == 200) {
        // messages =
        //     TextCompletionModel.fromJson(json.decode(response.body)).choices;
        //

        print("${response.body}");
        var generatedArticle =
            TextCompletionModel.fromJson(json.decode(response.body)).choices[0];
        var s = utf8.decode(generatedArticle.text
            .replaceAll(RegExp(r'/(?:\r\n|\r|\n)/g'), '<br>')
            .runes
            .toList());

        //addServerMessage(
        //    TextCompletionModel.fromJson(json.decode(response.body)).choices);
        TextCompletionData text =
            TextCompletionData(text: s, index: -999999, finish_reason: "");
        messages.insert(0, text);
        state.value = ApiState.success;
      } else {
        // throw ServerException(message: "Image Generation Server Exception");
        state.value = ApiState.error;
      }
    } catch (e) {
      print("Errorrrrrrrrrrrrrrr  ");
    } finally {
      // searchTextController.clear();
      update();
    }
  }

  addServerMessage(List<TextCompletionData> choices) {
    for (int i = 0; i < choices.length; i++) {
      messages.insert(i, choices[i]);
    }
  }

  addMyMessage() {
    // {"text":":\n\nWell, there are a few things that you can do to increase","index":0,"logprobs":null,"finish_reason":"length"}
    TextCompletionData text = TextCompletionData(
        text: searchTextController.text, index: -999999, finish_reason: "");
    messages.insert(0, text);
  }

  TextEditingController searchTextController = TextEditingController();
}
