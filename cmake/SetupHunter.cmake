set(CMAKE_FIND_PACKAGE_PREFER_CONFIG TRUE)

set(HUNTER_PREFER_RELEASE_DEPENDENCIES ON CACHE BOOL "Prefer release versions of dependencies added through Hunter.")
set(HUNTER_CONFIGURATION_TYPES "Release" CACHE STRING "Hunter dependency build variants" FORCE)

include("${CMAKE_CURRENT_LIST_DIR}/HunterGate.cmake")
HunterGate(
    URL "https://github.com/cpp-pm/hunter/archive/v0.25.3.tar.gz"
    SHA1 "0dfbc2cb5c4cf7e83533733bdfd2125ff96680cb"
    FILEPATH "${CMAKE_CURRENT_LIST_DIR}/HunterConfig.cmake"
)
