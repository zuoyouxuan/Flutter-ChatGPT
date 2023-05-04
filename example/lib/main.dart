import 'dart:async';
import 'dart:math';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:example/constants.dart';
import 'package:flutter/material.dart';
import 'package:material_buttonx/materialButtonX.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TranslateScreen(),
    );
  }
}

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({Key? key}) : super(key: key);
  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  /// text controller
  final _txtWord = TextEditingController();

  late OpenAI openAI;

  Future<CTResponse?>? _translateFuture;
  void _translateEngToThai() async {
    setState(() {
      final request = CompleteText(
          prompt: translateEngToThai(word: _txtWord.text.toString()),
          maxTokens: 200,
          model: Model.textDavinci3);
      _translateFuture = openAI.onCompletion(request: request);
    });
  }

  void gpt4() async {
    final request = ChatCompleteText(messages: [
      Map.of({"role": "user", "content": 'Hello!'})
    ], maxToken: 200, model: ChatModel.gpt_4);

    await openAI.onChatCompletion(request: request);
  }

  void gpt4Stream() {
    final request = ChatCompleteText(messages: [
      Map.of({"role": "user", "content": 'Hello!'})
    ], maxToken: 200, model: ChatModel.gpt_4);

    openAI.onChatCompletionSSE(request: request).listen((it) {
      /// data
    });
  }

  @override
  void initState() {
    openAI = OpenAI.instance.build(
        token: token,
        baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 20),
            connectTimeout: const Duration(seconds: 20)),
        isLog: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /**
                 * title translate
                 */
                _titleCard(size),
                /**
                 * input card
                 * insert your text for translate to th.com
                 */
                _inputCard(size),

                /**
                 * card input translate
                 */
                _resultCard(size),
                /**
                 * button translate
                 */
                _btnTranslate()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _navigation(size),
    );
  }

  Widget _btnTranslate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: MaterialButtonX(
                message: "Translate",
                height: 40.0,
                width: 130.0,
                color: Colors.blueAccent,
                icon: Icons.translate,
                iconSize: 18.0,
                radius: 46.0,
                onClick: () => _translateEngToThai())),
      ],
    );
  }

  Widget _resultCard(Size size) {
    return FutureBuilder<CTResponse?>(
        future: _translateFuture,
        builder: (context, snapshot) {
          final text = snapshot.data?.choices.last.text;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 32.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.bottomCenter,
            width: size.width * .86,
            height: size.height * .3,
            decoration: heroCard,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    text ?? 'Loading...',
                    style: const TextStyle(color: Colors.black, fontSize: 18.0),
                  ),
                  SizedBox(
                    width: size.width,
                    child: const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Icon(
                          Icons.copy_outlined,
                          color: Colors.grey,
                          size: 22.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.delete_forever,
                            color: Colors.grey,
                            size: 22.0,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Padding _navigation(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 18.0),
      child: Container(
        width: size.width * .8,
        height: size.height * .06,
        decoration: heroNav,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.circular(50.0)),
              child: const Icon(
                Icons.translate,
                color: Colors.white,
                size: 22.0,
              ),
            ),
            const Icon(
              Icons.record_voice_over_outlined,
              color: Colors.indigoAccent,
              size: 22.0,
            ),
            const Icon(
              Icons.favorite,
              color: Colors.indigoAccent,
              size: 22.0,
            ),
            const Icon(
              Icons.person,
              color: Colors.indigoAccent,
              size: 22.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _titleCard(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32.0),
      width: size.width * .86,
      height: size.height * .08,
      decoration: heroCard,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  "https://www.clipartmax.com/png/middle/200-2009207_francais-english-italiano-english-flag-icon-flat.png",
                  fit: BoxFit.cover,
                  width: 30.0,
                  height: 30.0,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  "Eng",
                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
              ),
              Transform.rotate(
                angle: -pi / 2,
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16.0,
                  color: Colors.grey,
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(
              Icons.swap_horiz_outlined,
              color: Colors.grey,
              size: 22.0,
            ),
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/197/197452.png",
                  fit: BoxFit.cover,
                  width: 30.0,
                  height: 30.0,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  "Thai",
                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
              ),
              Transform.rotate(
                angle: -pi / 2,
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16.0,
                  color: Colors.grey,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _inputCard(Size size) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.bottomCenter,
      width: size.width * .86,
      height: size.height * .25,
      decoration: heroCard,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none),
              controller: _txtWord,
              maxLines: 6,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(
              width: size.width,
              child: const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.copy_outlined,
                    color: Colors.grey,
                    size: 22.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.record_voice_over_outlined,
                      color: Colors.grey,
                      size: 22.0,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
