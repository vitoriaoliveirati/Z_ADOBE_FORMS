*&---------------------------------------------------------------------*
*& Report Z_VOA_IMPRIME_FORM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_voa_imprime_form.

INCLUDE: z_voa_imprime_form_cls, "Include para a classe.
          z_voa_imprime_form_src.
"Vai ter uma tela inicial que vai ter duas opções, exibir ou imprimir o formulário.

START-OF-SELECTION. "Onde vai começar a execução

  IF p_rad1 EQ abap_true. "ou 'x'
    lcl_application=>exibe_form( p_pernr = p_pernr ). "ctrl espaço
  ELSE.
    lcl_application=>imprime_form( p_pernr = p_pernr ).
  ENDIF.
