/*==============================================================*/
/* Crea todas las tabals y relaciones de la base de datos.		*/
/*==============================================================*/
/*==============================================================*/
/* DBMS name:      PostgreSQL 9.x                               */
/* Created on:     27/10/2017 20:56:52                          */
/*==============================================================*/
/*==============================================================*/
/* Table: CATEGORIA_PRODUCTO                                    */
/*==============================================================*/
create table CATEGORIA_PRODUCTO (
   ID_CATEGORIA         INT2                 not null,
   DESCRIPCION_CAT      VARCHAR(255)         not null,
   constraint PK_CATEGORIA_PRODUCTO primary key (ID_CATEGORIA)
);

/*==============================================================*/
/* Index: CATEGORIA_PRODUCTO_PK                                 */
/*==============================================================*/
create unique index CATEGORIA_PRODUCTO_PK on CATEGORIA_PRODUCTO (
ID_CATEGORIA
);

/*==============================================================*/
/* Table: COMUNA                                                */
/*==============================================================*/
create table COMUNA (
   ID_COMUNA            INT2                 not null,
   NOMBRE_COMUNA        VARCHAR(255)         not null,
   constraint PK_COMUNA primary key (ID_COMUNA)
);

/*==============================================================*/
/* Index: COMUNA_PK                                             */
/*==============================================================*/
create unique index COMUNA_PK on COMUNA (
ID_COMUNA
);

/*==============================================================*/
/* Table: CONTACTO_PROVEEDOR                                    */
/*==============================================================*/
create table CONTACTO_PROVEEDOR (
   ID_CONTACTO          INT4                 not null,
   ID_PROVEEDOR_CONT    INT8                 not null,
   NOMBRE_CONTACTO      VARCHAR(150)         not null,
   TELEFONO             VARCHAR(9)           null,
   CELULAR              VARCHAR(9)           null,
   E_MAIL               VARCHAR(255)         null,
   constraint PK_CONTACTO_PROVEEDOR primary key (ID_CONTACTO)
);

/*==============================================================*/
/* Index: CONTACTO_PROVEEDOR_PK                                 */
/*==============================================================*/
create unique index CONTACTO_PROVEEDOR_PK on CONTACTO_PROVEEDOR (
ID_CONTACTO
);

/*==============================================================*/
/* Index: CADA_PROVEEDOR_FK                                     */
/*==============================================================*/
create  index CADA_PROVEEDOR_FK on CONTACTO_PROVEEDOR (
ID_PROVEEDOR_CONT
);

/*==============================================================*/
/* Table: DOCUMENTO_COMPRA                                      */
/*==============================================================*/
create table DOCUMENTO_COMPRA (
   NUMERO_DOC           INT8                 not null,
   ID_PROVEEDOR_DOC     INT8                 not null,
   TIPO_ID_DOC          INT2                 not null,
   FECHA_DOC            DATE                 not null,
   FECHA_VENCIMIENTO_DOC DATE                 not null,
   NETO_DOC             INT8                 not null,
   PAGADO_DOC           BOOL                 not null,
   ID_FORMA_PAGO_DOC    INT2                 not null,
   constraint PK_DOCUMENTO_COMPRA primary key (NUMERO_DOC, ID_PROVEEDOR_DOC, TIPO_ID_DOC)
);

/*==============================================================*/
/* Index: DOCUMENTO_COMPRA_PK                                   */
/*==============================================================*/
create unique index DOCUMENTO_COMPRA_PK on DOCUMENTO_COMPRA (
NUMERO_DOC,
ID_PROVEEDOR_DOC,
TIPO_ID_DOC
);

/*==============================================================*/
/* Index: CADA_TIPO_TIENE_FK                                    */
/*==============================================================*/
create  index CADA_TIPO_TIENE_FK on DOCUMENTO_COMPRA (
TIPO_ID_DOC
);

/*==============================================================*/
/* Index: CADA_PROVEEDOR_EMITE_FK                               */
/*==============================================================*/
create  index CADA_PROVEEDOR_EMITE_FK on DOCUMENTO_COMPRA (
ID_PROVEEDOR_DOC
);

/*==============================================================*/
/* Index: CADA_FORMA_TIENE_FK                                   */
/*==============================================================*/
create  index CADA_FORMA_TIENE_FK on DOCUMENTO_COMPRA (
ID_FORMA_PAGO_DOC
);

/*==============================================================*/
/* Table: DOCUMENTO_COMPRA_DETALLE                              */
/*==============================================================*/
create table DOCUMENTO_COMPRA_DETALLE (
   NUMERO_DOC_DET       INT8                 not null,
   ID_PROVEEDOR_DET     INT8                 not null,
   TIPO_ID_DOC_DET      INT2                 not null,
   CODIGO_PRODUCTO_DOC_DET INT8                 not null,
   CANTIDAD             FLOAT8               not null,
   PRECIO               INT8                 not null,
   ITEM_DOC_DET         INT2                 not null,
   constraint PK_DOCUMENTO_COMPRA_DETALLE primary key (NUMERO_DOC_DET, ID_PROVEEDOR_DET, TIPO_ID_DOC_DET, ITEM_DOC_DET)
);

/*==============================================================*/
/* Index: DOCUMENTO_COMPRA_DETALLE_PK                           */
/*==============================================================*/
create unique index DOCUMENTO_COMPRA_DETALLE_PK on DOCUMENTO_COMPRA_DETALLE (
NUMERO_DOC_DET,
ID_PROVEEDOR_DET,
TIPO_ID_DOC_DET,
ITEM_DOC_DET
);

/*==============================================================*/
/* Index: CADA_DOCUMENTO_TIENE_FK                               */
/*==============================================================*/
create  index CADA_DOCUMENTO_TIENE_FK on DOCUMENTO_COMPRA_DETALLE (
NUMERO_DOC_DET,
ID_PROVEEDOR_DET,
TIPO_ID_DOC_DET
);

/*==============================================================*/
/* Index: CADA_DET_DOC_TIENE_PROD_FK                            */
/*==============================================================*/
create  index CADA_DET_DOC_TIENE_PROD_FK on DOCUMENTO_COMPRA_DETALLE (
CODIGO_PRODUCTO_DOC_DET
);

/*==============================================================*/
/* Table: FORMA_PAGO                                            */
/*==============================================================*/
create table FORMA_PAGO (
   ID_FORMA_PAGO        INT2                 not null,
   DESCRIPCION_FPAGO    VARCHAR(150)         not null,
   constraint PK_FORMA_PAGO primary key (ID_FORMA_PAGO)
);

/*==============================================================*/
/* Index: FORMA_PAGO_PK                                         */
/*==============================================================*/
create unique index FORMA_PAGO_PK on FORMA_PAGO (
ID_FORMA_PAGO
);

/*==============================================================*/
/* Table: GIRO                                                  */
/*==============================================================*/
create table GIRO (
   ID_GIRO              INT4                 not null,
   DESCRIPCION_GIRO     VARCHAR(255)         not null,
   constraint PK_GIRO primary key (ID_GIRO)
);

/*==============================================================*/
/* Index: GIRO_PK                                               */
/*==============================================================*/
create unique index GIRO_PK on GIRO (
ID_GIRO
);

/*==============================================================*/
/* Table: PRODUCTO                                              */
/*==============================================================*/
create table PRODUCTO (
   CODIGO_PRODUCTO      INT8                 not null,
   ID_CATEGORIA_PROD    INT2                 not null,
   NOMBRE_PRODUCTO      VARCHAR(255)         not null,
   ID_UNI_MED_PROD      INT2                 not null,
   STOCK_MINIMO         FLOAT8               not null,
   STOCK_MAXIMO         FLOAT8               not null,
   constraint PK_PRODUCTO primary key (CODIGO_PRODUCTO)
);

/*==============================================================*/
/* Index: PRODUCTO_PK                                           */
/*==============================================================*/
create unique index PRODUCTO_PK on PRODUCTO (
CODIGO_PRODUCTO
);

/*==============================================================*/
/* Index: CADA_CAT_TIENE_FK                                     */
/*==============================================================*/
create  index CADA_CAT_TIENE_FK on PRODUCTO (
ID_CATEGORIA_PROD
);

/*==============================================================*/
/* Index: CADA_UMED_TIENE_FK                                    */
/*==============================================================*/
create  index CADA_UMED_TIENE_FK on PRODUCTO (
ID_UNI_MED_PROD
);

/*==============================================================*/
/* Table: PROVEEDOR                                             */
/*==============================================================*/
create table PROVEEDOR (
   ID_PROVEEDOR         INT8                 not null,
   RUT                  INT8                 null,
   DIGITO_RUT           CHAR(1)              null,
   RAZON_SOCIAL         VARCHAR(255)         not null,
   DIRECCION            VARCHAR(255)         not null,
   ID_COMUNA_PRO        INT2                 not null,
   ID_GIRO_PRO          INT4                 not null,
   constraint PK_PROVEEDOR primary key (ID_PROVEEDOR)
);

/*==============================================================*/
/* Index: PROVEEDOR_PK                                          */
/*==============================================================*/
create unique index PROVEEDOR_PK on PROVEEDOR (
ID_PROVEEDOR
);

/*==============================================================*/
/* Index: CADA_COMUNA_FK                                        */
/*==============================================================*/
create  index CADA_COMUNA_FK on PROVEEDOR (
ID_COMUNA_PRO
);

/*==============================================================*/
/* Index: CADA_GIRO_TIENE_FK                                    */
/*==============================================================*/
create  index CADA_GIRO_TIENE_FK on PROVEEDOR (
ID_GIRO_PRO
);

/*==============================================================*/
/* Table: TIPO_DOCUMENTO                                        */
/*==============================================================*/
create table TIPO_DOCUMENTO (
   TIPO_ID              INT2                 not null,
   TIPO_DESCRIPCION     VARCHAR(255)         not null,
   TIPO_EXENTA          BOOL                 not null,
   constraint PK_TIPO_DOCUMENTO primary key (TIPO_ID)
);

/*==============================================================*/
/* Index: TIPO_DOCUMENTO_PK                                     */
/*==============================================================*/
create unique index TIPO_DOCUMENTO_PK on TIPO_DOCUMENTO (
TIPO_ID
);

/*==============================================================*/
/* Table: UNIDAD_MEDIDA                                         */
/*==============================================================*/
create table UNIDAD_MEDIDA (
   ID_UNI_MED           INT2                 not null,
   DESCRIPCION_UNI_MED  CHAR(6)              not null,
   constraint PK_UNIDAD_MEDIDA primary key (ID_UNI_MED)
);

/*==============================================================*/
/* Index: UNIDAD_MEDIDA_PK                                      */
/*==============================================================*/
create unique index UNIDAD_MEDIDA_PK on UNIDAD_MEDIDA (
ID_UNI_MED
);

alter table CONTACTO_PROVEEDOR
   add constraint FK_CONTACTO_CADA_PROV_PROVEEDO foreign key (ID_PROVEEDOR_CONT)
      references PROVEEDOR (ID_PROVEEDOR)
      on delete restrict on update restrict;

alter table DOCUMENTO_COMPRA
   add constraint FK_DOCUMENT_CADA_FORM_FORMA_PA foreign key (ID_FORMA_PAGO_DOC)
      references FORMA_PAGO (ID_FORMA_PAGO)
      on delete restrict on update restrict;

alter table DOCUMENTO_COMPRA
   add constraint FK_DOCUMENT_CADA_PROV_PROVEEDO foreign key (ID_PROVEEDOR_DOC)
      references PROVEEDOR (ID_PROVEEDOR)
      on delete restrict on update restrict;

alter table DOCUMENTO_COMPRA
   add constraint FK_DOCUMENT_CADA_TIPO_TIPO_DOC foreign key (TIPO_ID_DOC)
      references TIPO_DOCUMENTO (TIPO_ID)
      on delete restrict on update restrict;

alter table DOCUMENTO_COMPRA_DETALLE
   add constraint FK_DOCUMENT_CADA_DET__PRODUCTO foreign key (CODIGO_PRODUCTO_DOC_DET)
      references PRODUCTO (CODIGO_PRODUCTO)
      on delete restrict on update restrict;

alter table DOCUMENTO_COMPRA_DETALLE
   add constraint FK_DOCUMENT_CADA_DOCU_DOCUMENT foreign key (NUMERO_DOC_DET, ID_PROVEEDOR_DET, TIPO_ID_DOC_DET)
      references DOCUMENTO_COMPRA (NUMERO_DOC, ID_PROVEEDOR_DOC, TIPO_ID_DOC)
      on delete restrict on update restrict;

alter table PRODUCTO
   add constraint FK_PRODUCTO_CADA_CAT__CATEGORI foreign key (ID_CATEGORIA_PROD)
      references CATEGORIA_PRODUCTO (ID_CATEGORIA)
      on delete restrict on update restrict;

alter table PRODUCTO
   add constraint FK_PRODUCTO_CADA_UMED_UNIDAD_M foreign key (ID_UNI_MED_PROD)
      references UNIDAD_MEDIDA (ID_UNI_MED)
      on delete restrict on update restrict;

alter table PROVEEDOR
   add constraint FK_PROVEEDO_CADA_COMU_COMUNA foreign key (ID_COMUNA_PRO)
      references COMUNA (ID_COMUNA)
      on delete restrict on update restrict;

alter table PROVEEDOR
   add constraint FK_PROVEEDO_CADA_GIRO_GIRO foreign key (ID_GIRO_PRO)
      references GIRO (ID_GIRO)
      on delete restrict on update restrict;

