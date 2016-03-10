
--drop type t_status_umts_obj;
create type t_status_umts_obj as object (
  FECHA varchar2(13 char),
  SRL_CNT number,
  TRF_CNT number,
  CRS_CNT number,
  HSW_CNT number,
  CTP_CNT number,
  RRC_CNT number,
  YHO_CNT number,
  SHO_CNT number,
  IHO_CNT number,
  CTW_CNT number,
  CPI_CNT number,
  L3I_CNT number,
  PKT_CNT number
);

--drop type t_status_umts_tab;
create type t_status_umts_tab as table of t_status_umts_obj;