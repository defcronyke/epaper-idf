# epaper-idf
#
# Copyright (c) 2021 Jeremy Carter <jeremy@jeremycarter.ca>
#
# This code is released under the license terms contained in the
# file named LICENSE, which is found in the top-level folder in
# this project. You must agree to follow those license terms,
# otherwise you aren't allowed to copy, distribute, or use any 
# part of this project in any way.

idf_component_register(
  SRCS
    "main.cpp"

    ${project_dir}/components/epaper-idf-component/task/http-slideshow.cpp
  
  REQUIRES
    "epaper-idf-component"

  INCLUDE_DIRS
    ${project_dir}/components/epaper-idf-component/include
)

set(
  COMPONENTS_DIRS,
    ${project_dir}/components
)

add_compile_definitions(
  EPAPER_IDF_LOG_VERB=1
  ESP32_IDF
)
