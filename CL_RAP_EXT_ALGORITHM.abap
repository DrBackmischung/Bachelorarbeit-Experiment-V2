CLASS cl_rap_ext_algorithm DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: tt_node TYPE TABLE OF REF TO cl_rap_ext_node.
    CLASS-DATA: mt_nodes TYPE tt_node.
    CLASS-METHODS:
      start_dfs_rec_det_post
        IMPORTING iv_node  TYPE REF TO cl_rap_ext_node
        EXPORTING et_nodes TYPE tt_node,
      start_dfs_rec_det_pre
        IMPORTING iv_node  TYPE REF TO cl_rap_ext_node
        EXPORTING et_nodes TYPE tt_node,
      start_dfs_it_det_post
        IMPORTING iv_node  TYPE REF TO cl_rap_ext_node
        EXPORTING et_nodes TYPE tt_node,
      start_dfs_it_det_pre
        IMPORTING iv_node  TYPE REF TO cl_rap_ext_node
        EXPORTING et_nodes TYPE tt_node,
      start_bfs_it_det_pre
        IMPORTING iv_node  TYPE REF TO cl_rap_ext_node
        EXPORTING et_nodes TYPE tt_node.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS:
      dfs_rec_det_post
        IMPORTING iv_node TYPE REF TO cl_rap_ext_node,
      dfs_rec_det_pre
        IMPORTING iv_node TYPE REF TO cl_rap_ext_node.
ENDCLASS.

CLASS cl_rap_ext_algorithm IMPLEMENTATION.

  METHOD start_dfs_rec_det_post.
    CLEAR mt_nodes.
    dfs_rec_det_post( iv_node = iv_node ).
    et_nodes = mt_nodes.
  ENDMETHOD.

  METHOD dfs_rec_det_post.
    IF iv_node->mt_children IS NOT INITIAL.
      LOOP AT iv_node->mt_children INTO DATA(lo_child).
        dfs_rec_det_post( iv_node = lo_child ).
      ENDLOOP.
    ENDIF.
    APPEND iv_node TO mt_nodes.
  ENDMETHOD.

  METHOD start_dfs_rec_det_pre.
    CLEAR mt_nodes.
    dfs_rec_det_pre( iv_node = iv_node ).
    et_nodes = mt_nodes.
  ENDMETHOD.

  METHOD dfs_rec_det_pre.
    APPEND iv_node TO mt_nodes.
    IF iv_node->mt_children IS NOT INITIAL.
      LOOP AT iv_node->mt_children INTO DATA(lo_child).
        dfs_rec_det_pre( iv_node = lo_child ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD start_dfs_it_det_post.
    CLEAR mt_nodes.
    DATA lt_stack TYPE TABLE OF REF TO cl_rap_ext_node.
    DATA lt_reverse TYPE TABLE OF REF TO cl_rap_ext_node.
    APPEND iv_node TO lt_stack.
    WHILE LINES( lt_stack ) NE 0.
      DATA lo_current TYPE REF TO cl_rap_ext_node.
      DATA last TYPE sy-tabix.
      DESCRIBE TABLE lt_stack LINES last.
      READ TABLE lt_stack INTO lo_current INDEX last.
      APPEND lo_current TO mt_nodes.
      DELETE lt_stack INDEX last.
      IF lo_current->mt_children IS NOT INITIAL.
        LOOP AT lo_current->mt_children INTO DATA(lv_child).
          APPEND lv_child TO lt_stack.
        ENDLOOP.
      ENDIF.
    ENDWHILE.
    DATA lv_no_of_lines TYPE i.
    DESCRIBE TABLE mt_nodes LINES lv_no_of_lines.
    DATA(lv_ctr) = lv_no_of_lines.
    DO lv_no_of_lines TIMES.
      READ TABLE mt_nodes INTO DATA(lv_node) INDEX lv_ctr.
      APPEND lv_node TO lt_reverse.
      lv_ctr = lv_ctr - 1.
    ENDDO.
    et_nodes = lt_reverse.
  ENDMETHOD.

  METHOD start_dfs_it_det_pre.
    CLEAR mt_nodes.
    DATA lt_stack TYPE TABLE OF REF TO cl_rap_ext_node.
    APPEND iv_node TO lt_stack.
    WHILE LINES( lt_stack ) NE 0.
      DATA lo_current TYPE REF TO cl_rap_ext_node.
      DATA last TYPE sy-tabix.
      DESCRIBE TABLE lt_stack LINES last.
      READ TABLE lt_stack INTO lo_current INDEX last.
      APPEND lo_current TO mt_nodes.
      DELETE lt_stack INDEX last.
      IF lo_current->mt_children IS NOT INITIAL.
        LOOP AT lo_current->mt_children INTO DATA(lv_child).
          APPEND lv_child TO lt_stack.
        ENDLOOP.
      ENDIF.
    ENDWHILE.
    et_nodes = mt_nodes.
  ENDMETHOD.

  METHOD start_bfs_it_det_pre.
    CLEAR mt_nodes.
    DATA lt_stack TYPE TABLE OF REF TO cl_rap_ext_node.
    APPEND iv_node TO lt_stack.
    WHILE LINES( lt_stack ) NE 0.
      DATA(lo_current) = lt_stack[ 1 ].
      APPEND lo_current TO mt_nodes.
      DELETE lt_stack INDEX 1.
      IF lo_current->mt_children IS NOT INITIAL.
        LOOP AT lo_current->mt_children INTO DATA(lv_child).
          APPEND lv_child TO lt_stack.
        ENDLOOP.
      ENDIF.
    ENDWHILE.
    et_nodes = mt_nodes.
  ENDMETHOD.

ENDCLASS.
