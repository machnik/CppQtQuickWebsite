if(NOT DEFINED HTML_FILE)
    message(FATAL_ERROR "HTML_FILE must be set.")
endif()

if(NOT EXISTS "${HTML_FILE}")
    message(FATAL_ERROR "WebAssembly HTML shell not found: ${HTML_FILE}")
endif()

file(READ "${HTML_FILE}" html_content)

set(helper_file "shared_array_buffer_fix.js")
set(malformed_helper_script "<script src=\"shared_array_buffer_fix\"></script>\n")
string(REPLACE "${malformed_helper_script}" "" html_content "${html_content}")

string(FIND "${html_content}" "${helper_file}" helper_script_index)
if(NOT helper_script_index EQUAL -1)
    return()
endif()

set(app_script "<script src=\"WebApplication.js\"></script>")
string(FIND "${html_content}" "${app_script}" app_script_index)
if(app_script_index EQUAL -1)
    message(FATAL_ERROR "WebAssembly app script tag not found in: ${HTML_FILE}")
endif()

set(helper_script "<script src=\"${helper_file}\"></script>")
string(REPLACE "${app_script}" "${helper_script}\n    ${app_script}" html_content "${html_content}")
file(WRITE "${HTML_FILE}" "${html_content}")