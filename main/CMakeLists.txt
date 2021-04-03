idf_component_register(
  SRCS
    "main.cpp"

    ${project_dir}/components/epaper-idf-component/example/http-slideshow/main.cpp

    $ENV{IDF_PATH}/examples/common_components/protocol_examples_common/connect.c
    $ENV{IDF_PATH}/examples/common_components/protocol_examples_common/addr_from_stdin.c
    $ENV{IDF_PATH}/examples/common_components/protocol_examples_common/stdin_out.c
  
  REQUIRES
    "epaper-idf-component"

  INCLUDE_DIRS
    ${project_dir}/components/epaper-idf-component/example/include

    $ENV{IDF_PATH}/examples/common_components/protocol_examples_common/include
  
  # # Embed the server root certificate into the final binary
  # EMBED_TXTFILES 
  #   ${project_dir}/certs/ca_cert.pem
)

set(
  COMPONENTS_DIRS,
    ${project_dir}/components
)

add_compile_definitions(
  EPAPER_IDF_LOG_VERB=1
  ESP32_IDF
)
