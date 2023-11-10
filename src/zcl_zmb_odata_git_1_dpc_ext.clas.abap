class ZCL_ZMB_ODATA_GIT_1_DPC_EXT definition
  public
  inheriting from ZCL_ZMB_ODATA_GIT_1_DPC
  create public .

public section.
protected section.

  methods SOHEADERSET_GET_ENTITY
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
ENDCLASS.
