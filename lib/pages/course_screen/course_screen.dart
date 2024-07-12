import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> courses = [];
  InAppWebViewController? _webViewController;
  bool showPage = false;

  void showCustomSnackbarLong(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 20,
      backgroundColor: Theme.of(context).canvasColor,
      textColor: Theme.of(context).primaryColor,
      fontSize: 16.0,
      webBgColor: "#000000",
      webShowClose: true,
    );
  }

  void synchronizeCourses() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      showPage = true;
    });

    showCustomSnackbarLong(
        context, "Please wait while fetching data from the server");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              centerTitle: true,
              title: Text(courses.isNotEmpty ? 'Your courses' : ''),
              actions: [
                // Add any actions you need here
              ],
            ),
            body: courses.isNotEmpty
                ? Column(
                    children: [
                      const SizedBox(height: 5),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.builder(
                            itemCount: courses.length,
                            itemBuilder: (context, index) {
                              final data = courses[index];
                              return Card(
                                elevation: 5,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: ListTile(
                                  trailing: const Icon(CupertinoIcons.forward,
                                      size: 18),
                                  leading: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).canvasColor,
                                      child: Text(
                                        data['refId'] ?? '',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    data['name'] ?? '',
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CourseDetailsPage(course: data),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : showPage
                    ? InAppWebView(
                        initialUrlRequest: URLRequest(
                          url: WebUri(
                            'https://login.hs-heilbronn.de/realms/hhn/protocol/openid-connect/auth?response_mode=form_post&response_type=id_token&redirect_uri=https%3A%2F%2Filias.hs-heilbronn.de%2Fopenidconnect.php&client_id=hhn_common_ilias&nonce=badc63032679bb541ff44ea53eeccb4e&state=2182e131aa3ed4442387157cd1823be0&scope=openid+openid',
                          ),
                        ),
                        onLoadStart: (controller, url) {
                          setState(() {
                            _webViewController = controller;
                          });
                          print("WebView started loading: $url");
                        },
                        onLoadStop: (controller, url) async {
                          print("WebView stopped loading: $url");
                          if (url.toString() ==
                              "https://ilias.hs-heilbronn.de/ilias.php?baseClass=ilDashboardGUI&cmd=jumpToSelectedItems") {
                            controller.loadUrl(
                              urlRequest: URLRequest(
                                url: WebUri(
                                  "https://ilias.hs-heilbronn.de/ilias.php?cmdClass=ilmembershipoverviewgui&cmdNode=jr&baseClass=ilmembershipoverviewgui",
                                ),
                              ),
                            );
                            Future.delayed(const Duration(seconds: 2),
                                () async {
                              final result = await controller
                                  .evaluateJavascript(source: '''
                                 const courseRows = document.querySelectorAll('.il-std-item');
                                 const courses = [];

                                function getRefId(url) {
                                const match = url.match(/ref_id=(\\d+)/);
                                return match ? match[1] : '';
                                }

                                courseRows.forEach((courseRow) => {
                                const imgElement = courseRow.querySelector('img.icon');
                                if (imgElement && imgElement.getAttribute('alt') !== 'Symbol Gruppe') {
                                const courseNameElement = courseRow.querySelector('.il-item-title a');
                                if (courseNameElement) {
                                const courseName = courseNameElement.innerText;
                                const courseUrl = courseNameElement.getAttribute('href');
                                const courseRefId = getRefId(courseUrl);
                                courses.push({
                                'name': courseName,
                                'refId': courseRefId,
                                'url': courseUrl,
                                });
                                }
                                }
                                });

                                JSON.stringify(courses);
                                ''');

                              // Parse the result from JSON
                              List<dynamic> courseList = json.decode(result);

                              // Ensure the types are correct
                              List<Map<String, dynamic>> typedCourseList =
                                  courseList.map((course) {
                                // Check if course is a Map and has the required keys
                                if (course is Map) {
                                  return {
                                    'name': course['name']?.toString() ?? '',
                                    'refId': course['refId']?.toString() ?? '',
                                    'url': course['url']?.toString() ?? '',
                                  };
                                } else {
                                  // Handle the case where course is not a Map
                                  return {
                                    'name': '',
                                    'refId': '',
                                    'url': '',
                                  };
                                }
                              }).toList();

                              setState(() {
                                courses = typedCourseList;
                                print('Scrapped_result');
                                print(typedCourseList);
                                showPage = !showPage;
                              });
                            });
                          }
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/logo.svg',
                                width: MediaQuery.of(context).size.width / 2.5),
                            const SizedBox(height: 30),
                            const Text(
                              "Your courses are not synchronized",
                              style: TextStyle(fontSize: 16),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.1,
                              child: ElevatedButton(
                                onPressed:
                                    _isLoading ? null : synchronizeCourses,
                                child: _isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        "Synchronize with Hochschule Heilbronn"),
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class CourseDetailsPage extends StatelessWidget {
  final Map<String, dynamic> course;

  CourseDetailsPage({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course['name'] ?? 'Course Details',
            style: const TextStyle(fontSize: 14),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course['name'] ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 10,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'Course ID: ',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      '${course['refId'] ?? ''}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 10,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Course URL: ',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '${course['url'] ?? ''}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 10,
                ),
// Add more details if available
              ],
            ),
          ),
        ),
      ),
    );
  }
}
