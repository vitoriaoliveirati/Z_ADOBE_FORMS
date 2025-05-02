*&---------------------------------------------------------------------*
*& Include          Z_VOA_IMPRIME_FORM_CLS
*&---------------------------------------------------------------------*
"Criar as definições e a parte da implementação.
"Definição, tem que apontar os métodos
"Implementação chamar os métodos

CLASS lcl_application DEFINITION. "LocalClass LCL

  PUBLIC SECTION.

    CLASS-METHODS:
      "2 métodos, um de impressão e outro para exibir o formulário
      imprime_form IMPORTING p_pernr TYPE persno,
      exibe_form IMPORTING p_pernr TYPE persno.

ENDCLASS.


CLASS lcl_application IMPLEMENTATION.

  METHOD exibe_form.

    "Chamar uma função para ela buscar a função que nosso formulário gera em tempo de execução
    "crtl f6 ou modelo para procurar a função
    "Criar uma variável que vai receber o nome do nosso formulário

*    DATA: lv_fm_fname TYPE fpname. "E se quisesse inserir entre aspas simples poderia ser, ou cria a constante abaixo..
    CONSTANTS: lc_form_name    TYPE fpname VALUE 'Z_VOA_EMPLOYEE_FORM',
               lc_barcode_text TYPE string VALUE 'https://www.globo.com/'.



    DATA: lv_fm_name         TYPE funcname,
          ls_fp_outputparams TYPE sfpoutputparams,
          lv_fp_docparams    TYPE sfpdocparams,
          lv_fp_formoutput   TYPE fpformoutput.


    DATA: lv_filename TYPE string,
          lv_path     TYPE string,
          lv_fullpath TYPE string,
          data_tab    TYPE solix_tab,
          lv_qrcode   TYPE xstring.

    TRY.
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = lc_form_name
          IMPORTING
            e_funcname = lv_fm_name.
      CATCH cx_fp_api_repository.
      CATCH cx_fp_api_usage.
      CATCH cx_fp_api_internal.

    ENDTRY.

    cl_rstx_barcode_renderer=>qr_code(
  EXPORTING
    i_module_size      = 20
    i_mode             = 'A'
    i_error_correction = 'H'
    i_rotation         = 0
    i_barcode_text     =  lc_barcode_text
  IMPORTING
    e_bitmap           = lv_qrcode
).
*CATCH cx_rstx_barcode_renderer.




    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = ls_fp_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
      CASE sy-subrc.
        WHEN OTHERS.
      ENDCASE.                           " CASE sy-subrc
    ENDIF.
* Calling Function module
    CALL FUNCTION lv_fm_name
      EXPORTING
        /1bcdwb/docparams  = lv_fp_docparams
        im_pernr           = p_pernr
      IMPORTING
        /1bcdwb/formoutput = lv_fp_formoutput
      EXCEPTIONS
        usage_error        = 1
        system_error       = 2
        internal_error     = 3
        OTHERS             = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
*Close spool job
    CALL FUNCTION 'FP_JOB_CLOSE'
*   IMPORTING
*     E_RESULT             = result
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
      CASE sy-subrc.
        WHEN OTHERS.
      ENDCASE.                           " CASE sy-subrc
    ENDIF.                               " IF sy-subrc <> 0.
  ENDMETHOD.



  METHOD imprime_form.

    CONSTANTS: lc_form_name         TYPE fpname VALUE 'Z_VOA_EMPLOYEE_FORM',
               lc_default_extension TYPE string VALUE 'PDF',
               lc_barcode_text      TYPE string VALUE 'https://www.globo.com/'.

    DATA: lv_fm_name         TYPE funcname,
          ls_fp_outputparams TYPE sfpoutputparams,
          lv_fp_docparams    TYPE sfpdocparams,
          lv_fp_formoutput   TYPE fpformoutput.

    DATA: lv_filename TYPE string,
          lv_path     TYPE string,
          lv_fullpath TYPE string,
          data_tab    TYPE solix_tab,
          lv_qrcode   TYPE xstring.




    TRY.
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = lc_form_name
          IMPORTING
            e_funcname = lv_fm_name.
      CATCH cx_fp_api_repository.
      CATCH cx_fp_api_usage.
      CATCH cx_fp_api_internal.

    ENDTRY.

    ls_fp_outputparams-getpdf = abap_true.
    ls_fp_outputparams-nodialog = abap_true.


    cl_rstx_barcode_renderer=>qr_code(
      EXPORTING
        i_module_size      = 20
        i_mode             = 'A'
        i_error_correction = 'H'
        i_rotation         = 0
        i_barcode_text     =  lc_barcode_text
      IMPORTING
        e_bitmap           = lv_qrcode
    ).
*CATCH cx_rstx_barcode_renderer.



    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = ls_fp_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
      CASE sy-subrc.
        WHEN OTHERS.
      ENDCASE.                           " CASE sy-subrc
    ENDIF.
* Calling Function module
    CALL FUNCTION lv_fm_name
      EXPORTING
        /1bcdwb/docparams  = lv_fp_docparams
        im_pernr           = p_pernr
        iv_qrcode          = lv_qrcode
      IMPORTING
        /1bcdwb/formoutput = lv_fp_formoutput
      EXCEPTIONS
        usage_error        = 1
        system_error       = 2
        internal_error     = 3
        OTHERS             = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
*Close spool job
    CALL FUNCTION 'FP_JOB_CLOSE'
*   IMPORTING
*     E_RESULT             = result
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
      CASE sy-subrc.
        WHEN OTHERS.
      ENDCASE.                           " CASE sy-subrc
    ENDIF.                               " IF sy-subrc <> 0.

    cl_gui_frontend_services=>file_save_dialog(
      EXPORTING
        default_extension         = lc_default_extension
      CHANGING
        filename                  =  lv_filename
        path                      = lv_path
        fullpath                  = lv_fullpath
      EXCEPTIONS
        cntl_error                = 1
        error_no_gui              = 2
        not_supported_by_gui      = 3
        invalid_default_file_name = 4
        OTHERS                    = 5
    ).
*  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4 INTO DATA (LS_MESSAGE_ERROR).
*  ENDIF.

    CHECK lv_fullpath IS NOT INITIAL.

    "Conversão do xstring para binário
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = lv_fp_formoutput-pdf
      TABLES
        binary_tab = data_tab.


    cl_gui_frontend_services=>gui_download(
       EXPORTING
         filename = lv_filename
         filetype = 'BIN'
       CHANGING
         data_tab = data_tab ).
    cl_gui_frontend_services=>execute(
      EXPORTING
        document = lv_filename ).
  ENDMETHOD.

ENDCLASS.
