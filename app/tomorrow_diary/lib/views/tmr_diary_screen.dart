import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomorrow_diary/controllers/controllers.dart';
import 'package:tomorrow_diary/models/models.dart';
import 'package:tomorrow_diary/utils/utils.dart';
import 'package:tomorrow_diary/widgets/widgets.dart';

class TmrDiaryScreen extends StatefulWidget {
  static const pageId = '/write/tmrdiary';

  @override
  State<TmrDiaryScreen> createState() => _TmrDiaryScreenState();
}

class _TmrDiaryScreenState extends State<TmrDiaryScreen> {
  final Widget _smallGap = const SizedBox(height: TdSize.s);

  final Widget _largeGap = const SizedBox(height: TdSize.l);

  DiaryController d = Get.find();

  CalendarController c = Get.find();

  List<Wish> wishList = [];

  void _onTitleChanged(String value) {
    d.allData.value.tmrDiary?.title = value;
  }

  void _onTmrHappenChanged(String value) {
    d.allData.value.tmrDiary?.tmrHappen = value;
  }

  void _onTmrWishSubmitted(String value) {
    setState(() {
      wishList.add(Wish(wish: value, checked: false));
      d.allData.value.tmrDiary?.tmrWish = wishList;
    });
  }

  void _onTmrEmotionChanged(String value) {
    d.allData.value.tmrDiary?.tmrEmotion = value;
  }

  void _onTmrDiarySubmitted() {
    d.setPresentDataByDate(c.selectedDate);
  }

  @override
  void initState() {
    super.initState();
    wishList = d.allData.value.tmrDiary!.tmrWish!;
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: TdColor.deepGray,
      child: NestedScrollView(
        controller: ScrollController(),
        physics: const ScrollPhysics(parent: PageScrollPhysics()),
        headerSliverBuilder: (BuildContext context, bool isInnerBoxScrolled) {
          return <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(
                  height: 50,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: TdSize.m),
                      child: TextWidget.body(text: '내일의 일기'),
                    ),
                  ),
                )
              ]),
            ),
          ];
        },
        body: Obx(
          () => ListView(
            padding: const EdgeInsets.symmetric(
                vertical: TdSize.m, horizontal: TdSize.xl),
            physics: const AlwaysScrollableScrollPhysics(),
            // 이 physics를 추가 안하면 listview로 화면이 가득 차지 않을 때 버그가 남.
            controller: PrimaryScrollController.of(context),
            children: [
              // ---제목---
              SingleLineForm(
                hint: '내일의 일기 제목',
                text: d.allData.value.tmrDiary!.title!,
                onChanged: _onTitleChanged,
              ),
              _largeGap,
              // ---내일 있어야 할 일---
              const TextWidget.body(text: '내일 있어야 할 일'),
              _smallGap,
              MultiLineForm(
                  hint: '내일 있어야 할 일을 최대한 객관적으로 적어주세요',
                  text: d.allData.value.tmrDiary!.tmrHappen,
                  onChanged: _onTmrHappenChanged),
              _largeGap,
              // ---위시 리스트---
              const TextWidget.body(text: '위시리스트'),
              for (int i = 0; i < wishList.length; ++i)
                Column(
                  children: [
                    _smallGap,
                    WishWidget(
                      text: wishList[i].wish ?? '',
                      wishListState: wishList[i].checked ?? false
                          ? WishListState.checked
                          : WishListState.unchecked,
                      onTap: (checked) {
                        wishList[i].checked = checked;
                      },
                    ),
                  ],
                ),
              _smallGap,
              WishListForm(
                hint: '내일 하고 싶은 일은 무엇인가요?',
                onSubmitted: _onTmrWishSubmitted,
              ),
              _largeGap,
              // ---내일의 기분---
              const TextWidget.body(text: '내일의 기분'),
              _smallGap,
              SingleLineForm(
                hint: '내일의 기분은 어떨 것 같나요?',
                text: d.allData.value.tyDiary!.tyEmotion!,
                onChanged: _onTmrEmotionChanged,
              ),
              _largeGap,
              // ---작성 완료 버튼---
              SubmitButtonWidget(
                text: '작성 완료',
                onSubmitted: _onTmrDiarySubmitted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
