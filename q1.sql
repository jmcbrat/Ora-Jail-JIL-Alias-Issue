select 	id.entity_id AS entity_id,
				        id.OFFENDER_ID AS offender_id,
						pi.identity_id AS alias_id_pk,
						pi.name_family AS lastname,
						--decode(
						pi.name_first AS firstname,
						--,'.','',",",''  AS firstname,
						pi.name_other  AS middlename,
						pi.name_suffix AS suffixname,
				 	    NVL(NVL(to_char(EPIC.ef_epic_date_to_date(pi.DATE_OF_BIRTH),'MM/DD/YYYY'),
				 	    		to_char(EPIC.ef_epic_date_to_date(pi.BIRTH_DATE_APPROX),'MM/DD/YYYY')),
				 	                   'UNKNOWN') AS DOB,
				 	    decode(mf_jil_master_alias(id.entity_id, pi.IDENTITY_ID),1,'MAS','ALI') AS CODE_NAME_TYPE,
						sysdate,
				 	    soundex(pi.name_family) as soundexlast, soundex(pi.name_first) as soundexfirst,
				 	    translate(pi.name_family,
				                  'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',
				                  '2223334445556667777888999922233344455566677778889999') as numlast,
	                  translate(pi.name_first,
				                  'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',
				                  '2223334445556667777888999922233344455566677778889999') as numfirst,
	                  --MCMB_FNT_GENDERSHORT(pi.identity_id) as gender
	                  decode(ep.CODE_GENDER,'_NOSP','U',ep.CODE_GENDER) as gender
				FROM    EPIC.eh_person_identity pi,
						EPIC.eh_offender_ids id,
						epic.eh_entity_person ep
				WHERE	id.ENTITY_ID = pi.entity_id
				  and   id.entity_id = ep.entity_id
				  AND   mf_jil_master_alias(id.entity_id, pi.IDENTITY_ID) in (1,2)
				  --AND EXISTS (select 1 from EPIC.eh_active_booking ab where id.entity_id = ab.entity_id)
				  --and NOT mf_is_entity_HYTA_inmate(id.entity_id) = 'REMOVE'
				  and publicview.mf_is_entity_HYTA_inmate(id.entity_id) = 'NO'
				  AND (ep.JUVENILE_FLAG = 'N' or ep.JUVENILE_FLAG is null)
				  and (pi.name_family = 'ADDITIONAL' or pi.name_first = '.')
