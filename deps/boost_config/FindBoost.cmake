# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindBoost
---------

Find Boost include dirs and libraries

Use this module by invoking find_package with the form::

  find_package(Boost
    [version] [EXACT]      # Minimum or EXACT version e.g. 1.78.0
    [REQUIRED]             # Fail with error if Boost is not found
    [COMPONENTS <libs>...] # Boost libraries by their canonical name
    )                      # e.g. "date_time" for "libboost_date_time"

This module finds headers and requested component libraries OR a CMake
package configuration file provided by a Boost "superproject" build.

This module sets up variables for all components requested through the
COMPONENTS keyword.  For each component, the following variables are set:

``Boost_<COMPONENT>_FOUND``
  True if the component was found.

``Boost_<COMPONENT>_LIBRARY``
  The absolute path of the component library.

``Boost_<COMPONENT>_LIBRARY_DEBUG``
  The absolute path of the debug component library.

``Boost_<COMPONENT>_LIBRARY_RELEASE``
  The absolute path of the release component library.

The following variables are also available:

``Boost_VERSION``
  The version string of Boost found.

``Boost_VERSION_MAJOR``
  The major version of Boost found.

``Boost_VERSION_MINOR``
  The minor version of Boost found.

``Boost_VERSION_PATCH``
  The patch version of Boost found.

``Boost_VERSION_COUNT``
  The number of version components of Boost found.

``Boost_LIB_VERSION``
  A string suitable for use in constructing library filenames.

``Boost_INCLUDE_DIRS``
  The Boost include directories.

``Boost_LIBRARY_DIRS``
  The Boost library directories.

``Boost_LIBRARIES``
  The Boost libraries.

``Boost_<COMPONENT>_LIBRARY_DIRS``
  The component library directories.

``Boost_<COMPONENT>_LIBRARIES``
  The component libraries.

#]=======================================================================]

# Save project's policies
cmake_policy(PUSH)
cmake_policy(SET CMP0057 NEW) # if IN_LIST

# Check policies
if(POLICY CMP0074)
  cmake_policy(SET CMP0074 NEW)
endif()

# Initialize search paths
set(BOOST_ROOT "$ENV{BOOST_ROOT}")
set(BOOST_INCLUDEDIR "$ENV{BOOST_INCLUDEDIR}")
set(BOOST_LIBRARYDIR "$ENV{BOOST_LIBRARYDIR}")

# Set Boost_FIND_QUIETLY to TRUE if Boost_FIND_REQUIRED is FALSE and
# Boost_FIND_QUIETLY is not defined
if(NOT Boost_FIND_REQUIRED AND NOT DEFINED Boost_FIND_QUIETLY)
  set(Boost_FIND_QUIETLY TRUE)
endif()

# ------------------------------------------------------------------------
#  Search for Boost include DIR
# ------------------------------------------------------------------------

set(_Boost_INCLUDE_SEARCH_DIRS "")
if(BOOST_INCLUDEDIR)
  list(APPEND _Boost_INCLUDE_SEARCH_DIRS ${BOOST_INCLUDEDIR})
elseif(BOOST_ROOT)
  list(APPEND _Boost_INCLUDE_SEARCH_DIRS ${BOOST_ROOT}/include)
endif()

# Add in some additional standard paths
list(APPEND _Boost_INCLUDE_SEARCH_DIRS
  C:/boost/include
  C:/boost
  "$ENV{ProgramFiles}/boost/boost_${Boost_MAJOR_VERSION}_${Boost_MINOR_VERSION}_${Boost_SUBMINOR_VERSION}"
  "$ENV{ProgramFiles}/boost"
  "$ENV{ProgramFiles}/boost/boost_${Boost_MAJOR_VERSION}_${Boost_MINOR_VERSION}"
  /opt/boost/include
  /opt/boost
  /usr/local/include
  /usr/include
  /sw/include
  /usr/local
  /usr
  )

# Look for a standard boost header file.
find_path(Boost_INCLUDE_DIR
  NAMES         boost/config.hpp
  HINTS         ${_Boost_INCLUDE_SEARCH_DIRS}
  )

if(Boost_INCLUDE_DIR)
  # Extract Boost_VERSION and Boost_LIB_VERSION from version.hpp
  set(Boost_VERSION 0)
  set(Boost_LIB_VERSION "")
  file(STRINGS "${Boost_INCLUDE_DIR}/boost/version.hpp" _boost_VERSION_HPP_CONTENTS REGEX "#define BOOST_(LIB_)?VERSION ")
  set(_Boost_VERSION_REGEX "([0-9]+)")
  set(_Boost_LIB_VERSION_REGEX "\"([0-9_]+)\"")
  foreach(v VERSION LIB_VERSION)
    if("${_boost_VERSION_HPP_CONTENTS}" MATCHES "#define BOOST_${v} ${_Boost_${v}_REGEX}")
      set(Boost_${v} "${CMAKE_MATCH_1}")
    endif()
  endforeach()
  unset(_boost_VERSION_HPP_CONTENTS)

  math(EXPR Boost_MAJOR_VERSION "${Boost_VERSION} / 100000")
  math(EXPR Boost_MINOR_VERSION "${Boost_VERSION} / 100 % 1000")
  math(EXPR Boost_SUBMINOR_VERSION "${Boost_VERSION} % 100")

  set(Boost_VERSION "${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION}.${Boost_SUBMINOR_VERSION}")
endif()

# ------------------------------------------------------------------------
#  Search for Boost libraries DIR
# ------------------------------------------------------------------------

set(_Boost_LIBRARY_SEARCH_DIRS "")
if(BOOST_LIBRARYDIR)
  list(APPEND _Boost_LIBRARY_SEARCH_DIRS ${BOOST_LIBRARYDIR})
elseif(BOOST_ROOT)
  list(APPEND _Boost_LIBRARY_SEARCH_DIRS ${BOOST_ROOT}/lib)
endif()

# Add in some additional standard paths
list(APPEND _Boost_LIBRARY_SEARCH_DIRS
  C:/boost/lib
  C:/boost
  "$ENV{ProgramFiles}/boost/boost_${Boost_MAJOR_VERSION}_${Boost_MINOR_VERSION}_${Boost_SUBMINOR_VERSION}/lib"
  "$ENV{ProgramFiles}/boost/lib"
  /opt/boost/lib
  /opt/boost
  /usr/local/lib
  /usr/lib
  /sw/lib
  /usr/local
  /usr
  )

# Look for a standard boost library file.
find_library(Boost_LIBRARY
  NAMES         boost_system
  HINTS         ${_Boost_LIBRARY_SEARCH_DIRS}
  )

if(Boost_LIBRARY)
  get_filename_component(Boost_LIBRARY_DIR ${Boost_LIBRARY} DIRECTORY)
endif()

# ------------------------------------------------------------------------
#  Search for Boost components
# ------------------------------------------------------------------------

set(Boost_FOUND TRUE)
set(Boost_INCLUDE_DIRS ${Boost_INCLUDE_DIR})
set(Boost_LIBRARY_DIRS ${Boost_LIBRARY_DIR})

foreach(COMPONENT ${Boost_FIND_COMPONENTS})
  string(TOUPPER ${COMPONENT} UPPERCOMPONENT)
  set(Boost_${UPPERCOMPONENT}_FOUND FALSE)
  
  find_library(Boost_${UPPERCOMPONENT}_LIBRARY
    NAMES         boost_${COMPONENT}
    HINTS         ${_Boost_LIBRARY_SEARCH_DIRS}
    )
  
  if(Boost_${UPPERCOMPONENT}_LIBRARY)
    set(Boost_${UPPERCOMPONENT}_FOUND TRUE)
    list(APPEND Boost_LIBRARIES ${Boost_${UPPERCOMPONENT}_LIBRARY})
  endif()
endforeach()

# ------------------------------------------------------------------------
#  Finalize
# ------------------------------------------------------------------------

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Boost
  REQUIRED_VARS Boost_INCLUDE_DIR Boost_LIBRARY
  VERSION_VAR Boost_VERSION
  HANDLE_COMPONENTS
  )

# Restore project's policies
cmake_policy(POP) 