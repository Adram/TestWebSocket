cmake_minimum_required(VERSION 2.8)
project(tstwebsocket)

# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# Find the QtWidgets library
find_package(Qt5Core)
find_package(Qt5Quick)
find_package(Qt5WebSockets)
#find_package(Qt5Qml)

configure_file("conf/FileTest"              "conf/FileTest")
configure_file("conf/FileTestInstance"      "conf/FileTestInstance")
configure_file("conf/backup.txt"            "conf/backup.txt")
configure_file("conf/backup_read.txt"       "conf/backup_read.txt")
configure_file("conf/GUIBkp_read.txt"       "conf/GUIBkp_read.txt")
configure_file("conf/json_doc_rx.txt"       "conf/json_doc_rx.txt")


# - configure_file("main.qml"                      "main.qml")
# - configure_file("qml.qrc"                       "qml.qrc")
# - qt5_add_resources(RESOURCES ${CMAKE_CURRENT_BINARY_DIR}/qml.qrc)


set(CPP_SOURCES
    main.cpp
    ws_server.cpp
)

# Tell CMake to create the helloworld executable
# comment - add_executable(helloworld WIN32 main.cpp)
# aux_source_directory(. SRC_LIST)


add_executable(${PROJECT_NAME} ${CPP_SOURCES} "qml.qrc")
#add_executable(${PROJECT_NAME} ${SRC_LIST} "qml.qrc")
# - add_executable(${PROJECT_NAME} ${SRC_LIST} ${RESOURCES})

# add_executable(${PROJECT_NAME} ${SRC_LIST} "qml.qrc" ${RESOURCES})

# Use the Widgets module from Qt 5
#target_link_libraries(guibkp Qt5::Core Qt5::Quick Qt5::Qml)
target_link_libraries(${PROJECT_NAME} Qt5::Core Qt5::Quick Qt5::WebSockets)

