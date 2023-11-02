hunter_config(LLVM
    VERSION 18.0.0-49af6502-triton
    URL "https://github.com/llvm/llvm-project/archive/49af6502c6dcb4a7f7520178bd14df396f78240c.tar.gz"
    SHA1 55f7883b1ea90f74ea8d7c4d3db30b3564c0f84c
    CMAKE_ARGS
        LLVM_ENABLE_PROJECTS=clang;mlir
        LLVM_INSTALL_UTILS=ON
        LLVM_INCLUDE_TESTS=OFF
        LLVM_TARGETS_TO_BUILD=NVPTX;AMDGPU
)