*&---------------------------------------------------------------------*
*& Include          Z_VOA_IMPRIME_FORM_SRC
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  PARAMETERS: p_pernr TYPE persno OBLIGATORY.

  PARAMETERS: p_rad1 RADIOBUTTON GROUP rd1 DEFAULT 'X',
              p_rad2 RADIOBUTTON GROUP rd1.

 SELECTION-SCREEN END OF BLOCK b1.
