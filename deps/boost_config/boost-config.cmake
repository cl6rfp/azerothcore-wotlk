# Boost configuration file

set(BOOST_VERSION "1.78.0")
set(BOOST_VERSION_MAJOR 1)
set(BOOST_VERSION_MINOR 78)
set(BOOST_VERSION_PATCH 0)

set(BOOST_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}/../include")
set(BOOST_LIBRARY_DIRS "${CMAKE_CURRENT_LIST_DIR}/../lib")

set(BOOST_LIBRARIES
  boost_system
  boost_filesystem
  boost_thread
  boost_date_time
  boost_regex
  boost_program_options
  boost_iostreams
)

set(BOOST_FOUND TRUE) 