idf_component_register(
    SRCS
        "main.cpp"
        "ota.c"
        $ENV{IDF_PATH}/examples/common_components/protocol_examples_common/connect.c
        $ENV{IDF_PATH}/examples/common_components/protocol_examples_common/addr_from_stdin.c
        $ENV{IDF_PATH}/examples/common_components/protocol_examples_common/stdin_out.c
    
    INCLUDE_DIRS
        "."
        $ENV{IDF_PATH}/examples/common_components/protocol_examples_common/include
    
    # Embed the server root certificate into the final binary
    EMBED_TXTFILES 
        ${project_dir}/certs/ca_cert.pem
)

set(
    COMPONENTS_DIRS,
        ${project_dir}/components
)
