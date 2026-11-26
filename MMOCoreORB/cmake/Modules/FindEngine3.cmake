# Core3 and Engine3 must use the same broker headers and implementation.
# Prepare them in the build tree from Stardust's public submodule pin and its patch.
find_package(Git REQUIRED)

function(stardust_engine_git directory)
  execute_process(COMMAND "${GIT_EXECUTABLE}" -C "${directory}" ${ARGN}
    RESULT_VARIABLE result ERROR_VARIABLE detail)
  if(NOT result EQUAL 0)
    message(FATAL_ERROR "Preparing Stardust Engine3 failed in ${directory}: ${detail}")
  endif()
endfunction()

function(stardust_prepare_engine3 output)
  set(patch "${CMAKE_CURRENT_LIST_DIR}/../patches/engine3-broker.patch")
  set(item "utils/engine3")
  execute_process(COMMAND "${GIT_EXECUTABLE}" -C "${CMAKE_CURRENT_SOURCE_DIR}"
    rev-parse --verify ":./${item}" RESULT_VARIABLE result
    OUTPUT_VARIABLE revision OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(NOT result EQUAL 0 OR NOT revision MATCHES "^[0-9a-f]+$")
    message(FATAL_ERROR "Cannot read the Engine3 submodule pin from the Stardust Git checkout")
  endif()
  execute_process(COMMAND "${GIT_EXECUTABLE}" -C "${CMAKE_CURRENT_SOURCE_DIR}" rev-parse --git-path index
    OUTPUT_VARIABLE git_index OUTPUT_STRIP_TRAILING_WHITESPACE)
  get_filename_component(git_index "${git_index}" ABSOLUTE BASE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
  set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS "${git_index}" "${patch}")

  file(SHA256 "${patch}" patch_hash)
  string(SUBSTRING "${patch_hash}" 0 12 patch_id)
  string(SUBSTRING "${revision}" 0 12 revision_id)
  set(tree "${CMAKE_CURRENT_BINARY_DIR}/_deps/engine3-${revision_id}-${patch_id}")
  file(MAKE_DIRECTORY "${tree}")
  file(LOCK "${tree}/prepare.lock" GUARD FUNCTION TIMEOUT 180)
  if(NOT EXISTS "${tree}/prepared")
    set(source "${CMAKE_CURRENT_SOURCE_DIR}/${item}")
    set(have_pin 1)
    if(EXISTS "${source}/.git")
      execute_process(COMMAND "${GIT_EXECUTABLE}" -C "${source}" cat-file -e "${revision}^{commit}"
        RESULT_VARIABLE have_pin ERROR_QUIET)
    endif()
    if(NOT have_pin EQUAL 0)
      execute_process(COMMAND "${GIT_EXECUTABLE}" config -f "${CMAKE_CURRENT_SOURCE_DIR}/../.gitmodules"
        --get submodule.MMOCoreORB/utils/engine3.url RESULT_VARIABLE result
        OUTPUT_VARIABLE source OUTPUT_STRIP_TRAILING_WHITESPACE)
      if(NOT result EQUAL 0)
        message(FATAL_ERROR "Cannot find the Engine3 URL in Stardust's .gitmodules")
      endif()
    endif()

    message(STATUS "Preparing Stardust broker patch on Engine3 ${revision_id}")
    stardust_engine_git("${tree}" init --quiet)
    stardust_engine_git("${tree}" config core.autocrlf false)
    stardust_engine_git("${tree}" config core.eol lf)
    stardust_engine_git("${tree}" fetch --quiet --no-tags --depth=1 --update-shallow "${source}" "${revision}")
    stardust_engine_git("${tree}" checkout --quiet --force --detach "${revision}")
    stardust_engine_git("${tree}" apply --whitespace=nowarn "${patch}")
    file(WRITE "${tree}/prepared" "${revision}\n${patch_hash}\n")
  endif()
  set(${output} "${tree}" PARENT_SCOPE)
endfunction()

stardust_prepare_engine3(stardust_engine_tree)
set(ENGINE3_INCLUDE_DIR "${stardust_engine_tree}/MMOEngine/src")
set(IDLC_BIN_DIR "${stardust_engine_tree}/MMOEngine/lib")
set(IDL_DIRECTIVES -outdir autogen -cp "${ENGINE3_INCLUDE_DIR}")
set(IDLC_JAVA_ARGS -XX:TieredStopAtLevel=1 -client -Xmx128M -cp "${IDLC_BIN_DIR}/idlc.jar" org.sr.idlc.compiler.Compiler)

set(saved_source_dir "${CMAKE_SOURCE_DIR}")
set(CMAKE_SOURCE_DIR "${stardust_engine_tree}/MMOEngine")
add_subdirectory("${CMAKE_SOURCE_DIR}" "${stardust_engine_tree}/cmake-build")
set(CMAKE_SOURCE_DIR "${saved_source_dir}")
set(ENGINE3_LIBRARIES engine3)
set(ENGINE3_FOUND TRUE)
