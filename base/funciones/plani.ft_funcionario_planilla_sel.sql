CREATE OR REPLACE FUNCTION plani.ft_funcionario_planilla_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_funcionario_planilla_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tfuncionario_planilla'
 AUTOR: 		 (admin)
 FECHA:	        22-01-2014 16:11:08
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'plani.ft_funcionario_planilla_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_FUNPLAN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:08
	***********************************/

	if(p_transaccion='PLA_FUNPLAN_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						funplan.id_funcionario_planilla,
						funplan.finiquito,
						funplan.forzar_cheque,
						funplan.id_funcionario,
						funplan.id_planilla,
						funplan.id_lugar,
						funplan.id_uo_funcionario,
						funplan.estado_reg,
						funplan.id_usuario_reg,
						funplan.fecha_reg,
						funplan.id_usuario_mod,
						funplan.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,	
						funcio.desc_funcionario1::varchar
						from plani.tfuncionario_planilla funplan
						inner join segu.tusuario usu1 on usu1.id_usuario = funplan.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = funplan.id_usuario_mod
						inner join orga.vfuncionario funcio on funcio.id_funcionario = funplan.id_funcionario
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_FUNPLAN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:08
	***********************************/

	elsif(p_transaccion='PLA_FUNPLAN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_funcionario_planilla)
					    from plani.tfuncionario_planilla funplan
					    inner join segu.tusuario usu1 on usu1.id_usuario = funplan.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = funplan.id_usuario_mod
						inner join orga.vfuncionario funcio on funcio.id_funcionario = funplan.id_funcionario
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
					
	else
					     
		raise exception 'Transaccion inexistente';
					         
	end if;
					
EXCEPTION
					
	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;