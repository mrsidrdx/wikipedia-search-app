import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SearchLoadingShimmerView extends StatelessWidget {
  const SearchLoadingShimmerView({Key? key, required this.isDarkMode})
      : super(key: key);

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDarkMode ? Colors.grey[600]! : Colors.grey[100]!;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.70,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        enabled: true,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 50.0,
                    height: 50.0,
                    color: Colors.white,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 10.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                        ),
                        Container(
                          width: double.infinity,
                          height: 8.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
