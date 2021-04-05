idf_component_register(
  SRCS
    "main.cpp"

    # ${project_dir}/components/epaper-idf-component/epaper-idf-http.c
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
