# Boost CMake configuration file

set(Boost_VERSION "1.78.0")
set(Boost_VERSION_MAJOR 1)
set(Boost_VERSION_MINOR 78)
set(Boost_VERSION_PATCH 0)
set(Boost_VERSION_COUNT 3)

set(Boost_LIB_VERSION "1_78")

set(Boost_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}/../include")
set(Boost_LIBRARY_DIRS "${CMAKE_CURRENT_LIST_DIR}/../lib")

set(Boost_LIBRARIES
  boost_system
  boost_filesystem
  boost_thread
  boost_date_time
  boost_regex
  boost_program_options
  boost_iostreams
)

foreach(COMPONENT ${Boost_FIND_COMPONENTS})
  string(TOUPPER ${COMPONENT} UPPERCOMPONENT)
  set(Boost_${UPPERCOMPONENT}_FOUND TRUE)
  set(Boost_${UPPERCOMPONENT}_LIBRARY "boost_${COMPONENT}")
  set(Boost_${UPPERCOMPONENT}_LIBRARY_DEBUG "boost_${COMPONENT}")
  set(Boost_${UPPERCOMPONENT}_LIBRARY_RELEASE "boost_${COMPONENT}")
endforeach()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Boost
  REQUIRED_VARS Boost_INCLUDE_DIRS Boost_LIBRARY_DIRS
  VERSION_VAR Boost_VERSION
  HANDLE_COMPONENTS
  ) 