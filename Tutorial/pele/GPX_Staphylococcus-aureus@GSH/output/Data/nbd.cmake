SET(PELE_DEPENDENCIES_PATH /shared/work/NBD_Utilities/PELE/PELE_dependencies/ CACHE PATH "Path were the dependencies can be found" )
SET(BOOST_ROOT ${PELE_DEPENDENCIES_PATH}/boost-1.52.0 CACHE PATH "")
SET(Wjelement_HOME ${PELE_DEPENDENCIES_PATH}/wjelement CACHE PATH "") 
set(CRYPTOPP_HOME ${PELE_DEPENDENCIES_PATH}/cryptopp-5.6.5 CACHE PATH "") 
set(Jsoncpp_INCLUDE_DIR 
    ${PELE_DEPENDENCIES_PATH}/jsoncpp-0.10.6/include/jsoncpp
    CACHE PATH "")
set(Jsoncpp_LIBRARY
    ${PELE_DEPENDENCIES_PATH}/jsoncpp-0.10.6/lib/libjsoncpp.a
    CACHE FILEPATH "")
