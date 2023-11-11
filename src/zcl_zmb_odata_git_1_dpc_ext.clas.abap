class ZCL_ZMB_ODATA_GIT_1_DPC_EXT definition
  public
  inheriting from ZCL_ZMB_ODATA_GIT_1_DPC
  create public .

public section.
protected section.

  methods SOHEADERSET_CREATE_ENTITY
    redefinition .
  methods SOHEADERSET_GET_ENTITY
    redefinition .
  methods SOHEADERSET_GET_ENTITYSET
    redefinition .
  methods SOHEADERSET_UPDATE_ENTITY
    redefinition .
  methods SOHEADERSET_DELETE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZMB_ODATA_GIT_1_DPC_EXT IMPLEMENTATION.


  method SOHEADERSET_GET_ENTITY.
     DATA : ls_key_tab TYPE /IWBEP/S_MGW_NAME_VALUE_PAIR ,
            ls_vbeln type vbeln  .

     "READ IMPORTING PARAMETER

      READ TABLE it_key_tab INTO ls_key_tab with KEY name = 'Vbeln' .

     if ls_key_tab-value is not INITIAL .
       ls_vbeln = ls_key_tab-value .
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input         = ls_vbeln
         IMPORTING
           OUTPUT        =  ls_vbeln
                  .
        SELECT SINGLE * FROM ZOVBAK INTO CORRESPONDING FIELDS OF er_entity WHERE vbeln = ls_vbeln.
     ENDIF .

  endmethod.


  method SOHEADERSET_CREATE_ENTITY.

  DATA : wa_entity like er_entity ,
         gs_zovbak type zovbak .
  TRY.
  CALL METHOD io_data_provider->read_entry_data
    IMPORTING
      es_data = wa_entity
      .

      IF wa_entity-vbeln is not INITIAL .
        MOVE-CORRESPONDING wa_entity TO gs_zovbak .
        modify zovbak from gs_zovbak.

         MOVE-CORRESPONDING wa_entity to er_entity .

         er_entity-remark = 'Record Created'.

      ENDIF .
    CATCH /iwbep/cx_mgw_tech_exception.
  ENDTRY.



  endmethod.


  method SOHEADERSET_GET_ENTITYSET.


           "$filter depending on the range specified on the parameter.
    DATA: r_vbeln  TYPE RANGE OF zovbak-vbeln,
          ls_vbeln LIKE LINE OF r_vbeln.


    DATA : ls_filter_select_options TYPE /iwbep/s_mgw_select_option,
           lt_select_options        TYPE /iwbep/t_cod_select_options,
           ls_select_options        TYPE /iwbep/s_cod_select_option.

    READ TABLE it_filter_select_options INTO ls_filter_select_options
    WITH KEY property = 'Vbeln'.

    IF ls_filter_select_options-property IS NOT INITIAL.

      lt_select_options[] = ls_filter_select_options-select_options[].

      LOOP AT lt_select_options INTO ls_select_options.

        ls_vbeln-sign = ls_select_options-sign.
        ls_vbeln-option = ls_select_options-option.
        ls_vbeln-low = ls_select_options-low.
        ls_vbeln-high = ls_select_options-high.
        APPEND ls_vbeln TO r_vbeln.
        CLEAR ls_select_options.
      ENDLOOP.

    ENDIF.
    SELECT * FROM zovbak
    INTO CORRESPONDING FIELDS OF TABLE et_entityset
    WHERE vbeln IN r_vbeln.
  endmethod.


  method SOHEADERSET_UPDATE_ENTITY.
  DATA : wa_entity like er_entity ,
         gs_zovbak type zovbak .
  TRY.
  CALL METHOD io_data_provider->read_entry_data
    IMPORTING
      es_data = wa_entity
      .

      IF wa_entity-vbeln is not INITIAL .
        MOVE-CORRESPONDING wa_entity TO gs_zovbak .
        modify zovbak from gs_zovbak.



         er_entity-remark = 'Record Modifyed Successfully'.

         MOVE-CORRESPONDING wa_entity to er_entity .

      ENDIF .
    CATCH /iwbep/cx_mgw_tech_exception.
  ENDTRY.
  endmethod.


  method SOHEADERSET_DELETE_ENTITY.

   read table it_key_tab into data(gs_key_tab) with key name = 'Vbeln' .
   IF gs_key_tab is not INITIAL .
    DATA: lv_vbeln type vbeln .

    lv_vbeln = gs_key_tab-value .

    DELETE from zovbak where vbeln = lv_vbeln .
  ENDIF .

  endmethod.
ENDCLASS.
