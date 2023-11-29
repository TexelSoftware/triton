set(CMAKE_FIND_PACKAGE_PREFER_CONFIG TRUE)

set(HUNTER_PREFER_RELEASE_DEPENDENCIES ON CACHE BOOL "Prefer release versions of dependencies added through Hunter.")
set(HUNTER_CONFIGURATION_TYPES "Release" CACHE STRING "Hunter dependency build variants" FORCE)

set(HUNTER_STATUS_DEBUG ON)

set(HUNTER_CACHE_SERVERS "https://github.com/cpp-pm/hunter-cache" CACHE STRING "Default cache server")

string(COMPARE EQUAL "$ENV{CI}" "true" is_ci)
string(COMPARE EQUAL "$ENV{CPP_PM_BOT_CACHE_GITHUB_PASSWORD}" "" password_is_empty)

if(1) #is_ci AND NOT password_is_empty)
  option(HUNTER_RUN_UPLOAD "Upload cache binaries" ON)
  file(WRITE "${CMAKE_BINARY_DIR}/HunterPasswords.cmake" "\
    hunter_upload_password(\n\
        REPO_OWNER \"cpp-pm\"\n\
        REPO \"hunter-cache\"\n\
        USERNAME \"cpp-pm-bot\"\n\
        PASSWORD \"\$ENV\{CPP_PM_BOT_CACHE_GITHUB_PASSWORD\}\"\n\
    )\
  ")
  set(
    HUNTER_PASSWORDS_PATH
    "${CMAKE_BINARY_DIR}/HunterPasswords.cmake"
    CACHE
    FILEPATH
    "Hunter passwords"
  )
endif()

# Triton-specific Setup
file(STRINGS "${CMAKE_CURRENT_LIST_DIR}/llvm-hash.txt" TRITON_LLVM_HASH LIMIT_COUNT 1)
if(NOT EXISTS "${CMAKE_BINARY_DIR}/${TRITON_LLVM_HASH}.tar.gz")
  file(DOWNLOAD "https://github.com/llvm/llvm-project/archive/${TRITON_LLVM_HASH}.tar.gz" "${CMAKE_BINARY_DIR}/${TRITON_LLVM_HASH}.tar.gz")
endif()
file(SHA1 "${CMAKE_BINARY_DIR}/${TRITON_LLVM_HASH}.tar.gz" TRITON_LLVM_BINARY_HASH)
string(SUBSTRING "${TRITON_LLVM_HASH}" 0 8 TRITON_LLVM_SHORT_HASH)

file(WRITE "${CMAKE_BINARY_DIR}/HunterConfig.cmake" "\
hunter_config(LLVM\n\
    VERSION \"${TRITON_LLVM_SHORT_HASH}-triton\"\n\
    URL \"${CMAKE_BINARY_DIR}/${TRITON_LLVM_HASH}.tar.gz\"\n\
    SHA1 \"${TRITON_LLVM_BINARY_HASH}\"\n\
    CMAKE_ARGS\n\
        LLVM_ENABLE_PROJECTS=clang;mlir\n\
        LLVM_INSTALL_UTILS=ON\n\
        LLVM_INCLUDE_TESTS=OFF\n\
        LLVM_TARGETS_TO_BUILD=NVPTX;AMDGPU\n\
)\
")

set(HUNTER_FILEPATH_CONFIG "${CMAKE_BINARY_DIR}/HunterConfig.cmake")
set(HUNTER_PACKAGES LLVM)
# End Triton-specific Setup

include(FetchContent)
FetchContent_Declare(SetupHunter GIT_REPOSITORY https://github.com/cpp-pm/gate)
FetchContent_MakeAvailable(SetupHunter)
