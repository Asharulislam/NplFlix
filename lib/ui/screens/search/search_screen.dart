import 'package:flutter/material.dart';
import 'package:npflix/controller/search_content_controller.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/ui/widgets/error_screen.dart';
import 'package:npflix/ui/widgets/movie_item_tv.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../enums/status_enum.dart';
import '../../../utils/helper_methods.dart';
import '../../widgets/movie_item.dart';
import '../../widgets/no_internet_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextController = TextEditingController();



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchTextController.dispose();
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContent("");
    searchTextController.addListener((){
      if(searchTextController.text.length > 2){
        getContent(searchTextController.text.toString());
      }
      if(searchTextController.text.length<1){
        getContent("");
      }
    });
  }



  getContent(var text) async {
    await Provider.of<SearchContentController>(context, listen: false).searchContentList(text);
  }
  
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.profileScreenBackground,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          title:  TextHeading(text: AppLocalizations.of(context)!.search),
          iconTheme: const IconThemeData(color: Colors.white),
          //automaticallyImplyLeading: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 60.0,
              color: AppColors.appBarColor, // Matches the dark theme
              child: TextField(
                controller: searchTextController,
                decoration:   InputDecoration(
                  labelText: AppLocalizations.of(context)!.search, // Label text
                  border: InputBorder.none,
                  labelStyle: const TextStyle(
                    color: Colors.white, // Label text color
                    fontSize: 14,        // Label font size
                  ),
                  suffixIcon: Icon(
                    Icons.search, // Use email icon
                    color: AppColors.btnColor,
                    size: 26,// Icon color
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white, // Text color
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3),top:  Helper.dynamicHeight(context, 2)),
              child:  PlanTextBold(text: AppLocalizations.of(context)!.top_search_results),
            ),
            SizedBox(
              height: Helper.dynamicHeight(context, 1),
            ),
            Expanded(
              child: Container(
                color: AppColors.profileScreenBackground,
                child: Padding(
                  padding:  EdgeInsets.only(left: Helper.dynamicHeight(context, 2),right: Helper.dynamicHeight(context, 3),top:  Helper.dynamicHeight(context, 2)),
                  child: Consumer<SearchContentController>(
                    builder: (context, controller, child) {
                      if (controller.contentList.status == Status.LOADING) {
                        return SizedBox(
                            height: Helper.dynamicHeight(context, 60),
                            child: const Center( child: CircularProgressIndicator())
                        );
                      } else if (controller.contentList.status == Status.NOINTERNET) {
                        return NoInternetScreen(
                          onPressed: (){
                            getContent("");
                          },
                        );
                      }else if (controller.contentList.status == Status.ERROR) {
                        return ErrorScreen(
                          errorMessage:controller.contentList.message,
                          onRetry: (){
                            getContent("");
                          },
                        );
                      } else if (controller.contentList.status == Status.COMPLETED) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.contentList.data.length,
                            itemBuilder: (context,index){
                              return   Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context)
                                        .pushNamed(movieDetails,arguments: {
                                      "content" : controller.contentList.data[index]
                                    });
                                  },
                                  child: MovieItem(
                                      id:  controller.contentList.data[index].uuid,
                                      title: controller.contentList.data[index].title ,
                                      year: Helper.getYearFromDate(controller.contentList.data[index].releaseDate),
                                      details: controller.contentList.data[index].genre,
                                      duration:  controller.contentList.data[index].duration,
                                    isFree: controller.contentList.data[index].isContentFree ?? false,
                                  ),
                                ),
                              );
                            }
                        );
                      }
                      return Container();
                    },
                  ),

                ),
              ),
            )

          ],
        )
      ),
    );
  }
}
