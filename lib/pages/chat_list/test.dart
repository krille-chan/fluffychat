
  // void resetActiveSpaceId() {
  //   setState(() {
  //     activeSpaceId = null;
  //   });
  // }

  // void setActiveSpace(String? spaceId) {
  //   setState(() {
  //     activeSpaceId = spaceId;
  //     activeFilter = ActiveFilter.spaces;
  //   });
  // }

  // int get selectedIndex {
  //   switch (activeFilter) {
  //     case ActiveFilter.allChats:
  //     case ActiveFilter.messages:
  //       return 0;
  //     case ActiveFilter.groups:
  //       return 1;
  //     case ActiveFilter.spaces:
  //       return AppConfig.separateChatTypes ? 2 : 1;
  //   }
  // }

  // ActiveFilter getActiveFilterByDestination(int? i) {
  //   switch (i) {
  //     case 1:
  //       if (AppConfig.separateChatTypes) {
  //         return ActiveFilter.groups;
  //       }
  //       return ActiveFilter.spaces;
  //     case 2:
  //       return ActiveFilter.spaces;
  //     case 0:
  //     default:
  //       if (AppConfig.separateChatTypes) {
  //         return ActiveFilter.messages;
  //       }
  //       return ActiveFilter.allChats;
  //   }
  // }

  // void onDestinationSelected(int? i) {
  //   setState(() {
  //     activeFilter = getActiveFilterByDestination(i);
  //   });
  // }