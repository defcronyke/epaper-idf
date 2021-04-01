idf_component_register(
    SRCS
        "main.cpp"
        "ota.c"

        $ENV{IDF_PATH}/examples/common_components/protocol_examples_common/connect.c
        $ENV{IDF_PATH}/examples/common_components/protocol_examples_common/addr_from_stdin.c
        $ENV{IDF_PATH}/examples/common_components/protocol_examples_common/stdin_out.c
        $ENV{IDF_PATH}/components/esp_https_ota/src/esp_https_ota.c
    
    REQUIRES
        "epaper-idf-component"

    INCLUDE_DIRS        
        $ENV{IDF_PATH}/components/app_update/include
        $ENV{IDF_PATH}/components/bootloader_support/include
        $ENV{IDF_PATH}/components/esp_http_client/include
        $ENV{IDF_PATH}/components/esp_https_ota/include
        $ENV{IDF_PATH}/components/nghttp/port/include
        $ENV{IDF_PATH}/components/nvs_flash/include
        $ENV{IDF_PATH}/components/spi_flash/include
        $ENV{IDF_PATH}/examples/common_components/protocol_examples_common/include
    
    # Embed the server root certificate into the final binary
    EMBED_TXTFILES 
        ${project_dir}/certs/ca_cert.pem
)

set(
    COMPONENTS_DIRS,
        ${project_dir}/components
)

add_compile_definitions(
    EPAPER_IDF_LOG_VERB=1
    ESP32_IDF
)
