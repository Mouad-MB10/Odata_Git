class ZCL_ZMB_ODATA_GIT_1_DPC_EXT definition
  public
  inheriting from ZCL_ZMB_ODATA_GIT_1_DPC
  create public .

public section.
protected section.

  methods SOHEADERSET_GET_ENTITY
    redefinition .
  methods SOHEADERSET_GET_ENTITYSET
    redefinition .
  methods SOHEADERSET_CREATE_ENTITY
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


        SELECT * FROM ZOVBAK INTO CORRESPONDING FIELDS OF TABLE et_entityset .
  endmethod.
ENDCLASS.
