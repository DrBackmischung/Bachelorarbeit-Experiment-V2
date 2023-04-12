CLASS cl_rap_ext_node DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: add_child_node IMPORTING iv_node TYPE REF TO cl_rap_ext_node.
    DATA:
      mv_key      TYPE string,
      mv_content  TYPE string,
      mt_children TYPE TABLE OF REF TO cl_rap_ext_node.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS cl_rap_ext_node IMPLEMENTATION.

  METHOD add_child_node.
    APPEND iv_node TO mt_children.
  ENDMETHOD.

ENDCLASS.
